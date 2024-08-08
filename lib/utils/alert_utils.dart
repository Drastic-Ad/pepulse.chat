import 'package:flutter/cupertino.dart';
import '../config.dart';

alertDialog({title, required List list, StringCallback? onTap}) {
  return showDialog(
      context: Get.context!,
      builder: (context) {
        return  DirectionalityRtl(
          child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.r8))),
              backgroundColor: appCtrl.appTheme.white,
              titlePadding: const EdgeInsets.all(Insets.i20),
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title!.toString().tr,
                          style: AppCss.manropeBold16.textColor(appCtrl.appTheme.darkText)),
                      Icon(CupertinoIcons.multiply, color: appCtrl.appTheme.darkText).inkWell(onTap: ()=> Get.back())
                    ]
                  ),
                  const VSpace(Sizes.s15),
                  Divider(color: appCtrl.appTheme.darkText.withOpacity(0.1),height: 1,thickness: 1)
                ]
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                  list.asMap().entries.map((e) => Row(
                      children: [
                        Image.asset(e.value["image"],height: Sizes.s44),
                        const HSpace(Sizes.s15),
                        Text(e.value["title"].toString().tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText))
                      ]
                  ).inkWell(onTap:()=> onTap!(e.key)).paddingOnly(bottom: e.key == list.length -1 ? Insets.i10 : Insets.i30)).toList()
              ).padding(horizontal: Sizes.s20,bottom: Insets.i20)),
        );
      }
  );
}


callAlertDialog({title, required List list, StringCallback? onTap}) {
  return showDialog(
      context: Get.context!,
      builder: (context) {
        return  DirectionalityRtl(
          child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.r8))),
              backgroundColor: appCtrl.appTheme.white,
              titlePadding: const EdgeInsets.all(Insets.i20),
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title!.toString().tr,
                          style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)),
                      Icon(CupertinoIcons.multiply, color: appCtrl.appTheme.darkText).inkWell(onTap: ()=> Get.back())
                    ]
                  ),
                  const VSpace(Sizes.s15),
                  Divider(color: appCtrl.appTheme.darkText.withOpacity(0.1),height: 1,thickness: 1)
                ]
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                  list.asMap().entries.map((e) => Row(
                      children: [
                        Image.asset(e.value["image"],height: Sizes.s44),
                        const HSpace(Sizes.s15),
                        Text(e.value["title"].toString().tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText))
                      ]
                  ).inkWell(onTap:()=> onTap!(e.key)).paddingOnly(bottom: e.key == list.length -1 ? Insets.i10 : Insets.i30)).toList()
              ).padding(horizontal: Sizes.s20,bottom: Insets.i20)),
        );
      }
  );
}