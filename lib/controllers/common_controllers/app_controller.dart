import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fast_contacts/fast_contacts.dart';

import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';
import '../../config.dart';
import '../../models/data_model.dart';
import '../../models/usage_control_model.dart';
import '../../models/user_setting_model.dart';


class AppController extends GetxController {
  AppTheme _appTheme = AppTheme.fromType(ThemeType.light);
  AppTheme get appTheme => _appTheme;
  String priceSymbol = "\$";
  bool isTheme = false;
  bool isBiometric = false;
  bool isRTL = false;
  bool isLanguage = false,isLoading =false,isTyping =false;
  bool isSubscribe = false,isLocalChatApi = false;
  bool isLogin = false;
  List<Contact> contactList = [];
  List<Contact> userContactList = [];
  List<FirebaseContactModel> firebaseContact =[];
  List<FirebaseContactModel> registerContact =[];
  List<FirebaseContactModel> unRegisterContact =[];
  UsageControlModel? usageControlsVal;
  UserAppSettingModel? userAppSettingsVal;
  String languageVal = "en";
  dynamic user;
  Locale? locale;
  dynamic selectedCharacter;
  final storage = GetStorage();
  List languagesLists = [];
/*  double currencyVal =
      double.parse(appArray.currencyList[0]["USD"].toString()).roundToDouble();*/
  bool isSwitched = false;
  bool isOnboard = false;
  bool isGuestLogin = false,contactPermission = false;
  bool isNumber = false;
  dynamic currency;
  dynamic envConfig;
  int characterIndex = 3;
  String deviceName = "";
  String device = "";
  var deviceData = <String, dynamic>{};

  List languagesList =[];

  DataModel? cachedModel;
  SharedPreferences? pref;

  //update theme
  updateTheme(theme) {
    _appTheme = theme;
    Get.forceAppUpdate();
  }

  @override
  onReady() {
    initPlatformState();
    update();
    super.onReady();
  }

  DataModel? getModel() {
log("appCtrl.1 :${appCtrl.user}");
    cachedModel ??= DataModel(appCtrl.user["id"]);

    return cachedModel;
  }

  Future<void> initPlatformState() async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
        device = "android";
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine.toString();
        device = "ios";
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    update();
  }

}
