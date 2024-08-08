import '../config.dart';

class CommonNoteEncrypt extends StatelessWidget {
  const CommonNoteEncrypt({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Insets.i20,vertical: Insets.i10),
      padding:const EdgeInsets.symmetric(horizontal: Insets.i15,vertical: Insets.i12),
      decoration: ShapeDecoration(
          color: appCtrl.isTheme ? appCtrl.appTheme.white : appCtrl.appTheme.borderColor,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
                cornerRadius: 12, cornerSmoothing: 1),
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(eSvgAssets.lock).paddingOnly(top: Insets.i4),
          const HSpace(Sizes.s5),
          Expanded(
            child: Text(
              appFonts.noteEncrypt.tr,
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: AppCss.manropeMedium14
                  .textColor(appCtrl.appTheme.darkText)
                  .letterSpace(.13).textHeight(1.6),
            )
          ),
        ],
      ),
    );
  }
}
