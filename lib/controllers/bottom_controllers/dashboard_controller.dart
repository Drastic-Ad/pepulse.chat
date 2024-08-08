import 'dart:async';
import 'dart:developer';
import 'package:chatzy/config.dart';
import 'package:chatzy/controllers/app_pages_controllers/language_controller.dart';
import 'package:chatzy/controllers/bottom_controllers/call_list_controller.dart';
import 'package:chatzy/controllers/recent_chat_controller.dart';
import 'package:chatzy/screens/app_screens/live_room/live_room.dart';
import 'package:chatzy/screens/bottom_screens/chat_screen/chat_screen.dart';
import 'package:chatzy/screens/bottom_screens/setting_screen/setting_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/services.dart';
import '../../screens/app_screens/select_contact_screen/fetch_contacts.dart';
import '../common_controllers/all_permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List bottomNavLists = [];
  int selectIndex = 0;
  TabController? tabController;
  String? data;

  int selectedIndex = 0;
  int selectedPopTap = 0;
  late int iconCount = 0;
  Timer? timer;
  List bottomList = [];
  bool isLoading = true;
  bool isSearch = false;
  int counter = 0;
  List<Map<String, dynamic>> contactsData = [];
  List<Map<String, dynamic>> unRegisterContactData = [];
  TextEditingController searchText = TextEditingController();
  TextEditingController userText = TextEditingController();

  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  SharedPreferences? prefs;

  final messageCtrl = Get.isRegistered<ChatDashController>()
      ? Get.find<ChatDashController>()
      : Get.put(ChatDashController());

  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());

  final statusCtrl = Get.isRegistered<StatusController>()
      ? Get.find<StatusController>()
      : Get.put(StatusController());
  final callCtrl = Get.isRegistered<CallListController>()
      ? Get.find<CallListController>()
      : Get.put(CallListController());

  onChange(val) async {
    selectedIndex = val;
    if (val == 1) {}
  }

  addDataInList() async {
    appCtrl.registerContact = [];
    appCtrl.update();
    contactsData.asMap().entries.forEach((element) {
      if (element.value["phone"] != appCtrl.user["phone"]) {
        if (!appCtrl.registerContact
            .contains(FirebaseContactModel.fromJson(element.value))) {
          appCtrl.registerContact
              .add(FirebaseContactModel.fromJson(element.value));
        }
        update();
      }
    });

    appCtrl.storage.write(session.registerUser, appCtrl.registerContact);

    unRegisterContactData.asMap().entries.forEach((element) {
      if (element.value["phone"] != appCtrl.user["phone"]) {
        if (!appCtrl.unRegisterContact
            .contains(FirebaseContactModel.fromJson(element.value))) {
          appCtrl.unRegisterContact
              .add(FirebaseContactModel.fromJson(element.value));
        }
        update();
      }
    });

    appCtrl.storage.write(session.unRegisterUser, appCtrl.unRegisterContact);

    appCtrl.update();
    log("AFTER LOGIN :: ${appCtrl.registerContact.length}");
    log("AFTER LOGIN :: ${appCtrl.unRegisterContact.length}");
    Get.forceAppUpdate();
  }

  recentMessageSearch() async {
    if (userText.text.isNotEmpty) {
      isSearch = true;
      update();
    } else {
      isSearch = false;
      update();
    }
    final RecentChatController recentChatController =
        Provider.of<RecentChatController>(Get.context!, listen: false);
    recentChatController.getMessageList(name: userText.text);
    statusCtrl.getAllStatus(search: userText.text);
  }

  getFirebaseContact() async {
    debugPrint(
        "appCtrl.unRegisterContact : ${appCtrl.unRegisterContact.length}");
    await Future.delayed(DurationsClass.s3);

    await addDataInList();
    await Future.delayed(DurationsClass.s3);
    log("DOOOOOO");
  }

  Stream onSearch(val) {
    if (selectedIndex == 0) {
      return FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(messageCtrl.currentUserId)
          .collection(collectionName.chats)
          .where("name", isEqualTo: val)
          .orderBy("updateStamp", descending: true)
          .limit(15)
          .snapshots();
    } else if (selectedIndex == 1) {
      return FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(messageCtrl.currentUserId)
          .collection(collectionName.chats)
          .where("name", isEqualTo: val)
          .orderBy("updateStamp", descending: true)
          .limit(15)
          .snapshots();
    } else {
      Stream<QuerySnapshot<Map<String, dynamic>>>? snapshots = FirebaseFirestore
          .instance
          .collection(collectionName.calls)
          .doc(appCtrl.user["id"])
          .collection(collectionName.collectionCallHistory)
          .where("callerName", isEqualTo: val)
          .orderBy("timestamp", descending: true)
          .snapshots();
      return snapshots;
    }
  }

  Stream callData(val) {
    Stream<QuerySnapshot<Map<String, dynamic>>>? snapshots = FirebaseFirestore
        .instance
        .collection(collectionName.calls)
        .doc(appCtrl.user["id"])
        .collection(collectionName.collectionCallHistory)
        .where("callerName", isEqualTo: val)
        .orderBy("timestamp", descending: true)
        .snapshots();
    return snapshots;
  }

  onTapActionButton() {
    if (tabController?.index == 0) {
      Get.to(() => FetchContact(prefs: prefs));
    } /*else if (tabController?.index == 1) {
      Get.to(() => ContactCall());
    }*/
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException {
      debugPrint('Couldn\'t check connectivity status');
      return;
    }

    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
    update();
  }

  // All BottomNavigation Pages
  final List<Widget> pages = [
    ChatScreen(),
    //  CallScreen(),
    SettingScreen(),
    ProfileScreen(),
    LiveRoom(),
  ];

  fetch() async {
    final Locale systemLocales =
        WidgetsBinding.instance.platformDispatcher.locale;
    log("LOCAKE : $systemLocales");
    final CountryDetails deviceLocale = CountryCodes.detailsForLocale();

    log("LOCAKE : ${deviceLocale.localizedName}");
    tz.initializeTimeZones();

    /*var detroit = tz.getLocation(deviceLocale.localizedName!);
    var now = tz.TZDateTime.now(detroit);
    var timeZone = detroit.timeZone(now.millisecondsSinceEpoch);
    log("timeZone : $timeZone");
    log("timeZone : $now");*/
  }

  fetchLan() async {
    final lan = Get.isRegistered<LanguageController>()
        ? Get.find<LanguageController>()
        : Get.put(LanguageController());
    lan.getLanguageList();
    await CountryCodes.init();
    fetch();
  }

  @override
  void onReady() async {
    var dataFetch = appCtrl.storage.read(session.user);
    //statusCtrl.getCurrentStatus();
    data = dataFetch["image"];
    firebaseCtrl.setIsActive();
    update();
    bottomNavLists = appArray.bottomNavyList;
    await Future.delayed(DurationsClass.s2);
    statusCtrl.getAllStatus();

    tabController =
        TabController(length: appArray.bottomNavyList.length, vsync: this);
    update();
    tabController!.addListener(() {
      update();
      log("SELCTED: %${tabController!.index}");
      callCtrl.isSearch = false;
      callCtrl.update();
      isSearch = false;
      update();
    });
    update();
    Get.forceAppUpdate();
    fetchLan();

    // TODO: implement onReady
    super.onReady();
  }
}
