import '../../../../config.dart';

class IconCircle extends StatelessWidget {
  const IconCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Icon(Icons.circle,
            color: appCtrl.appTheme.online,
            size: Sizes.s12)
            .paddingAll(Insets.i2)
            .decorated(
            color: appCtrl.appTheme.sameWhite,
            shape: BoxShape.circle));
  }
}
