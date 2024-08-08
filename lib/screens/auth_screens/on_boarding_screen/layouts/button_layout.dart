import '../../../../config.dart';

class BottomLayout extends StatelessWidget {
  const BottomLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      builder: (onBoardingCtrl) {
        return Stack(alignment: Alignment.center, children: [
          onBoardingCtrl.selectIndex == 0
              ? SizedBox(
                      height: Sizes.s60,
                      child: Image.asset(eImageAssets.buttonBg1,
                          color: appCtrl.appTheme.primary))
                  .paddingOnly(left: Insets.i25, bottom: Insets.i5)
              : onBoardingCtrl.selectIndex == 1
                  ? SizedBox(
                          height: Sizes.s60,
                          child: Image.asset(eImageAssets.buttonBg2,
                              color: appCtrl.appTheme.primary))
                      .paddingOnly(left: Insets.i8)
                  : const SizedBox(height: Sizes.s62, width: Sizes.s62).decorated(
                      color: appCtrl.appTheme.trans,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: appCtrl.appTheme.primary, width: 2)),
          SizedBox(
                  height: Sizes.s52,
                  width: Sizes.s52,
                  child: SvgPicture.asset(eSvgAssets.rightArrow,
                      fit: BoxFit.scaleDown))
              .decorated(shape: BoxShape.circle, color: appCtrl.appTheme.primary)
              .inkWell(onTap: () => onBoardingCtrl.onTapPageChange())
        ]);
      }
    );
  }
}
