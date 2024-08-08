import '../config.dart';

class MediaShareLayout extends StatelessWidget {
  final String? title;
  final String? mediaCount;
  final List? list;
  final int? index;
  final GestureTapCallback? onTap;

  const MediaShareLayout({super.key, this.title, this.mediaCount, this.onTap,this.index,this.list});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("${title.toString().tr} ($mediaCount)",
          style: AppCss.manropeSemiBold14.textColor(appCtrl.appTheme.darkText)),
      SvgPicture.asset(appCtrl.isRTL || appCtrl.languageVal == "ar"
          ? eSvgAssets.arrowLeft
          : eSvgAssets.arrowRight,colorFilter: ColorFilter.mode(appCtrl.appTheme.darkText, BlendMode.srcIn))
    ]).inkWell(onTap: onTap).paddingOnly(bottom: index != list!.length -1 ? Insets.i20 : 0);
  }
}
