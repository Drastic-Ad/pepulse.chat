import '../config.dart';

class BackIcon extends StatelessWidget {
  final bool verticalPadding;
  const BackIcon({super.key,this.verticalPadding = false});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      appCtrl.isRTL || appCtrl.languageVal == "ar" ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
      height: Sizes.s18,
      fit: BoxFit.scaleDown
    ).boxDecoration()
        .marginSymmetric(horizontal: Insets.i20, vertical: Insets.i20)
        .inkWell(onTap: () => Get.back());
  }
}
