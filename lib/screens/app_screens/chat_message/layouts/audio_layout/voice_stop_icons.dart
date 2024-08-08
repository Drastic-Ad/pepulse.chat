import 'package:flutter_sound/public/flutter_sound_recorder.dart';

import '../../../../../config.dart';

class VoiceStopIcons extends StatelessWidget {
  final VoidCallback? onPressed;
  final FlutterSoundRecorder? mRecorder;
  const VoiceStopIcons({super.key,this.onPressed,this.mRecorder});

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: Sizes.s50,
        width: Sizes.s50,
        decoration: BoxDecoration(
          color: appCtrl.isTheme
              ? appCtrl.appTheme.white
              : appCtrl.appTheme.primary,
            shape: BoxShape.circle
        ),
        child: IconButton(
            onPressed: onPressed,
            icon: mRecorder != null
                ? mRecorder!.isRecording
                ? Icon(Icons.stop,
                color: appCtrl.appTheme.white)
                : SvgPicture.asset(eSvgAssets.microphoneFill)
                : SvgPicture.asset(eSvgAssets.microphoneFill))).paddingAll(Insets.i5).decorated(color: appCtrl.appTheme.primary.withOpacity(0.3),shape: BoxShape.circle);
  }
}
