import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../../../../config.dart';

import 'audio_layout/voice_stop_icons.dart';

class AudioRecordingPlugin extends StatefulWidget {
  final String? type;
  final int? index;

  const AudioRecordingPlugin({super.key, this.type, this.index})
     ;

  @override
  AudioRecordingPluginState createState() => AudioRecordingPluginState();
}

class AudioRecordingPluginState extends State<AudioRecordingPlugin> {
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  bool isLoading = false;
  Codec codec = Codec.aacMP4;
  late String recordFilePath;
  int counter = 0;
  String statusText = "";
  bool isRecording = false;
  bool isComplete = false;
  bool mPlaybackReady = false;
  String mPath = 'tau_file.mp4';
  Timer? _timer;
  int recordingTime = 0;
  String? filePath;
  bool mPlayerIsInit = false;
  bool mRecorderIsInited = false;
  File? recordedFile;
  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  bool isPlaying = false;

  AudioPlayer player = AudioPlayer();

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }

    String fileName = DateTime.now().day.toString() +
        DateTime.now().month.toString() +
        DateTime.now().year.toString() +
        DateTime.now().hour.toString() +
        DateTime.now().minute.toString() +
        DateTime.now().second.toString() +
        DateTime.now().millisecond.toString();
    return "$sdPath/$fileName.mp3";
  }

  Future<void> checkPermission() async {
    /*  if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }*/

    await mRecorder!.openRecorder();
    mRecorderIsInited = true;
    setState(() {});

    if (!await mRecorder!.isEncoderSupported(codec) && kIsWeb) {
      log("CHECK MRECORD :: ${!await mRecorder!.isEncoderSupported(codec) && kIsWeb}");
      codec = Codec.opusWebM;
      mPath = 'tau_file.webm';
      log("CHECK MRECORD 3:: ${!await mRecorder!.isEncoderSupported(codec) && kIsWeb}");
      if (!await mRecorder!.isEncoderSupported(codec) && kIsWeb) {
        mRecorderIsInited = true;
        return;
      }
    }
    mRecorderIsInited == true;
    log("MROECOD :: $mRecorderIsInited");
  }

  // record audio
  getRecorderFn() {
    mRecorderIsInited = true;
    if (!mRecorderIsInited || !mPlayer!.isStopped) {
      log("RECORDER1::");
      return null;
    }

    mRecorder!.isStopped ? record() : stopRecorder();
  }

  // record audio
  record() async {
    log("START RECORDING");
    Directory directory = await getApplicationDocumentsDirectory();
    String filepath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    mPath = filepath;
    mRecorder!.startRecorder(toFile: filepath, codec: codec).then((value) {
      setState(() {});
    });
    recordFilePath = await getFilePath();
    startTimer();
  }

  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      recordingTime++;
      setState(() {});
    });
  }

  // stop recording method
  stopRecorder() async {
    log("STOP RECORD");
    await mRecorder!.stopRecorder().then((value) {
      mPlaybackReady = true;
      _timer!.cancel();
      recordedFile = File(mPath);
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    mPlayer!.openPlayer().then((value) {
      log("OPEN PLAYER LOG");
      mPlayerIsInit = true;
      setState(() {});
    });
    setState(() {});
    checkPermission().then((value) {
      log("g");
      if (recordingTime == 0) {
        getRecorderFn();
      }
    });
    super.initState();
  }

  // play recorded audio
  getPlaybackFn() {
    if (!mPlayerIsInit || !mPlaybackReady || !mRecorder!.isStopped) {
      return null;
    }
    return mPlayer != null
        ? mPlayer!.isStopped
            ? play
            : stopPlayer
        : play;
  }

  // play recorded audio
  void play() {
    assert(mPlayerIsInit &&
        mPlaybackReady &&
        mRecorder!.isStopped &&
        mPlayer!.isStopped);
    mPlayer!
        .startPlayer(
            fromURI: mPath,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  // stop player
  void stopPlayer() {
    mPlayer!.stopPlayer().then((value) {
      _timer!.cancel();
      recordedFile = File(mPath);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          _timer!.cancel();
          player.dispose();
          Get.back();
        },

        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Voice Note",
                      style: AppCss.manropeSemiBold16
                          .textColor(appCtrl.appTheme.darkText))
                  .paddingSymmetric(vertical: Insets.i15),
              Divider(
                  height: 1, thickness: 1, color: appCtrl.appTheme.borderColor),
              const VSpace(Sizes.s15),
              Column(children: [
                VerticalDivider(
                        thickness: 1,
                        color: appCtrl.appTheme.primary.withOpacity(0.4))
                    .paddingSymmetric(horizontal: Insets.i10),
                if (mRecorder!.isRecording)
                  Image.asset(eImageAssets.waves,
                      height: Sizes.s60, width: Sizes.s60),
                const VSpace(Sizes.s8),
                Text(recordingTime.toString(),
                    style: AppCss.manropeSemiBold14
                        .textColor(appCtrl.appTheme.primary))
              ]),
              const VSpace(Sizes.s20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.clear_rounded, color: appCtrl.appTheme.redColor)
                    .inkWell(onTap: () => Get.back()),
                VoiceStopIcons(
                        onPressed: () {
                          getRecorderFn();
                        },
                        mRecorder: mRecorder)
                    .paddingSymmetric(horizontal: Insets.i20),
                Icon(Icons.check,
                        color: recordingTime != 0 && mRecorder!.isStopped
                            ? appCtrl.appTheme.darkText
                            : appCtrl.appTheme.borderColor)
                    .inkWell(
                        onTap: recordingTime != 0 && mRecorder!.isStopped
                            ? () {
                                if (mRecorder!.isStopped) {
                                  Get.back(result: mPath);
                                }
                              }
                            : () {})
              ]),
              if (isLoading)
                Padding(
                    padding: const EdgeInsets.all(Insets.i10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                              height: Sizes.s20,
                              width: Sizes.s20,
                              child: CircularProgressIndicator()),
                          const HSpace(Sizes.s10),
                          Text(appFonts.audioProcess.tr)
                        ]))
            ]));
  }
}
