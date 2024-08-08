import 'dart:developer';
import 'dart:io';
import 'package:chatzy/config.dart';
import 'package:fast_contacts/fast_contacts.dart';


import '../../screens/bottom_screens/message/layout/alert_back.dart';
import '../../screens/bottom_screens/message/message_firebase_api.dart';

class ChatDashController extends GetxController {

  String? data;

  List<UserContactModel> allRegisterList = [];
  String? currentUserId;
  User? currentUser;
  dynamic storageUser;
  bool isHomePageSelected = true;
  List contactList = [];
  List<Contact> contactUserList = [];
  List contactExistList = [];
  int unSeen = 0;
  bool isLoading = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String? groupId;
  Image? contactPhoto;
  XFile? imageFile;
  File? image;
  List selectedContact = [];
  List chatMenuLists = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFilter = false;

  onTapDots() {
    isFilter = !isFilter;
    update();
  }

  // BOTTOM TAB LAYOUT ICON CLICKED
  void onBottomIconPressed(int index) {
    if (index == 0 || index == 1) {
      isHomePageSelected = true;
      update();
    } else {
      isHomePageSelected = false;
      update();
    }
  }



  //on back
  Future<bool> onWillPop() async {
    return (await showDialog(
      context: Get.context!,
      builder: (context) => const AlertBack(),
    )) ??
        false;
  }

  Future getMessage() async {
    List statusData = [];
    try {
      statusData = await MessageFirebaseApi().getContactList(contactUserList);
    } catch (e) {
      log("message list : $e");
    }
    return statusData;
  }







  onTapAddStory()=> alertDialog(
      title: appFonts.addStory,
      list: appArray.addStoryList,
      onTap: (int index) {
        update();
      }
  );

  @override
  void onReady() {
    chatMenuLists = appArray.chatMenuList;
    final data = appCtrl.storage.read(session.user);
    if(data != null) {
      currentUserId = data["id"];
      storageUser = data;
    }
    // TODO: implement onReady
    super.onReady();
  }

  getAllData() async {
    allRegisterList = [];
    List<UserContactModel> register = [];
    update();
    appCtrl.registerContact = [];
    appCtrl.registerContact = appCtrl.storage.read(session.registerUser) ?? [];

    if (appCtrl.registerContact.isNotEmpty) {
      appCtrl.registerContact.asMap().entries.forEach((element) async {
        if (element.value.phone != appCtrl.user["phone"]) {
          String image = "", status = "";
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .where("phone", isEqualTo: element.value.phone)
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              image = value.docs[0].data()["image"];
              status = value.docs[0].data()["statusDesc"];

              UserContactModel userContactModel = UserContactModel(
                isRegister: true,
                phoneNumber: element.value.phone,
                uid: element.value.id,
                image: image,
                username: element.value.name,
                description: status,
              );
              if (!register.contains(userContactModel)) {
                register.add(userContactModel);

              }
            }
          });
          update();
        }
      });

      allRegisterList = register;
      update();
    }



  }
}