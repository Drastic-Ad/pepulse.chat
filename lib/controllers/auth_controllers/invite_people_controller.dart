import 'dart:developer';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:share_plus/share_plus.dart';
import '../../config.dart';


class InvitePeopleController extends GetxController {
  List<Contact>? contacts;

  ContactModel? registerContact;
  List<UserContactModel> registerList = [], allRegisterList = [];
  List<UserContactModel> unRegisterList = [], allUnRegisterList = [];
  ContactModel? unRegisterContact;
  List<UserContactModel> list = [];
  SharedPreferences? pref;
  
  //Check contacts permission
  getPermission() async {
    await Permission.contacts.request().then((value) =>   Permission.notification.request());

    final PermissionStatus permission = await Permission.contacts.status;
    if (permission.isGranted) {
      getContacts();
    } else {
      flutterAlertMessage(msg: "Permission Not Granted");
    }
  }

  onSearch(val) async {

    registerList = [];
    unRegisterList = [];
    registerContact!.userTitle!.asMap().entries.forEach((element) {
      if (element.value.username!.toLowerCase().contains(val)) {
        if (!registerList.contains(element.value)) {
          registerList.add(element.value);
        }
      }
    });
    unRegisterContact!.userTitle!.asMap().entries.forEach((element) {
      if (element.value.username!.toLowerCase().contains(val)) {
        if (!unRegisterList.contains(element.value)) {
          unRegisterList.add(element.value);
        }
      }
    });
    log("unRegisterList : ${unRegisterList.length}");
    update();
    //fetchRegisterData(0);
  }


  getAllUnRegisterUser() async {
    List<UserContactModel> unRegister = [];
    debugPrint("ppCtrl.unRegisterContact : ${appCtrl.unRegisterContact.length}");
    if (appCtrl.unRegisterContact.isNotEmpty) {
      appCtrl.unRegisterContact.asMap().entries.forEach((element) async {
        UserContactModel userContactModel = UserContactModel(
          isRegister: false,
          phoneNumber: element.value.phone,
          uid: "0",
          contactImage: element.value.photo,
          username: element.value.name,
          description: "",
        );
        if (!unRegister.contains(userContactModel)) {
          unRegister.add(userContactModel);
        }
      });

      allUnRegisterList = unRegister;

      update();
    }
    update();
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final List<Contact> contact = await FastContacts.getAllContacts();
    contacts = contact;
    update();
  }

  onInvitePeople({number}) async{

    try {
      Share.share("Let's chat on Pepulse! It's a fast, simple, and secure app we can use to message and call our friends for free.");

    } catch (e) {
      flutterAlertMessage(msg: "$e");
    }
    update();
  }

onSkip() {
    appCtrl.storage.write("skip", true);
    Get.offAllNamed(routeName.dashboard,arguments: pref);
    update();
}

  @override
  void onReady() async {
    pref = Get.arguments;
    log("INVITE LOG $pref");
    update();
    // TODO: implement onInit
    super.onReady();
  }
}
