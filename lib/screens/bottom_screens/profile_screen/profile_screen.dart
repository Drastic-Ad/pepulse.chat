import 'package:chatzy/widgets/common_loader.dart';
import 'package:chatzy/widgets/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../config.dart';
import '../../../controllers/app_pages_controllers/profile_screen_controller.dart';

class ProfileScreen extends StatelessWidget {
  final profileCtrl = Get.put(ProfileScreenController());

   ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: GetBuilder<ProfileScreenController>(
        builder: (context) {
          return GetBuilder<DashboardController>(
            builder: (dashCtrl) {
              return PopScope(
                canPop: false,
                onPopInvoked: (didPop) {
                  if (didPop) return;
                  if (dashCtrl.tabController!.index != 0) {
                    dashCtrl.onChange(0);
                    dashCtrl.tabController!.index = 0;
                    dashCtrl.update();

                  } else {
                    SystemNavigator.pop();

                  }
                },

                child: Scaffold(
                    backgroundColor: appCtrl.appTheme.white,
                    appBar: AppBar(
                        backgroundColor: appCtrl.appTheme.white,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        actions: [
                          ActionIconsCommon(icon: eSvgAssets.trash,onTap: ()=> profileCtrl.deleteUser(),hPadding: Insets.i15,vPadding: Insets.i8,color: appCtrl.appTheme.white)
                        ],
                        title: Text(appFonts.profile.tr,
                            style: AppCss.muktaVaani20
                                .textColor(appCtrl.appTheme.darkText))),
                    body: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  SizedBox(
                                      height: Sizes.s100,
                                      width: Sizes.s100,
                                      child:
                                      profileCtrl.isLoading ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator()
                                          ]
                                        )
                                      ) :
                                      appCtrl.user["image"] != ""  ? appCtrl.user["image"] == "" ? Image.asset(eImageAssets.profileAnon) :   ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(AppRadius.r5)),
                                          child:  appCtrl.user["image"] != "" ?  appCtrl.isLoading == true ? const Center(child: CircularProgressIndicator()) : Image.network( appCtrl.user["image"] ,
                                              fit: BoxFit.cover) : Container()).paddingAll(Insets.i2) : appCtrl.user["image"] != null && appCtrl.user["image"] != "" ?  ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(AppRadius.r5)),
                                          child:  appCtrl.user["image"] != null && appCtrl.user["image"] != ""  ?  Image.network(appCtrl.user["image"],
                                              fit: BoxFit.cover) : Container()).paddingAll(Insets.i2) : DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: appCtrl.appTheme.greyText.withOpacity(
                                              0.6),
                                          radius: const Radius.circular(AppRadius.r5),
                                          child: ClipRRect(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(AppRadius.r5)),
                                              child: SizedBox(
                                                  child: Icon(CupertinoIcons.add,
                                                      color: appCtrl.appTheme.greyText
                                                          .withOpacity(0.6))
                                                      .paddingAll(Insets.i4)
                                                      .decorated(
                                                      borderRadius: BorderRadius.circular(
                                                          AppRadius.r8),
                                                      border: Border.all(
                                                          color: appCtrl
                                                              .appTheme.greyText
                                                              .withOpacity(0.6))))
                                                  .alignment(Alignment.center)))
                                          .paddingAll(Insets.i10))
                                      .boxDecoration(color: appCtrl.appTheme.primary,bWidth: 2).inkWell(onTap: () =>
                                      profileCtrl.onTapProfile(appCtrl.user["image"]))
                                      .paddingOnly(top: Insets.i20,
                                      right: Insets.i8,
                                      left: Insets.i8,
                                      bottom: Insets.i8),
                                  if(appCtrl.user["image"] != null)
                                    SizedBox(
                                        child: SvgPicture.asset(eSvgAssets.edit).paddingAll(
                                            Insets.i6).decorated(color: appCtrl.appTheme
                                            .white,
                                            border: Border.all(
                                                color: appCtrl.appTheme.screenBG),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(AppRadius.r6)))
                                    ).inkWell(onTap: () =>
                                        profileCtrl.onTapProfile(appCtrl.user["image"]))
                                ]
                            ),
                            const VSpace(Sizes.s22),
                            Form(
                              key: profileCtrl.profileGlobalKey,
                              child: SizedBox(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(appFonts.displayName.tr,
                                          style: AppCss.manropeBold15.textColor(
                                              appCtrl.appTheme.darkText)),
                                      const VSpace(Sizes.s8),
                                      TextFieldCommon(hintText: appFonts.enterYourName.tr,
                                          controller: profileCtrl.userNameController,
                                          validator: (name) =>
                                              Validation().nameValidation(name)
                                      ),
                                      const VSpace(Sizes.s20),
                                      Text(appFonts.email.tr,
                                          style: AppCss.manropeBold15.textColor(
                                              appCtrl.appTheme.darkText)),
                                      const VSpace(Sizes.s8),
                                      TextFieldCommon(hintText: appFonts.enterYourEmail.tr,
                                          controller: profileCtrl.emailController,
                                          validator: (email) =>
                                              Validation().emailValidation(email)),
                                      const VSpace(Sizes.s20),
                                      Text(appFonts.addStatus.tr,
                                          style: AppCss.manropeBold15.textColor(
                                              appCtrl.appTheme.darkText)),
                                      const VSpace(Sizes.s8),
                                      TextFieldCommon(hintText: appFonts.writeHere.tr,
                                          suffixIcon: SvgPicture.asset(eSvgAssets.emojis,height: Sizes.s20,width: Sizes.s20,fit: BoxFit.scaleDown).inkWell(onTap: ()=> profileCtrl.onTapEmoji()),
                                          controller: profileCtrl.statusController,
                                          validator: (name) =>
                                              Validation().nameValidation(name)),
                                      const VSpace(Sizes.s48),
                                      ButtonCommon(title: appFonts.update.tr,onTap: ()=> profileCtrl.updateUserData())
                                    ]
                                ).paddingAll(Insets.i20)
                              ).boxDecoration()
                            )
                          ]).paddingSymmetric(horizontal: Insets.i20).alignment(
                              Alignment.topCenter),
                          if(profileCtrl.isLoading)
                            const CommonLoader()
                        ],
                      )
                    )),
              );
            }
          );
        }
      ),
    );
  }
}
