import 'dart:developer';
import 'package:chatzy/config.dart';

class SelectContactController extends GetxController {

  List contactLists = [];
  bool isSelected = false,isLoading = false;

  ContactModel? registerContact;
  List<UserContactModel> registerList = [], allRegisterList = [];
  List<UserContactModel> unRegisterList = [], allUnRegisterList = [];
  ContactModel? unRegisterContact;



  onRefresh() {
    /*isLoading = true;
    update();
    getAllData();
    getAllUnRegisterUser();
    isLoading = false;*/
    update();
  }

  refreshData()async{
    isLoading = true;
    update();
appCtrl.registerContact =[];
appCtrl.unRegisterContact =[];

    allRegisterList = [];
    allUnRegisterList = [];
    update();

    final dashboardCtrl = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : Get.put(DashboardController());

  //  await dashboardCtrl.addContactInFirebase();
    await Future.delayed(DurationsClass.s3);
    dashboardCtrl.update();
    update();

    await getAllData();
    await  getAllUnRegisterUser();
    update();
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



  onInvitePeople({UserContactModel? item}) async{
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    update();
    Uri smsUri = Uri(
        scheme: 'sms',
        path: phoneNumberExtension(item!.phoneNumber),
        query: encodeQueryParameters(
            <String, String>{'body': "Let's chat on Pepulse! It's a fast, simple, and secure app we can use to message and call our friends for free."})
    );

    try {
      await launchUrl(smsUri);
    } catch (e) {
      flutterAlertMessage(msg: "$e");
    }
    update();
  }

  @override
  void onReady() async{
    if(appCtrl.registerContact.isEmpty && appCtrl.unRegisterContact.isEmpty) {
      await Future.delayed(DurationsClass.s3);
    }
    getAllData();
    getAllUnRegisterUser();
    var data = Get.arguments ?? false;
    isSelected = data ?? false;
      log("DATA C $data");
    contactLists = appArray.selectContactList;
    update();
    // TODO: implement onReady
    super.onReady();
  }

}