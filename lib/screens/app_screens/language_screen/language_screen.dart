
import 'package:chatzy/controllers/app_pages_controllers/language_controller.dart';

import '../../../config.dart';

class LanguageScreen extends StatelessWidget {
  final langCtrl = Get.put(LanguageController());

  LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(builder: (_) {
      return DirectionalityRtl(
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: appCtrl.appTheme.screenBG,
                title: Text(appFonts.changeYourLanguage.tr,
                    style: AppCss.manropeSemiBold16
                        .textColor(appCtrl.appTheme.darkText)),
                leading: ActionIconsCommon(
                    onTap: () => Get.back(),
                    icon: appCtrl.isRTL || appCtrl.languageVal == "ar"
                        ? eSvgAssets.arrowRight
                        : eSvgAssets.arrowLeft,
                    vPadding: Insets.i10,
                    hPadding: Insets.i10),
                elevation: 0),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  child:  GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: Insets.i100),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: appCtrl.languagesLists.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 20,
                          mainAxisExtent: 90,
                          mainAxisSpacing: 20.0,
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return appCtrl.languagesLists[index]
                        ["isActive"] ==
                            true
                            ? LanguageLayout(
                            value: appCtrl.languagesLists[index],
                            index: index,
                            selectedIndex: langCtrl.selectedIndex,
                            onTap: () =>
                                langCtrl.onLanguageSelectTap(
                                    index,
                                    appCtrl
                                        .languagesLists[index]))
                            : Container();
                      }).paddingAll(Insets.i20)
                ),
                ButtonCommon(
                    margin: Insets.i20,
                    title: appFonts.select,
                    onTap: () => Get.back()).backgroundColor(appCtrl.appTheme.screenBG).paddingOnly(bottom: Insets.i20).backgroundColor(appCtrl.appTheme.screenBG).height(66)
              ],
            )),
      );
    });
  }
}
