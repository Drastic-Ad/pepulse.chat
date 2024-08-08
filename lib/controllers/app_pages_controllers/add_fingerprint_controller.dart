import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../../config.dart';

class AddFingerprintController extends GetxController {
  LocalAuthentication auth = LocalAuthentication();
  String authorized = " not authorized";
  bool canCheckBiometric = false;
  List<BiometricType> availableBiometric = [];
  SharedPreferences? pref;

  Future<void> authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
          localizedReason: "Scan your finger to authenticate",
          options: const AuthenticationOptions(
              useErrorDialogs: true, stickyAuth: true));
      appCtrl.isBiometric = authenticated;
      appCtrl.storage.write(session.isBiometric, authenticated);
      log("appCtrl.isBiometric:${appCtrl.isBiometric}");
      appCtrl.update();
      authenticated
          ? showDialog(
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
                        Icon(CupertinoIcons.multiply,
                                color: appCtrl.appTheme.darkText)
                            .inkWell(onTap: () => Get.back())
                      ])
                    ]),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      Image.asset(eImageAssets.successFinger,
                          height: Sizes.s115, width: Sizes.s115),
                      Text(appFonts.successfullyScan.tr,
                          style: AppCss.manropeBold16
                              .textColor(appCtrl.appTheme.darkText)),
                      const VSpace(Sizes.s10),
                      Text(appFonts.wohooSuccess.tr,
                          textAlign: TextAlign.center,
                          style: AppCss.manropeMedium14
                              .textColor(appCtrl.appTheme.greyText)),
                      const VSpace(Sizes.s15),
                     Column(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Divider(
                             height: 1,
                             color: appCtrl.appTheme.borderColor,
                             thickness: 1)
                         ,
                         const VSpace(Sizes.s15),
                         Text(appFonts.okay.tr,
                             style: AppCss.manropeblack14
                                 .textColor(appCtrl.appTheme.primary)).inkWell(onTap: () {
                           Get.back();
                           Get.offAllNamed(routeName.dashboard, arguments: pref);

                         }),
                         const VSpace(Sizes.s20),
                       ],
                     ).width(MediaQuery.of(context).size.width).inkWell(onTap: () {
                       Get.back();
                       Get.offAllNamed(routeName.dashboard, arguments: pref);

                     })
                    ]).padding(horizontal: Sizes.s20,));
              })
          : flutterAlertMessage(msg: appFonts.fingerprintError.tr);
      update();
    } on PlatformException {
      flutterAlertMessage(msg: appFonts.deviceNotSupported.tr);
    }
    update();
  }

  Future<void> checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
      update();
    } on PlatformException catch (e) {
      log("checkBiometric: $e");
    }

    if (!isClosed) return;
    canCheckBiometric = canCheckBiometric;
    update();
  }

  Future getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
      update();
    } on PlatformException catch (e) {
      log("getAvailableBiometric: $e");
    }
    availableBiometric = availableBiometric;
    update();
  }

  @override
  void onReady() async {
    pref = Get.arguments;
    checkBiometric();
    getAvailableBiometric();
    authenticate();
    update();
    // TODO: implement onReady
    super.onReady();
  }
}
