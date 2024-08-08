/*
import '../../../../../config.dart';

class BlockReportLayout extends StatelessWidget {

  final String? name,icon;
  final GestureTapCallback? onTap;
  const BlockReportLayout({super.key,this.name,this.icon,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal:Insets.i20,vertical: Insets.i7),
        padding: const EdgeInsets.symmetric(
            vertical: Insets.i16, horizontal: Insets.i18),
        decoration: ShapeDecoration(
            color: const Color(0xFFFFEDED),
            shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                    cornerRadius: 12, cornerSmoothing: 1))),
        child: Row(children: [
          SvgPicture.asset(
             icon!,
              color: appCtrl.appTheme.redColor),
          const HSpace(Sizes.s10),
          Text(
              name!,
              style: AppCss.poppinsSemiBold14
                  .textColor(appCtrl.appTheme.redColor))
        ])).inkWell(onTap: onTap);
  }
}
*/
