import 'package:flutter/cupertino.dart';

import '../../../config.dart';
import '../../../widgets/common_loader.dart';
import 'group_firebase_api.dart';

class GroupTitleScreen extends StatelessWidget {
  final groupTitleCtrl = Get.isRegistered<GroupMessageController>()
      ? Get.find<GroupMessageController>()
      : Get.put(GroupMessageController());
   GroupTitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupMessageController>(
      builder: (_) {
        return DirectionalityRtl(
          child: Scaffold(
            appBar: AppBar(
                backgroundColor: appCtrl.appTheme.screenBG,
                elevation: 0,
                leading: ActionIconsCommon(
                    icon:appCtrl.isRTL || appCtrl.languageVal == "ar" ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
                    onTap: () => Get.back(),
                    vPadding: Insets.i8,
                    hPadding: Insets.i8),
                titleSpacing: 0,
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(groupTitleCtrl.isGroup ? appFonts.newGroup.tr : appFonts.newBroadcast.tr ,
                          style: AppCss.manropeBold16
                              .textColor(appCtrl.appTheme.darkText)),
                      const VSpace(Sizes.s5),
                      Text(appFonts.addTitlePhoto.tr,
                          style: AppCss.manropeMedium12
                              .textColor(appCtrl.appTheme.greyText))
                    ])
                ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if(groupTitleCtrl.formKey.currentState!.validate()) {
                    if (groupTitleCtrl.isGroup) {
                      GroupFirebaseApi().createGroup(groupTitleCtrl);
                    } else {
                       groupTitleCtrl.onCreateBroadcast();
                    }
                  }
                },
                backgroundColor: appCtrl.appTheme.primary,
                child: Icon(Icons.check,color: appCtrl.appTheme.sameWhite)
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: groupTitleCtrl.formKey,
                    child: Column(
                      children: [
                        Divider(thickness: 2, color: appCtrl.appTheme.borderColor)
                            .paddingSymmetric(vertical: Insets.i8),
                        SizedBox(
                          child: Column(
                            children: [

                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.r8)),
                                        child: Image.asset(eImageAssets.titleHalfCircle)).paddingOnly(bottom: Insets.i40),
                                    groupTitleCtrl.isGroup ?
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        SizedBox(
                                          width: Sizes.s80,
                                          height: Sizes.s80,
                                          child: groupTitleCtrl.pickerCtrl.image == null ? DottedBorder(
                                              borderType: BorderType.RRect,
                                              color: appCtrl.appTheme.greyText.withOpacity(
                                                  0.6),
                                              radius: const Radius.circular(AppRadius.r50),
                                              child: ClipRRect(
                                                  borderRadius: const BorderRadius.all(
                                                      Radius.circular(AppRadius.r5)),
                                                  child: SizedBox(
                                                      child: Icon(CupertinoIcons.add,
                                                          size: Sizes.s20,
                                                          color: appCtrl.appTheme.greyText
                                                              .withOpacity(0.6))
                                                          .paddingAll(Insets.i3)
                                                          .decorated(
                                                          borderRadius: BorderRadius
                                                              .circular(
                                                              AppRadius.r8),
                                                          border: Border.all(
                                                              color: appCtrl
                                                                  .appTheme.greyText
                                                                  .withOpacity(0.6))))
                                                      .alignment(Alignment.center))).paddingAll(Insets.i4).inkWell(onTap: ()=> groupTitleCtrl.pickerCtrl
                                              .imagePickerOption(context,isCreateGroup: true) ) :  ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r50)),
                                                child: Image.file(
                                                groupTitleCtrl.pickerCtrl.image!,
                                                fit: BoxFit.fill).inkWell(onTap: ()=> groupTitleCtrl.pickerCtrl
                                                .onTapGroupProfile(isCreateGroup: true,context) )
                                              ).paddingAll(Insets.i4).decorated(color: appCtrl.appTheme.white,shape: BoxShape.circle),
                                        ).decorated(color: appCtrl.appTheme.white,shape: BoxShape.circle),
                                        if(groupTitleCtrl.pickerCtrl.image != null)
                                        SizedBox(
                                            child: SvgPicture.asset(eSvgAssets.edit).paddingAll(
                                                Insets.i6).decorated(color: appCtrl.appTheme
                                                .white,
                                                border: Border.all(
                                                    color: appCtrl.appTheme.screenBG),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(AppRadius.r6)))
                                        ).inkWell(onTap: ()=> groupTitleCtrl.pickerCtrl
                                            .onTapGroupProfile(isCreateGroup: true,context))
                                      ],
                                    ) :

                                    SizedBox(
                                      child: SvgPicture.asset(eSvgAssets.broadCast,height: Sizes.s40,width: Sizes.s40,colorFilter: ColorFilter.mode(appCtrl.appTheme.primary, BlendMode.srcIn)).paddingAll(Insets.i20),
                                    ).decorated(color: appCtrl.appTheme.white,shape: BoxShape.circle,border: Border.all(color: appCtrl.appTheme.primary)).paddingAll(Insets.i4).decorated(color: appCtrl.appTheme.white,shape: BoxShape.circle)
                                  ]
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(appFonts.title.tr,style: AppCss.manropeBold15.textColor(appCtrl.appTheme.darkText)),
                                  const VSpace(Sizes.s8),
                                  TextFieldCommon(hintText:groupTitleCtrl.isGroup ? appFonts.addGroupTitle : appFonts.addBroadcastTitle,
                                  suffixIcon: SvgPicture.asset(eSvgAssets.emojis,height: Sizes.s20,width: Sizes.s20,fit: BoxFit.scaleDown),
                                    controller: groupTitleCtrl.txtGroupName,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return groupTitleCtrl.isGroup ? "Group Name Required" : "Broadcast Name Required" ;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  DottedLines(color: appCtrl.appTheme.greyText.withOpacity(0.4)).paddingSymmetric(vertical: Insets.i20),
                                  Text(appFonts.participant.tr + groupTitleCtrl.selectedContact.length.toString(),style: AppCss.manropeMedium15.textColor(appCtrl.appTheme.greyText)),
                                  const VSpace(Sizes.s15),
                                  GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: groupTitleCtrl.selectedContact.length,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 20,
                                          mainAxisExtent: 90,
                                          mainAxisSpacing: 20.0,
                                          crossAxisCount: 4
                                      ),
                                      itemBuilder: (context, index) {
                                        return Column(children: [
                                          CachedNetworkImage(
                                              imageUrl: groupTitleCtrl.selectedContact[index]["image"].toString(),
                                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                                  backgroundColor: appCtrl.appTheme.greyText.withOpacity(0.2),
                                                  radius: AppRadius.r30,
                                                  backgroundImage: imageProvider),
                                              placeholder: (context, url) => CircleAvatar(
                                                backgroundColor: appCtrl.appTheme.greyText.withOpacity(0.2),
                                                radius: AppRadius.r30,
                                                child:
                                                const Icon(Icons.person, color: Color(0xffCCCCCC)),
                                              ),
                                              errorWidget: (context, url, error) => const CircleAvatar(
                                                backgroundColor: Color(0xffE6E6E6),
                                                radius: 30,
                                                child: Icon(
                                                  Icons.person,
                                                  color: Color(0xffCCCCCC),
                                                ),
                                              )),
                                          const VSpace(Sizes.s8),
                                          Text(groupTitleCtrl.selectedContact[index]["name"].toString(),
                                              maxLines: 1, overflow: TextOverflow.ellipsis,style: AppCss.manropeBold12.textColor(appCtrl.appTheme.darkText))
                                        ]);
                                      }),
                                ],
                              ).paddingSymmetric(horizontal: Insets.i20,vertical: Insets.i20)

                            ],
                          ),
                        ).boxDecoration()

                      ],
                    ).paddingSymmetric(horizontal: Insets.i20),
                  ),
                ),
                if(groupTitleCtrl.isLoading)
                  const CommonLoader()
              ],
            ),
          ),
        );
      }
    );
  }
}
