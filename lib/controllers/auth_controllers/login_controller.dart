import 'dart:developer';
import 'package:chatzy/config.dart';
import 'package:chatzy/utils/snack_and_dialogs_utils.dart';
import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/usage_control_model.dart';
import '../../models/user_setting_model.dart';
import '../recent_chat_controller.dart';

class LoginController extends GetxController {
  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> mobileGlobalKey = GlobalKey<FormState>();
  GlobalKey<FormState> otpGlobalKey = GlobalKey<FormState>();
  bool isLoading = false, isContactLoad = false;
  String? userName, verificationCode, resendCodeID;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> contactsData = [];
  List<Map<String, dynamic>> unRegisterContactData = [];
  SharedPreferences? pref;
  String? dialCode;

  onTapOtp() async {
    if (mobileGlobalKey.currentState!.validate()) {
      // Otp Method
      isLoading = true;
      update();
      debugPrint("log 1 ${numberController.text.toString()}");
      appCtrl.pref = pref;
      appCtrl.update();
      if (numberController.text == '8141833594') {
        log("GOO :${"${dialCode}81418335s94"}");
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .where("phone", isEqualTo: "${dialCode}8141833594")
            .get()
            .then((value) async {
          log("DATA LL${value.docs.length}");
          if (value.docs.isNotEmpty) {
            if (value.docs[0].data()["name"] == "" &&
                value.docs[0].data()["name"] != null) {
              await appCtrl.storage.write(session.user, value.docs[0].data());
              appCtrl.storage.write(session.dialCode, dialCode);
              Get.offAllNamed(routeName.profileSetupScreen, arguments: {
                "resultData": value.docs[0].data(),
                "isPhoneLogin": true,
                "isOnlyLogin": true,
                "pref": pref,
                'dialCode': dialCode
              });
            } else {
              debugPrint("NAME SAVE");
              debugPrint("SAVED USERRRRRR ${value.docs[0].data()}");
              await appCtrl.storage.write(session.user, value.docs[0].data());

              appCtrl.storage.write(session.id, value.docs[0].data()["id"]);
              appCtrl.user = value.docs[0].data();
              appCtrl.update();
              homeNavigation(value.docs[0].data());
            }
            /*  await appCtrl.storage.write(session.user, value.docs[0].data());
            appCtrl.storage.write(session.id, value.docs[0].data()["id"]);
            appCtrl.user = value.docs[0].data();
            appCtrl.update();
            homeNavigation(value.docs[0].data());*/
          }
        });
      } else {
        debugPrint(
            "NUMBER : '${dialCode ?? "+91"}${numberController.text.toString()}'");
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '$dialCode${numberController.text.toString()}',
          verificationCompleted: (PhoneAuthCredential credential) {
            debugPrint("log 4 $credential");
            isLoading = false;
            update();
          },
          timeout: const Duration(seconds: 60),
          verificationFailed: (FirebaseAuthException e) {
            debugPrint("log 5 $e");
            isLoading = false;
            update();
            snackBar(
              e.message,
              context: Get.context!,
            );
          },
          codeSent: (String verificationId, int? resendToken) async {
            resendCodeID = verificationId;
            verificationCode = verificationId;
            debugPrint("log 2 $verificationId");
            var phoneUser = FirebaseAuth.instance.currentUser;
            debugPrint("log 3 $phoneUser");
            userName = phoneUser?.phoneNumber;
            isLoading = false;
            update();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            isLoading = false;
            update();
            log("SOMETHING");
          },
        );
      }
    }
  }

  resendCode() async {
    isLoading = true;
    update();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${dialCode ?? "+91"}${numberController.text.toString()}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) async {
        resendCodeID = verificationId;
        verificationCode = verificationId;
        debugPrint("log 2 $resendCodeID");
        var phoneUser = FirebaseAuth.instance.currentUser;
        debugPrint("log 3 $phoneUser");
        userName = phoneUser?.phoneNumber;
        isLoading = false;
        update();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    update();
  }

  //on verify code
  onTapValidateOtp() async {
    log("otpGlobalKey.currentState!.validate() :${otpGlobalKey.currentState!.validate()}");
    if (otpGlobalKey.currentState!.validate()) {
      try {
        isLoading = true;
        update();
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationCode!,
            smsCode: otpController.text.toString());
        await auth.signInWithCredential(credential);
        isLoading = false;
        update();

        Get.offAllNamed(routeName.profileSetupScreen, arguments: pref);
      } catch (e) {
        isLoading = false;
        update();
        flutterAlertMessage(msg: 'Invalid code');
      }
    }
  }

  //on form submit
  void onFormSubmitted() async {
    log("otpGlobalKey.currentState!.validate() : ${otpGlobalKey.currentState!.validate()}");
    if (otpGlobalKey.currentState!.validate()) {
      isLoading = true;
      update();

      debugPrint("verificationCode : $verificationCode");
      PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationCode!, smsCode: otpController.text);

      auth
          .signInWithCredential(authCredential)
          .then((UserCredential value) async {
        debugPrint("value : ${value.user}");
        if (value.user != null) {
          User user = value.user!;
          appCtrl.pref = pref;
          appCtrl.update();
          try {
            FirebaseFirestore.instance
                .collection(collectionName.users)
                .where("id", isEqualTo: user.uid)
                .limit(1)
                .get()
                .then((value) async {
              dynamic resultData = await getUserData(user);
              debugPrint("checkkkkkk : ${value.docs.isEmpty}");
              if (value.docs.isNotEmpty) {
                debugPrint("NAME : ${value.docs[0].data()}");
                if (value.docs[0].data()["name"] == "") {
                  await appCtrl.storage.write(session.user, resultData);
                  appCtrl.storage.write(session.dialCode, dialCode);
                  Get.offAllNamed(routeName.profileSetupScreen, arguments: {
                    "resultData": resultData,
                    "isPhoneLogin": true,
                    "isOnlyLogin": true,
                    "pref": pref,
                    'dialCode': dialCode,
                    'phone': numberController.text
                  });
                } else {
                  await appCtrl.storage
                      .write(session.user, value.docs[0].data());

                  appCtrl.storage.write(session.id, value.docs[0].data()["id"]);
                  appCtrl.user = value.docs[0].data();
                  appCtrl.update();
                  homeNavigation(value.docs[0].data());
                }
              } else {
                debugPrint("check1 : ${value.docs.isEmpty}");
                debugPrint("DATA NATHIII");
                if (appCtrl.usageControlsVal!.allowUserSignup!) {
                  await userRegister(user);
                  dynamic resultData = await getUserData(user);
                  debugPrint("RESULTDATA ${resultData["name"]}");
                  appCtrl.storage.write(session.dialCode, dialCode);
                  if (resultData["name"] == "") {
                    debugPrint("DATA NATHIII WITH NAME");
                    appCtrl.user = resultData;
                    appCtrl.update();
                    await appCtrl.storage.write(session.user, resultData);
                    Get.offAllNamed(routeName.profileSetupScreen, arguments: {
                      "resultData": resultData,
                      "isPhoneLogin": true,
                      "isOnlyLogin": true,
                      "pref": pref,
                      'dialCode': dialCode,
                      'phone': numberController.text
                    });

                    update();
                  } else {
                    debugPrint("DATA NAME READ");
                    await appCtrl.storage
                        .write(session.user, value.docs[0].data());
                    appCtrl.storage
                        .write(session.id, value.docs[0].data()["id"]);
                    appCtrl.user = value.docs[0].data();
                    appCtrl.update();
                    appCtrl.storage.write(session.dialCode, dialCode);
                    homeNavigation(resultData);
                  }
                } else {
                  snackBar("New Register Not Allow to create Account");
                }
              }
              isLoading = false;
              update();
            }).catchError((err) {
              debugPrint("get : $err");
            });
          } on FirebaseAuthException catch (e) {
            debugPrint("get firebase : $e");
          }
        } else {
          isLoading = false;
          update();
          flutterAlertMessage(msg: appFonts.somethingWentWrong);
        }
      }).catchError((error) {
        isLoading = false;
        update();
        debugPrint("err : ${error.toString()}");
        flutterAlertMessage(msg: error.toString());
      });
    }
    update();
  }

  //get data
  Future<Object?> getUserData(User user) async {
    final result = await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user.uid)
        .get();
    dynamic resultData;
    if (result.exists) {
      Map<String, dynamic>? data = result.data();
      resultData = data;
      return resultData;
    }
    return resultData;
  }

  //user register
  userRegister(User user) async {
    log(" : $user");
    try {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      firebaseMessaging.getToken().then((token) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(user.uid)
            .set({
          'id': user.uid,
          'image': "",
          'name': "",
          'pushToken': token,
          'status': "Offline",
          'dialCode': dialCode,
          "email": user.email,
          "deviceName": appCtrl.deviceName,
          'phone': "$dialCode${numberController.text}",
          "dialCodePhoneList":
              phoneList(phone: numberController.text, dialCode: dialCode),
          "isActive": true,
          "device": appCtrl.device,
          "statusDesc": "Hello, I am using Pepulse",
          "createdDate": DateTime.now().millisecondsSinceEpoch
        }).catchError((err) {
          debugPrint("fir : $err");
        });
      });
    } on FirebaseAuthException catch (e) {
      debugPrint("firebase : $e");
    }
  }

  getAdminPermission() async {
    final usageControls = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.usageControls)
        .get();

    appCtrl.usageControlsVal =
        UsageControlModel.fromJson(usageControls.data()!);

    appCtrl.storage.write(session.usageControls, usageControls.data());
    update();
    final userAppSettings = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.userAppSettings)
        .get();
    appCtrl.userAppSettingsVal =
        UserAppSettingModel.fromJson(userAppSettings.data()!);
    final agoraToken = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.agoraToken)
        .get();
    await appCtrl.storage.write(session.agoraToken, agoraToken.data());
    update();
    appCtrl.update();
  }

  contactPermissions(user) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppRadius.r8))),
              backgroundColor: appCtrl.appTheme.white,
              titlePadding: const EdgeInsets.all(Insets.i20),
              title: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Icon(CupertinoIcons.multiply, color: appCtrl.appTheme.txt)
                      .inkWell(onTap: () {
                    isLoading = false;
                    update();
                    Get.back();
                  })
                ])
              ]),
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      eImageAssets.contactBg,
                      height: Sizes.s130,
                      width: Sizes.s180,
                    ),
                    const VSpace(Sizes.s30),
                    Text(appFonts.contactList.tr,
                            style: GoogleFonts.manrope(
                                color: appCtrl.appTheme.darkText,
                                fontWeight: FontWeight.w600,
                                fontSize: 16))
                        .marginSymmetric(horizontal: Insets.i12),
                    const VSpace(Sizes.s12),
                    Text(appFonts.contactPer.tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                                color: appCtrl.appTheme.greyText,
                                fontWeight: FontWeight.w400,
                                fontSize: 12))
                        .marginSymmetric(horizontal: Insets.i12),
                    const VSpace(Sizes.s15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Divider(
                          height: 0,
                          color: appCtrl.appTheme.divider,
                          thickness: 1,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(appFonts.cancel.tr,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.manrope(
                                            color: appCtrl.appTheme.greyText,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14))
                                    .paddingSymmetric(vertical: Insets.i18)
                                    .inkWell(onTap: () async {
                                  Get.back();
                                  final FetchContactController
                                      registerAvailableContact =
                                      Provider.of<FetchContactController>(
                                          Get.context!,
                                          listen: false);
                                  registerAvailableContact.setIsLoading(false);

                                  await getAdminPermission();
                                  isLoading = true;
                                  update();
                                  appCtrl.pref = pref;
                                  appCtrl.update();

                                  await appCtrl.storage
                                      .write(session.user, user);
                                  await appCtrl.storage
                                      .write(session.isIntro, true);
                                  Get.forceAppUpdate();

                                  await appCtrl.storage
                                      .write(session.isIntro, true);
                                  Get.forceAppUpdate();

                                  final FirebaseMessaging firebaseMessaging =
                                      FirebaseMessaging.instance;
                                  firebaseMessaging
                                      .getToken()
                                      .then((token) async {
                                    await FirebaseFirestore.instance
                                        .collection(collectionName.users)
                                        .doc(user["id"])
                                        .update({
                                      'status': "Online",
                                      "pushToken": token,
                                      "isActive": true,
                                      'phoneRaw': numberController.text,
                                      'phone':
                                          (dialCode! + numberController.text)
                                              .trim(),
                                      "dialCodePhoneList": phoneList(
                                          phone: numberController.text,
                                          dialCode: dialCode)
                                    });
                                    await Future.delayed(DurationsClass.s6);
                                    isLoading = false;
                                    update();

                                    Get.toNamed(routeName.dashboard,
                                        arguments: pref);
                                  });
                                  /*Get.back();
                              final FetchContactController registerAvailableContact =
                              Provider.of<FetchContactController>(Get.context!, listen: false);
                              registerAvailableContact.setIsLoading(false);


                              appCtrl.storage.write(session.dialCode, dialCode);
                              final FetchContactController availableContacts =
                              Provider.of<FetchContactController>(Get.context!, listen: false);

                              availableContacts.fetchContacts(Get.context!, user["phone"], pref!, false);

                              isLoading = true;
                              update();

                              appCtrl.update();
                              final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
                              firebaseMessaging.getToken().then((token) async {
                                await FirebaseFirestore.instance
                                    .collection(collectionName.users)
                                    .doc(user["id"])
                                    .update({
                                  'status': "Online",
                                  "pushToken": token,
                                  "isActive": true,
                                  "dialCode": dialCode,
                                  'phone': "$dialCode${numberController.text}",
                                  "dialCodePhoneList":
                                  phoneList(phone: numberController.text, dialCode: dialCode)
                                });
                                debugPrint('check : ${appCtrl.storage.read(session.isIntro)}');
                              });


                              appCtrl.storage.write(session.id, user["id"]);
                              await appCtrl.storage.write(session.user, user);
                              appCtrl.user = user;
                              log("HOME USER ${appCtrl.user}");
                              appCtrl.update();
                              await appCtrl.storage.write(session.isIntro, true);

                              Get.forceAppUpdate();

                              await Future.delayed(DurationsClass.s5);
                              isLoading = false;
                              update();
                              Get.offAllNamed(routeName.dashboard, arguments: pref);*/
                                }),
                              ),
                              VerticalDivider(
                                width: 1,
                                color: appCtrl.appTheme.divider,
                                thickness: 1,
                              ),
                              Expanded(
                                child: Text(appFonts.accept.tr,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.manrope(
                                          color: appCtrl.appTheme.primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ))
                                    .paddingSymmetric(vertical: Insets.i18)
                                    .inkWell(onTap: () async {
                                  Get.back();
                                  await getAdminPermission();
                                  await appCtrl.storage
                                      .write(session.user, user);
                                  await appCtrl.storage
                                      .write(session.isIntro, true);
                                  Get.forceAppUpdate();

                                  final FetchContactController
                                      registerAvailableContact =
                                      Provider.of<FetchContactController>(
                                          Get.context!,
                                          listen: false);
                                  log("INIT PAGE");

                                  registerAvailableContact.fetchContacts(
                                      Get.context!,
                                      appCtrl.user["phone"],
                                      pref!,
                                      false);
                                  isLoading = true;
                                  update();
                                  appCtrl.pref = pref;
                                  appCtrl.update();

                                  await appCtrl.storage
                                      .write(session.isIntro, true);
                                  Get.forceAppUpdate();

                                  final FirebaseMessaging firebaseMessaging =
                                      FirebaseMessaging.instance;
                                  firebaseMessaging
                                      .getToken()
                                      .then((token) async {
                                    await FirebaseFirestore.instance
                                        .collection(collectionName.users)
                                        .doc(user["id"])
                                        .update({
                                      'status': "Online",
                                      "pushToken": token,
                                      "isActive": true,
                                      'phoneRaw': numberController.text,
                                      'phone':
                                          (dialCode! + numberController.text)
                                              .trim(),
                                      "dialCodePhoneList": phoneList(
                                          phone: numberController.text,
                                          dialCode: dialCode)
                                    });
                                    await Future.delayed(DurationsClass.s6);
                                    isLoading = false;
                                    update();

                                    Get.toNamed(routeName.dashboard,
                                        arguments: pref);
                                  });
                                }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ).width(MediaQuery.of(context).size.width)
                  ]));
        });
  }

  //navigate to dashboard
  homeNavigation(user) async {
    log("PREFF $user");
    final RecentChatController recentChatController =
        Provider.of<RecentChatController>(Get.context!, listen: false);
    recentChatController.getModel(appCtrl.user);
    contactPermissions(user);
  }

  final defaultPinTheme = PinTheme(
      textStyle: AppCss.manropeBold18.textColor(appCtrl.appTheme.greyText),
      width: Sizes.s55,
      height: Sizes.s48,
      decoration: BoxDecoration(
          color: appCtrl.appTheme.greyText.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppRadius.r8),
          border:
              Border.all(color: appCtrl.appTheme.greyText.withOpacity(0.15))));

  @override
  void onReady() async {
    pref = Get.arguments;
    log("LOG PREF READY $pref");
    final usageControls = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.usageControls)
        .get();
    log("USAGE CONTROL ${usageControls.data()!}");
    appCtrl.usageControlsVal =
        UsageControlModel.fromJson(usageControls.data()!);

    appCtrl.storage.write(session.usageControls, usageControls.data());

    final userAppSettings = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.userAppSettings)
        .get();
    log("admin 4: ${userAppSettings.data()}");
    log("USAGE CONTROL ${appCtrl.userAppSettingsVal!.firebaseServerToken}");
    appCtrl.userAppSettingsVal =
        UserAppSettingModel.fromJson(userAppSettings.data()!);
    final String systemLocales =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode!;
    List country = countriesEnglish;
    int index =
        country.indexWhere((element) => element['code'] == systemLocales);
    dialCode = country[index]['dial_code'];
    update();
    log("DIAL : $dialCode");
    // TODO: implement onReady
    super.onReady();
  }
}
