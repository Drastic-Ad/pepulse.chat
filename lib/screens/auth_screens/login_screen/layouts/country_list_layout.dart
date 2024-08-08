
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/cupertino.dart';
import '../../../../config.dart';

class CountryListLayout extends StatelessWidget {
  final String? dialCode;
  final ValueChanged<CountryCode?>? onChanged;
  const CountryListLayout({super.key,this.dialCode, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Sizes.s48,
        child: CountryListPick(
            useUiOverlay: false,

            appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading:
                Icon(Icons.arrow_back, color: appCtrl.appTheme.sameWhite)
                    .inkWell(onTap: () => Get.back()),
                title: Text(appFonts.selectCountry.tr,
                    style: AppCss.manropeblack18
                        .textColor(appCtrl.appTheme.sameWhite)),
                elevation: 0,
                backgroundColor: appCtrl.appTheme.primary),
            pickerBuilder: (context, CountryCode? countryCode) {
              return Row(children: [
                Text(dialCode ??"",
                    style: AppCss.manropeMedium14
                        .textColor(appCtrl.appTheme.greyText))
                    .paddingSymmetric(horizontal: Insets.i5),
                Icon(CupertinoIcons.chevron_down,
                    size: Sizes.s16, color: appCtrl.appTheme.greyText)
              ]);
            },
            theme: CountryTheme(
                alphabetSelectedBackgroundColor: appCtrl.appTheme.primary),
            initialSelection:dialCode ?? "+91",
            onChanged: onChanged)).decorated(
        color: appCtrl.appTheme.greyText.withOpacity(0.05),
        border:
        Border.all(color: appCtrl.appTheme.greyText.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r8)));
  }
}
