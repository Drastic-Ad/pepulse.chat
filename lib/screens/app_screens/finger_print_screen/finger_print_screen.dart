import '../../../config.dart';

class FingerPrintScreen extends StatelessWidget {
  final fingerCtrl = Get.put(AddFingerprintController());

  FingerPrintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddFingerprintController>(
      builder: (_) {
        return DirectionalityRtl(
          child: Scaffold(
            appBar: AppBar(
                backgroundColor: appCtrl.appTheme.screenBG,
                title: Text(appFonts.addFingerprint.tr,
                    style: AppCss.manropeSemiBold16
                        .textColor(appCtrl.appTheme.darkText)),
                leading: ActionIconsCommon(
                    onTap: () => Get.back(),
                    icon:appCtrl.isRTL || appCtrl.languageVal == "ar" ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
                    vPadding: Insets.i10,
                    hPadding: Insets.i10),
                elevation: 0),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const VSpace(Sizes.s50),
                Text(appFonts.placeYourFinger.tr,
                    style: AppCss.manropeSemiBold18
                        .textColor(appCtrl.appTheme.darkText)),
                const VSpace(Sizes.s10),
                Text(appFonts.pressTheSensor.tr,
                    textAlign: TextAlign.center,
                    style:
                        AppCss.manropeMedium14.textColor(appCtrl.appTheme.greyText)),
                const VSpace(Sizes.s90),
                Image.asset(eImageAssets.fingerScanner,
                        height: Sizes.s120, width: Sizes.s120)
                    .paddingAll(Insets.i40)
                    .decorated(
                        color: const Color(0xff7F8384).withOpacity(0.15),
                        shape: BoxShape.circle)
              ]
            ).alignment(Alignment.center)
          ),
        );
      }
    );
  }
}
