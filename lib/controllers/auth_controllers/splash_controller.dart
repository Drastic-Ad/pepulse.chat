import 'dart:developer';
import 'package:chatzy/config.dart';
import '../../models/usage_control_model.dart';
import '../../models/user_setting_model.dart';
import '../recent_chat_controller.dart';

class SplashController extends GetxController {
  SharedPreferences? pref;
  DocumentSnapshot<Map<String, dynamic>>? rmk,uck;


  @override
  void onReady() async {
    await getAdminPermission();
    var user = appCtrl.storage.read(session.user);
    appCtrl.user = user;
    appCtrl.pref = pref;

    bool permission = appCtrl.storage.read(session.contactPermission) ?? false;
    if (permission) {
      if (user != null) {
        final FetchContactController registerAvailableContact =
        Provider.of<FetchContactController>(Get.context!, listen: false);
        registerAvailableContact.fetchContacts(
            Get.context!, appCtrl.user["phone"], pref ?? appCtrl.pref!, true);
      }
    }
    bool isOnBoard = appCtrl.storage.read('onBoard') ?? false;
    // bool isInvite = appCtrl.storage.read('skip') ?? false;
    appCtrl.update();
    update();
    final RecentChatController recentChatController =
    Provider.of<RecentChatController>(Get.context!, listen: false);

    if (user != null) {
      recentChatController.getModel(user);
    }

    appCtrl.update();
    Get.forceAppUpdate();
    dynamic lan;
    await FirebaseFirestore.instance
        .collection(collectionName.languages)
        .doc(collectionName.defaultLanguage)
        .get().then((value) {
      if(value.exists){
        lan = value.data()!["language"];
      }
    });
    update();
    bool isBiometric = appCtrl.storage.read(session.isBiometric) ?? false;
    appCtrl.isBiometric = isBiometric;
/*
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      debugPrint("CHECK NOT PERMISSION");
    } else {
      Permission.notification.request();
      update();
    }
*/

    Future.delayed(const Duration(milliseconds: 2300), () {
      if (isOnBoard) {
        if (user == "" || user == null) {
          Get.offAllNamed(routeName.loginScreen, arguments: pref);
        } else {
          if (user['email'] == null || user['name'] == "") {
            Get.offAllNamed(routeName.loginScreen, arguments: pref);
          } else {
            if (isBiometric == true) {
              Get.toNamed(routeName.fingerScannerScreen, arguments: pref);
            } else {
              Get.offAllNamed(routeName.dashboard, arguments: pref);
            }
          }
        }
      } else {
        Get.offAllNamed(routeName.onBoardingScreen, arguments: pref);
      }
      update();
    });

    String lanCode = lan["code"].toString().split("_")[0];
    String countryCode = lan["code"].toString().split("_")[1];

    Locale? locale =  Locale(lanCode, countryCode);

    //language
    var language = await appCtrl.storage.read(session.locale) ?? lanCode;
    debugPrint("LANGUAGE1 $language");
    appCtrl.languageVal = language;
    Get.updateLocale(locale);
    appCtrl.locale = locale;
    update();
    bool isRtlSave = appCtrl.storage.read(session.isRTL) ?? false;
    bool isThemeSave = appCtrl.storage.read(session.isDarkMode) ?? false;
    appCtrl.isRTL = isRtlSave;
    ThemeService().switchTheme(isThemeSave);
    appCtrl.isTheme = isThemeSave;



    final agoraToken = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.agoraToken)
        .get();
    await appCtrl.storage.write(session.agoraToken, agoraToken.data());

  //  firebaseCtrl.statusDeleteAfter24Hours();
  //  firebaseCtrl.deleteForAllUsers();
    // TODO: implement onReady
    super.onReady();
  }

  getAdminPermission() async {

    final usageControls = rmk;
    debugPrint("dfddddddd${usageControls!.data()}");
    appCtrl.usageControlsVal =
        UsageControlModel.fromJson(usageControls!.data()!);

    appCtrl.update();
    appCtrl.storage.write(session.usageControls, usageControls.data());

    final userAppSettings =uck;
    log("admin 4: ${userAppSettings!.data()}");
    appCtrl.userAppSettingsVal =
        UserAppSettingModel.fromJson(userAppSettings.data()!);
    final agoraToken = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.agoraToken)
        .get();
    await appCtrl.storage.write(session.agoraToken, agoraToken.data());

    update();
    appCtrl.update();
    Get.forceAppUpdate();
  }
}

