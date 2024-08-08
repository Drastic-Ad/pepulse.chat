import 'dart:developer';

import 'package:chatzy/utils/snack_and_dialogs_utils.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../../config.dart';

class AddFingerprintController extends GetxController {
  LocalAuthentication auth = LocalAuthentication();
  String authorized = " not authorized";
  bool canCheckBiometric = false;
  List<BiometricType> availableBiometric = [];


  Future<void> authenticate({isSplash = true}) async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
          localizedReason: "Scan your finger to authenticate",
          options: const AuthenticationOptions(
              useErrorDialogs: true, stickyAuth: true));

      log("authenticated : $authenticated");
      if(authenticated){

       // snackBarMessengers(message: "FingerPrint Added Successfully",color: appCtrl.appTheme.greenColor);
      }else{
        snackBar( "Try Again");
      }
      appCtrl.isBiometric = authenticated;
      appCtrl.update();
      appCtrl.storage.write(session.isBiometric,authenticated);
      update();
      Get.forceAppUpdate();
      log("isSplash : $isSplash");
     if(isSplash){
       Get.toNamed(routeName.dashboard);
     }
    } catch(e)  {
      log("ERROR L: $e");
      //snackBarMessengers(message: e);
    }
    update();

  }

  Future<void> checkBiometric({isSplash = true}) async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
      update();
      log("checkBiometric : $canCheckBiometric");
      if(canCheckBiometric ){
        authenticate(isSplash: isSplash);
      }
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
      log("availableBiometric : $availableBiometric");
      update();
    } on PlatformException catch (e) {
      log("getAvailableBiometric: $e");
    }
    availableBiometric = availableBiometric;
    update();
  }



  @override
  void onReady() async {

    checkBiometric(isSplash: true);
    getAvailableBiometric();
    update();
    // TODO: implement onReady
    super.onReady();
  }
}