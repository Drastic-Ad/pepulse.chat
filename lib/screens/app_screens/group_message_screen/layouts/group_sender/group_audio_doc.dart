import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import '../../../../../config.dart';


class GroupAudioDoc extends StatefulWidget {
  final VoidCallback? onLongPress, onTap;
  final MessageModel? document;

  final bool isReceiver;
  final String? currentUserId;

  const GroupAudioDoc(
      {super.key,
      this.onLongPress,
      this.document,
      this.isReceiver = false,
      this.currentUserId,
      this.onTap})
     ;

  @override
  State<GroupAudioDoc> createState() => _GroupAudioDocState();
}

class _GroupAudioDocState extends State<GroupAudioDoc>
    with WidgetsBindingObserver {

  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration positions = Duration.zero;
  AudioPlayer audioPlayer = AudioPlayer();
  int value = 2;

  void play() async {
    log("play");
    String url = decryptMessage(widget.document!.content).contains("-BREAK")
        ? decryptMessage(widget.document!.content).split("-BREAK-")[1]
        : decryptMessage(widget.document!.content);

    log("time : ${value.minutes}");
    audioPlayer.play(UrlSource(url));
  }

  void pause() {
    audioPlayer.pause();
  }

  void seek(Duration position) {
    log("pso :$position");
    audioPlayer.seek(position);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  onStopPlay() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      play();
    }
    setState(() {});
  }
  /// Optional
  Widget slider() {
    return SliderTheme(
      data: SliderThemeData(overlayShape: SliderComponentShape.noThumb),
      child: Slider(
          value: timeProgress.toDouble(),
          max: audioDuration.toDouble(),
          activeColor: appCtrl.appTheme.sameWhite,
          inactiveColor: appCtrl.appTheme.sameWhite,
          onChanged: (value) async {
            seekToSec(value.toInt());
          }),
    ).width(Sizes.s130);
  }

  @override
  void initState() {
    super.initState();

    /// Compulsory
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      log("state : $state");
      isPlaying = state == PlayerState.playing;
    });
    String url = decryptMessage(widget.document!.content).contains("-BREAK")
        ? decryptMessage(widget.document!.content).split("-BREAK-")[1]
        : decryptMessage(widget.document!.content);

    audioPlayer.setSourceUrl(url);

    audioPlayer.onPositionChanged.listen((position) async {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });

    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
  }

  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer
        .seek(newPos); // Jumps to the given position within the audio file
  }

  /// Optional
  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      audioPlayer.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      log("AUDIO EMOJI ${widget.document!.emoji}");
      return Stack(
        alignment: appCtrl.isRTL || appCtrl.languageVal == "ar" ? Alignment.bottomRight : Alignment.bottomLeft,
        children: [
          InkWell(
              onLongPress: widget.onLongPress,
              onTap: widget.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      margin:
                      const EdgeInsets.symmetric(vertical: Insets.i5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: Insets.i15),
                      decoration: ShapeDecoration(
                          color: widget.isReceiver
                              ? appCtrl.appTheme.primary.withOpacity(0.5)
                              : appCtrl.appTheme.primary,
                          shape: const SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.only(
                                  topLeft: SmoothRadius(
                                    cornerRadius: 18,
                                    cornerSmoothing: 1,
                                  ),
                                  topRight: SmoothRadius(
                                    cornerRadius: 18,
                                    cornerSmoothing: 1,
                                  ),
                                  bottomLeft: SmoothRadius(
                                      cornerRadius: 18,
                                      cornerSmoothing: 1)))
                      ),
                      height: Sizes.s90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (!widget.isReceiver)
                                  Row(children: [
                                    decryptMessage(widget.document!.content)
                                        .contains("-BREAK-")
                                        ? SvgPicture.asset(eSvgAssets.headPhone)
                                        .paddingAll(Insets.i10)
                                        .decorated(
                                        color:
                                        appCtrl.appTheme.redColor,
                                        shape: BoxShape.circle)
                                        : Container()
                                  ]).paddingOnly(right: Insets.i5),
                                if (widget.isReceiver) const HSpace(Sizes.s10),
                                SizedBox(
                                    height: Sizes.s40,
                                    width: Sizes.s40,
                                    child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              isPlaying
                                                  ? eSvgAssets.pause
                                                  : eSvgAssets.arrow,
                                              height: Sizes.s15,
                                              width: Sizes.s15,
                                              alignment: Alignment.center,
                                              fit: BoxFit.scaleDown,
                                              colorFilter: ColorFilter.mode(
                                                  appCtrl.appTheme.primary,
                                                  BlendMode.srcIn)).paddingOnly(left: isPlaying
                                              ? 0 : Insets.i2)
                                        ]))
                                    .alignment(Alignment.center)
                                    .decorated(
                                    color: appCtrl.appTheme.white,
                                    shape: BoxShape.circle)
                                    .inkWell(onTap: () => onStopPlay())
                                    .paddingOnly(right: appCtrl.isRTL || appCtrl.languageVal == "ar" ? 0 : Insets.i10, left: appCtrl.isRTL || appCtrl.languageVal == "ar" ? Insets.i10 : 0 ),
                                IntrinsicHeight(
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(children: [
                                            slider().width(
                                                widget.isReceiver ? 150 : 160),
                                            const VSpace(Sizes.s5),
                                            Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [

                                                  Text(getTimeString(timeProgress),
                                                      style: AppCss.manropeMedium12
                                                          .textColor(appCtrl
                                                          .appTheme.sameWhite)),
                                                  const HSpace(Sizes.s80),
                                                  Text(getTimeString(audioDuration),
                                                      style: AppCss.manropeMedium12
                                                          .textColor(appCtrl
                                                          .appTheme.sameWhite))
                                                ])
                                          ]).marginOnly(top: Insets.i16)
                                        ])),

                              ]),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (widget.document!.isFavourite != null)
                                if (widget.document!.isFavourite == true)
                                  if(appCtrl.user["id"].toString() == widget.document!.favouriteId.toString())
                                    Icon(Icons.star,
                                        color: appCtrl.appTheme.sameWhite,
                                        size: Sizes.s10),
                              const HSpace(Sizes.s3),
                              if (!widget.isReceiver)
                                Icon(Icons.done_all_outlined,
                                    size: Sizes.s15,
                                    color: widget.document!.isSeen == true
                                        ? appCtrl.appTheme.sameWhite
                                        : appCtrl.appTheme.tick),
                              const HSpace(Sizes.s5),
                              Text(
                                DateFormat('hh:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(widget.document!.timestamp!))),
                                style: AppCss.manropeMedium12
                                    .textColor(appCtrl.appTheme.sameWhite),
                              )
                            ],
                          ).marginSymmetric(
                              vertical: Insets.i10)
                        ],
                      )),

                ]
              )
              /*.decorated(
                          color: appCtrl.appTheme.primary,
                          borderRadius: SmoothBorderRadius(
                              cornerRadius: 15, cornerSmoothing: 1))*/
                  .paddingSymmetric(horizontal: Insets.i10))
              .paddingOnly(bottom: Insets.i5),
          if (widget.document!.emoji != null)
            EmojiLayout(emoji: widget.document!.emoji)
        ],
      );
    });
  }
}
