

import '../../../config.dart';
import '../../../widgets/common_app_bar.dart';

class FingerPrintLock extends StatelessWidget {
  final fingerLockCtr = Get.put(AddFingerprintController());

  FingerPrintLock({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddFingerprintController>(builder: (_) {
      return DirectionalityRtl(
        child: PopScope(
         canPop: false,
          child: Scaffold(
              appBar: CommonAppBar(text: appFonts.fingerprintLock.tr,isBack: false,),
              backgroundColor: appCtrl.appTheme.white,
              body: Column(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(appFonts.unlockWithFingerprint.tr,
                          style: AppCss.manropeblack18.textColor(
                              appCtrl.appTheme.darkText)),
                      const VSpace(Sizes.s5),
                      Text(appFonts.unlockWithFingerprintDesc.tr,
                          textAlign: TextAlign.center,
                          style: AppCss.manropeMedium14
                              .textColor(appCtrl.appTheme.greyText)),


                    ]),
                Image.asset(eImageAssets.fingerScanner)
              ]).paddingSymmetric(
                  horizontal: Insets.i20,
                  vertical: Insets.i10
              )),
        ),
      );
    });
  }
}
