import '../../../../../config.dart';

class LeadingBack extends StatelessWidget {
  const LeadingBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(Insets.i12),
      margin:const EdgeInsets.symmetric( horizontal: Insets.i20, vertical: Insets.i20),
      decoration:  ShapeDecoration(
        color: appCtrl.appTheme.white,
        shape:   SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 8,cornerSmoothing: 1)),
      ),
      child: SvgPicture.asset(
        appCtrl.isRTL
            ? eSvgAssets.arrow
            : eSvgAssets.arrowLeft,
        height: Sizes.s18
      )

    ).inkWell(onTap: () => Get.back());
  }
}
