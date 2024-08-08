import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../config.dart';

class EditGroupDetailScreen extends StatelessWidget {
  final groupTitleCtrl = Get.isRegistered<GroupChatMessageController>()
      ? Get.find<GroupChatMessageController>()
      : Get.put(GroupChatMessageController());

  EditGroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (groupTitleCtrl) {
      log("EDIT GROUP ${groupTitleCtrl.groupImage}");
      return Scaffold(
          appBar: AppBar(
            backgroundColor: appCtrl.appTheme.primary,
            toolbarHeight: Sizes.s70,
            shape: SmoothRectangleBorder(
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 1)),
            automaticallyImplyLeading: false,
            leading: SvgPicture.asset(
                    appCtrl.isRTL ? eSvgAssets.arrowLeft : eSvgAssets.arrowLeft,
                    colorFilter: ColorFilter.mode(
                        appCtrl.appTheme.sameWhite, BlendMode.srcIn),
                    height: Sizes.s18)
                .paddingAll(Insets.i10)
                .newBoxDecoration()
                .padding(horizontal: Insets.i8, vertical: Insets.i15)
                .inkWell(onTap: () {
              Get.back();
            }),
            title: Text(appFonts.editGroupDetails.tr,
                style: AppCss.manropeSemiBold16
                    .textColor(appCtrl.appTheme.sameWhite)),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: appCtrl.appTheme.primary,
              child: Icon(Icons.check,color: appCtrl.appTheme.sameWhite),
              onPressed: () async{
                groupTitleCtrl.update();
                if (groupTitleCtrl.textNameController.text !=
                    groupTitleCtrl.pName) {
                  await FirebaseFirestore.instance
                      .collection(collectionName.groups)
                      .doc(groupTitleCtrl.pId)
                      .update({
                    "name": groupTitleCtrl.textNameController.text
                  }).then((value) {
                    groupTitleCtrl.pName =
                        groupTitleCtrl.textNameController.text;

                    groupTitleCtrl.update();
                  });
                }
                if (groupTitleCtrl.textDescController.text !=
                    groupTitleCtrl.allData["desc"]) {
                  await FirebaseFirestore.instance
                      .collection(collectionName.groups)
                      .doc(groupTitleCtrl.pId)
                      .update({
                    "desc":
                    groupTitleCtrl.textDescController.text
                  }).then((value) {
                    groupTitleCtrl.allData["desc"] =
                        groupTitleCtrl.textDescController.text;
                    groupTitleCtrl.update();
                  });
                }
                Get.back();
              }),
          body: SingleChildScrollView(
            child: Column(children: [
              Stack(alignment: Alignment.bottomCenter, children: [
                ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadius.r8)),
                        child: Image.asset(eImageAssets.titleHalfCircle))
                    .paddingOnly(bottom: Insets.i40),
                Stack(alignment: Alignment.bottomRight, children: [
                  SizedBox(
                    width: Sizes.s80,
                    height: Sizes.s80,
                    child: groupTitleCtrl.groupImage == null || groupTitleCtrl.groupImage == ""
                        ? DottedBorder(
                                borderType: BorderType.RRect,
                                color: appCtrl.appTheme.greyText.withOpacity(0.6),
                                radius: const Radius.circular(AppRadius.r50),
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(AppRadius.r5)),
                                    child: SizedBox(
                                            child: Icon(CupertinoIcons.add,
                                                    size: Sizes.s20,
                                                    color: appCtrl.appTheme.greyText.withOpacity(0.6))
                                                .paddingAll(Insets.i3)
                                                .decorated(borderRadius: BorderRadius.circular(AppRadius.r8), border: Border.all(color: appCtrl.appTheme.greyText.withOpacity(0.6))))
                                        .alignment(Alignment.center)))
                            .paddingAll(Insets.i4)
                            .inkWell(onTap: () => groupTitleCtrl.pickerCtrl.imagePickerOption(context, isCreateGroup: true))
                        : ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r50)), child: Image.network(groupTitleCtrl.groupImage!, fit: BoxFit.fill).inkWell(onTap: () => groupTitleCtrl.imagePickerOption(context))).paddingAll(Insets.i4).decorated(color: appCtrl.appTheme.white, shape: BoxShape.circle),
                  ).decorated(
                      color: appCtrl.appTheme.white, shape: BoxShape.circle),
                  if (groupTitleCtrl.pickerCtrl.image != null)
                    SizedBox(
                            child: SvgPicture.asset(eSvgAssets.edit)
                                .paddingAll(Insets.i6)
                                .decorated(
                                    color: appCtrl.appTheme.white,
                                    border: Border.all(
                                        color: appCtrl.appTheme.screenBG),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(AppRadius.r6))))
                        .inkWell(
                            onTap: () =>
                                groupTitleCtrl.imagePickerOption(context))
                ])
              ]),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appFonts.title.tr,
                      style: AppCss.manropeSemiBold15
                          .textColor(appCtrl.appTheme.darkText)),
                  const VSpace(Sizes.s8),
                  TextFieldCommon(
                    hintText: appFonts.enterGroupName.tr,
                    controller: groupTitleCtrl.textNameController,
                  ),
                  const VSpace(Sizes.s20),
                  Text(appFonts.groupDetails.tr,
                      style: AppCss.manropeSemiBold15
                          .textColor(appCtrl.appTheme.darkText)),
                  const VSpace(Sizes.s8),
                  TextFieldCommon(
                    hintText: appFonts.enterGroupDescription.tr,
                    controller: groupTitleCtrl.textDescController,
                  )
                ],
              ).paddingSymmetric(horizontal: Insets.i20,vertical: Insets.i20)
            ]).boxDecoration().paddingAll(Insets.i20),
          ));
    });
  }
}
