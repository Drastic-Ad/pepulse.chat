import '../config.dart';

class CommonAssetImage extends StatelessWidget {
  final double? height,width;
  const CommonAssetImage({super.key,this.width,this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
            color: appCtrl.appTheme.borderColor,
            shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                    cornerRadius: 12, cornerSmoothing: 1))),
        child: Image.asset(eImageAssets.profileAnon,
            height: height,
            width: width,
            fit: BoxFit.cover,
            color: appCtrl.appTheme.white)
            .paddingAll(Insets.i15));
  }
}
