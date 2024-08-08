import '../../../../config.dart';

class OnBoardTextData extends StatelessWidget {
  const OnBoardTextData({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(builder: (onBoardingCtrl) {
      return SizedBox(
              height: Sizes.s165,
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                Text(
                        onBoardingCtrl.selectIndex == 0
                            ? appFonts.nowDiscuss.tr
                            : onBoardingCtrl.selectIndex == 1
                                ? appFonts.seeEachOther.tr
                                : appFonts.planAnything.tr,
                        style: AppCss.manropeSemiBold20
                            .textColor(appCtrl.appTheme.darkText))
                    .paddingOnly(top: Insets.i30, bottom: Insets.i10),
                Image.asset(eImageAssets.fanIcon, width: Sizes.s90),
                const VSpace(Sizes.s10),
                Text(
                        onBoardingCtrl.selectIndex == 0
                            ? appFonts.createConferences.tr
                            : onBoardingCtrl.selectIndex == 1
                                ? appFonts.getToSee.tr
                                : appFonts.justCall.tr,
                        textAlign: TextAlign.center,
                        style: AppCss.manropeMedium14
                            .textColor(appCtrl.appTheme.greyText)
                            .textHeight(1.5))
                    .paddingSymmetric(horizontal: Insets.i20)
              ]))
          .decorated(
              color: appCtrl.appTheme.white,
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppRadius.r8)),
              border: Border.all(
                  color: appCtrl.appTheme.greyText.withOpacity(0.15)))
          .padding(horizontal: Insets.i20, bottom: Insets.i30, top: Insets.i10);
    });
  }
}
