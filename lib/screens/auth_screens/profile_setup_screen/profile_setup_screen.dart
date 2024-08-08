import 'dart:developer';
import 'package:chatzy/widgets/common_loader.dart';
import 'package:chatzy/widgets/validation.dart';
import 'package:flutter/cupertino.dart';
import '../../../config.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

class ProfileSetupScreen extends StatelessWidget {
  final profileCtrl = Get.put(ProfileSetupController());

  ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    log("USERSSSSS ${profileCtrl.user}");
    log("IMAGE ${profileCtrl.imageUrl}");

    return GetBuilder<ProfileSetupController>(
        builder: (_) {
          return Scaffold(
              backgroundColor: appCtrl.appTheme.screenBG,
              appBar: AppBar(
                  backgroundColor: appCtrl.appTheme.screenBG,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(appFonts.profileSetup.tr,
                      style:
                      AppCss.manropeBold16.textColor(
                          appCtrl.appTheme.darkText))),
              body: profileCtrl.isLoading == true ? const CommonLoader() : SingleChildScrollView(
                  child: Column(
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
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              ) :
                              profileCtrl.imageUrl.isNotEmpty ? profileCtrl
                                  .imageUrl == '' ? Image.asset(
                                  eImageAssets.profileAnon) : ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(AppRadius.r8)),
                                  child: profileCtrl.imageUrl.isNotEmpty
                                      ? profileCtrl.isLoading == true
                                      ? const Center(
                                      child: CircularProgressIndicator())
                                      : Image.network(profileCtrl.imageUrl,
                                      fit: BoxFit.cover)
                                      : Container()) : profileCtrl
                                  .user != null ? profileCtrl
                                  .user["image"] != null &&
                                  profileCtrl.user["image"] != ""
                                  ? ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(AppRadius.r8)),
                                  child: profileCtrl.user["image"] != null &&
                                      profileCtrl.user["image"] != "" ? Image
                                      .network(profileCtrl.user["image"],
                                      fit: BoxFit.cover) : Container())
                                  : DottedBorder(
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
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  AppRadius.r8),
                                              border: Border.all(
                                                  color: appCtrl
                                                      .appTheme.greyText
                                                      .withOpacity(0.6))))
                                          .alignment(Alignment.center)))
                                  .paddingAll(Insets.i10) : DottedBorder(
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
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  AppRadius.r8),
                                              border: Border.all(
                                                  color: appCtrl
                                                      .appTheme.greyText
                                                      .withOpacity(0.6))))
                                          .alignment(Alignment.center)))
                                  .paddingAll(Insets.i10) )
                              .boxDecoration(color: appCtrl.appTheme.primary,
                              bWidth: 2).inkWell(onTap: () =>
                              profileCtrl.onTapProfile(
                                  profileCtrl.user["image"]))
                              .paddingOnly(top: Insets.i20,
                              right: Insets.i8,
                              left: Insets.i8,
                              bottom: Insets.i8),
                          if(profileCtrl.user != null)
                          if(profileCtrl.user["image"] != null)
                            SizedBox(
                                child: SvgPicture.asset(eSvgAssets.edit)
                                    .paddingAll(
                                    Insets.i6)
                                    .decorated(color: appCtrl.appTheme
                                    .white,
                                    border: Border.all(
                                        color: appCtrl.appTheme.screenBG),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(AppRadius.r6)))
                            ).inkWell(onTap: () =>
                                profileCtrl.onTapProfile(
                                    profileCtrl.user["image"]))
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
                                  TextFieldCommon(
                                      hintText: appFonts.enterYourName.tr,
                                      controller: profileCtrl
                                          .userNameController,
                                      validator: (name) =>
                                          Validation().nameValidation(name)
                                  ),
                                  const VSpace(Sizes.s20),
                                  Text(appFonts.email.tr,
                                      style: AppCss.manropeBold15.textColor(
                                          appCtrl.appTheme.darkText)),
                                  const VSpace(Sizes.s8),
                                  TextFieldCommon(
                                      hintText: appFonts.enterYourEmail.tr,
                                      controller: profileCtrl.emailController,
                                      validator: (email) =>
                                          Validation().emailValidation(email)),
                                  const VSpace(Sizes.s20),
                                  Text(appFonts.addStatus.tr,
                                      style: AppCss.manropeBold15.textColor(
                                          appCtrl.appTheme.darkText)),
                                  const VSpace(Sizes.s8),
                                  TextFieldCommon(hintText: appFonts.writeHere.tr,
                                      controller: profileCtrl.statusController,
                                      validator: (name) =>
                                          Validation().nameValidation(name)),
                                  const VSpace(Sizes.s20),
                                  Text(appFonts.country.tr, style: AppCss.manropeBold15.textColor(appCtrl.appTheme.darkText)),
                                  const VSpace(Sizes.s8),
                                  SelectState(
                                    onCountryChanged: (value) {
                                      profileCtrl.updateCountry(value);
                                    },
                                    onStateChanged: (value) {
                                      profileCtrl.updateState(value);
                                    },
                                    onCityChanged: (value) {
                                      profileCtrl.updateCity(value);
                                    },
                                  ),
                                  const VSpace(Sizes.s48),
                                  ButtonCommon(title: appFonts.submit,
                                      onTap: () => profileCtrl.submitUserData())
                                ]
                            ).paddingAll(Insets.i20)
                        ).boxDecoration()
                    )
                  ]).paddingSymmetric(horizontal: Insets.i20).alignment(
                      Alignment.topCenter)
              ));
        }
    );
  }
}
