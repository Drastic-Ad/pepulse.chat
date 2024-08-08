import '../../../../config.dart';

class SettingLayout extends StatelessWidget {
  final dynamic val;
  final GestureTapCallback? onTap;
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final int? index;

  const SettingLayout(
      {super.key,
      this.val,
      this.onTap,
      this.value,
      this.onChanged,
      this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (appCtrl) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            SvgPicture.asset(val["icon"],colorFilter: ColorFilter.mode(appCtrl.appTheme.darkText, BlendMode.srcIn)),
            const HSpace(Sizes.s15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val["title"].toString().tr,
                    style:
                        AppCss.manropeSemiBold14.textColor(appCtrl.appTheme.darkText)),
                if(val['title'] == appFonts.syncNow)
                Text(appFonts.syncNowSubTitle.tr,
                    style:
                    AppCss.manropeMedium12.textColor(appCtrl.appTheme.greyText)).marginOnly(top: 5),
              ],
            )
          ]),
          val["title"] == appFonts.rtl || val["title"] == appFonts.theme || val["title"] == appFonts.fingerLock
              ? FlutterSwitch(
                  activeColor: appCtrl.appTheme.primary.withOpacity(0.2),
                  activeToggleColor: appCtrl.appTheme.primary,
                  inactiveColor: appCtrl.appTheme.borderColor,
                  width: Sizes.s40,
                  height: Sizes.s24,
                  toggleSize: Sizes.s16,
                  value: value!,
                  borderRadius: AppRadius.r12,
                  onToggle: onChanged!
                )
              : SvgPicture.asset(appCtrl.isRTL ? eSvgAssets.arrowLeft : eSvgAssets.arrowRight,colorFilter: ColorFilter.mode(appCtrl.appTheme.darkText, BlendMode.srcIn))
        ])
            .paddingAll(Insets.i15)
            .boxDecoration()
            .inkWell(onTap: onTap)
            .paddingOnly(bottom: Insets.i20);
      }
    );
  }
}
