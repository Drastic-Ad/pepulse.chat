import 'package:flutter_sound/public/flutter_sound_player.dart';

import '../../../../../config.dart';

class StopArrowIcons extends StatelessWidget {
  final VoidCallback? onPressed;
  final FlutterSoundPlayer? mPlayer;
  const StopArrowIcons({super.key,this.onPressed,this.mPlayer});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Sizes.s50,
        width: Sizes.s50,
        decoration: BoxDecoration(
            color: appCtrl.isTheme
                ? appCtrl.appTheme.white
                : appCtrl.appTheme.primary,
            borderRadius:
            const BorderRadius.all(Radius.circular(100))),
        child: IconButton(
            onPressed: onPressed,
            color: appCtrl.appTheme.darkText,
            icon: Icon(
              mPlayer != null
                  ? mPlayer!.isPlaying
                  ? Icons.stop
                  : Icons.play_arrow
                  : Icons.play_arrow,
              color: appCtrl.appTheme.white,
            )));
  }
}
