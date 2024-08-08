import 'dart:developer';
import 'dart:io';
import 'package:chatzy/config.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import '../../screens/app_screens/group_message_screen/group_firebase_api.dart';
import '../../widgets/reaction_pop_up/emoji_picker_widget.dart';
import '../recent_chat_controller.dart';

class ProfileSetupController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  GlobalKey<FormState> profileGlobalKey = GlobalKey<FormState>();
  List profileSelectList = [];
  bool isPhoneLogin = false, isEmoji = false;
  XFile? imageFile;
  String imageUrl = "", dialCode = "", phone = "";
  bool isLogin = false;
  dynamic user;
  bool isLoading = false;
  String? number, image;
  var selectedCountry = ''.obs;
  var selectedState = ''.obs;
  var selectedCity = ''.obs;

  onTapEmoji() {
    showModalBottomSheet(
        barrierColor: appCtrl.appTheme.trans,
        backgroundColor: appCtrl.appTheme.trans,
        context: Get.context!,
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.r25))),
        builder: (BuildContext context) {
          // return your layout
          return EmojiPickerWidget(
              controller: statusController,
              onSelected: (emoji) {
                statusController.text + emoji;
              });
        });
    update();
  }

  void updateCountry(String value) {
    selectedCountry.value = value;
    selectedState.value = ''; // Reset state
    selectedCity.value = ''; // Reset city
  }

  void updateState(String value) {
    selectedState.value = value;
    selectedCity.value = ''; // Reset city
  }

  void updateCity(String value) {
    selectedCity.value = value;
  }

  onTapProfile(profileCtrl) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
                dialogBackgroundColor: appCtrl.appTheme.white,
                dialogTheme:
                    DialogTheme(surfaceTintColor: appCtrl.appTheme.white)),
            child: AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppRadius.r8))),
                backgroundColor: appCtrl.appTheme.white,
                titlePadding: const EdgeInsets.all(Insets.i20),
                title: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(appFonts.addProfile.tr,
                            style: AppCss.manropeBold16
                                .textColor(appCtrl.appTheme.darkText)),
                        Icon(CupertinoIcons.multiply,
                                color: appCtrl.appTheme.darkText)
                            .inkWell(onTap: () => Get.back())
                      ]),
                  const VSpace(Sizes.s15),
                  Divider(
                      color: appCtrl.appTheme.darkText.withOpacity(0.1),
                      height: 1,
                      thickness: 1)
                ]),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    Image.asset(eImageAssets.gallery, height: Sizes.s44),
                    const HSpace(Sizes.s15),
                    Text(appFonts.selectFromGallery.tr,
                        style: AppCss.manropeBold14
                            .textColor(appCtrl.appTheme.darkText))
                  ]).inkWell(onTap: () {
                    getImage(ImageSource.gallery);
                    Get.back();
                  }).paddingOnly(bottom: Insets.i30),
                  Row(children: [
                    Image.asset(eImageAssets.camera, height: Sizes.s44),
                    const HSpace(Sizes.s15),
                    Text(appFonts.openCamera.tr,
                        style: AppCss.manropeBold14
                            .textColor(appCtrl.appTheme.darkText))
                  ]).inkWell(onTap: () {
                    getImage(ImageSource.camera);
                    Get.back();
                  }).paddingOnly(bottom: Insets.i30),
                  if (profileCtrl != '')
                    Row(children: [
                      Image.asset(eImageAssets.anonymous, height: Sizes.s44),
                      const HSpace(Sizes.s15),
                      Text(appFonts.removePhoto,
                          style: AppCss.manropeBold14
                              .textColor(appCtrl.appTheme.darkText))
                    ]).inkWell(onTap: () {
                      Get.back();
                      noProfile();
                      update();
                    })
                ]).padding(horizontal: Sizes.s20, bottom: Insets.i20)),
          );
        });
  }

  /*alertDialog(
    title: appFonts.addProfile,
    list: appArray.addProfilePhotoList,
    onTap: (int index) {
      if(index == 0) {
        getImage(ImageSource.gallery);
        Get.back();
      } else if (index == 1) {
        getImage(ImageSource.camera);
        Get.back();
      } else {
        noProfile();
       */ /*var dataFetch = appCtrl.storage.read(session.user);
        dataFetch["image"] = '';
        log("USER LIST ${dataFetch["image"]}");
       appCtrl.storage.write(session.user, dataFetch);
       Get.forceAppUpdate();
        update();*/ /*
       update();
       Get.back();
      }
       update();
    }
  );*/

  // GET IMAGE FROM GALLERY
  Future getImage(source) async {
    final ImagePicker picker = ImagePicker();
    imageFile = (await picker.pickImage(source: source))!;
    log("imageFile : $imageFile");
    if (imageFile != null) {
      update();
      uploadFile();
    }
  }

  // UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadFile() async {
    isLoading = true;
    update();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    log("reference : $reference");
    var file = File(imageFile!.path);
    UploadTask uploadTask = reference.putFile(file);

    uploadTask.then((res) {
      log("res : $res");
      res.ref.getDownloadURL().then((downloadUrl) async {
        image = imageUrl;
        await appCtrl.storage.write(session.user, user);
        imageUrl = downloadUrl;
        log(user["id"]);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user["id"])
            .update({'image': imageUrl}).then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(user["id"])
              .get()
              .then((snap) async {
            await appCtrl.storage.write(session.user, snap.data());
            user = snap.data();
            final dashCtrl = Get.isRegistered<DashboardController>()
                ? Get.find<DashboardController>()
                : Get.put(DashboardController());
            dashCtrl.data = imageUrl;
            dashCtrl.update();
            update();
            appCtrl.user = user;
            appCtrl.update();
          });
        });
        isLoading = false;
        update();
        log("IMAGE $image");

        update();
      }, onError: (err) {
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
  }

  //submit/update user
/*  submitUserData() async {
    if (profileGlobalKey.currentState!.validate()) {
      isLoading = true;
      update();
      String storageDialCode = appCtrl.storage.read(session.dialCode);
      Get.forceAppUpdate();
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      firebaseMessaging.getToken().then((token) async {
        if (isPhoneLogin) {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .where("email", isEqualTo: emailController.text)
              .limit(1)
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                  const SnackBar(content: Text("Email Already Exist")));
            } else {
              log("UUU : ${user["id"]}");
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(user["id"])
                  .update({
                'image': imageUrl,
                'name': userNameController.text,
                'status': "Online",
                "typeStatus": "",
                "email": emailController.text,
                "statusDesc": statusController.text,
                "dialCode": dialCode,
                "pushToken": token,
                'phone':
                    "$dialCode${user['phone'].toString().replaceAll(storageDialCode, '')}",
                "dialCodePhoneList": phoneList(
                    phone: user['phone']
                        .toString()
                        .replaceAll(storageDialCode, ''),
                    dialCode: dialCode),
                "isActive": true
              }).then((result) async {
                debugPrint("new USer true");
                await FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(user["id"])
                    .get()
                    .then((value) async {
                  appCtrl.user = value.data();
                  appCtrl.update();
                  await appCtrl.storage.write("id", user["id"]);
                  await appCtrl.storage.write(session.user, value.data());
                });

                final RecentChatController recentChatController =
                    Provider.of<RecentChatController>(Get.context!,
                        listen: false);
                debugPrint("INIT PAGE1 : ${appCtrl.user}");

                recentChatController.getModel(appCtrl.user);
                update();
                contactPermissions(appCtrl.user["id"]);
              }).catchError((onError) {
                log("onError dhgf: $onError");
              });
            }
          });
        } else {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .where("email", isEqualTo: emailController.text)
              .limit(1)
              .get()
              .then((value) {
            FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(user["id"])
                .update({
              'image': imageUrl,
              'name': userNameController.text,
              'status': "Online",
              "typeStatus": "",
              "email": emailController.text,
              "dialCode": dialCode,
              "statusDesc": statusController.text,
              "pushToken": token,
              'phone':
                  "$dialCode${user['phone'].toString().replaceAll(storageDialCode, '')}",
              "dialCodePhoneList": phoneList(
                  phone:
                      user['phone'].toString().replaceAll(storageDialCode, ''),
                  dialCode: dialCode),
              "isActive": true
            }).then((result) async {
              debugPrint("new USer true 1");
              await FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(user["id"])
                  .get()
                  .then((values) async {
                appCtrl.user = values.data();
                appCtrl.update();
                await appCtrl.storage.write(session.id, user["id"]);
                await appCtrl.storage.write(session.user, values.data());
                debugPrint("USER DATTTTA ${values.data()}");
              });
              if (user['phone'] != null) {
                flutterAlertMessage(
                    msg: appFonts.dataUpdatingSuccessfully.tr,
                    bgColor: appCtrl.appTheme.primary);
                final RecentChatController recentChatController =
                    Provider.of<RecentChatController>(Get.context!,
                        listen: false);
                recentChatController.getModel(appCtrl.user);
                update();
                contactPermissions(appCtrl.user["id"]);
              } else {
                flutterAlertMessage(
                    msg: appFonts.dataUpdatingSuccessfully.tr,
                    bgColor: appCtrl.appTheme.primary);
              }
            }).catchError((onError) {
              log("onError 12: $onError");
            });
          });
        }
        isLoading = false;
        update();
      });
    }
  }*/

  Future<void> submitUserData() async {
    if (profileGlobalKey.currentState!.validate()) {
      isLoading = true;
      update();
      String storageDialCode = appCtrl.storage.read(session.dialCode);
      Get.forceAppUpdate();
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      firebaseMessaging.getToken().then((token) async {
        if (isPhoneLogin) {
          await handlePhoneLogin(storageDialCode, token);
        } else {
          await handleEmailLogin(storageDialCode, token);
        }
        isLoading = false;
        update();
        await Future.delayed(DurationsClass.s4);
        Get.offAllNamed(routeName.dashboard,
            arguments: pref);
      });
    }
  }

  Future<void> handlePhoneLogin(String storageDialCode, String? token) async {
    FirebaseFirestore.instance
        .collection(collectionName.users)
        .where("email", isEqualTo: emailController.text)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(const SnackBar(content: Text("Email Already Exist")));
      } else {
        updateUserInFirestore(storageDialCode, token);
      }
    });
  }

  Future<void> handleEmailLogin(String storageDialCode, String? token) async {
    FirebaseFirestore.instance
        .collection(collectionName.users)
        .where("email", isEqualTo: emailController.text)
        .limit(1)
        .get()
        .then((value) {
      updateUserInFirestore(storageDialCode, token);
    });
  }

  Future<void> updateUserInFirestore(String storageDialCode, String? token) async {
    FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user["id"])
        .update({
      'image': imageUrl,
      'name': userNameController.text,
      'status': "Online",
      "typeStatus": "",
      "email": emailController.text,
      "statusDesc": statusController.text,
      "dialCode": dialCode,
      "pushToken": token,
      'phone': "$dialCode${user['phone'].toString().replaceAll(storageDialCode, '')}",
      "dialCodePhoneList": phoneList(
          phone: user['phone'].toString().replaceAll(storageDialCode, ''),
          dialCode: dialCode),
      "isActive": true,
      "country": selectedCountry.value,
      "state": selectedState.value,
      "city": selectedCity.value,
    }).then((result) async {
      await updateAppCtrlUser();
      await checkAndCreateGroups();
    }).catchError((onError) {
      log("onError: $onError");
    });
  }

  Future<void> updateAppCtrlUser() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user["id"])
        .get()
        .then((value) async {
      appCtrl.user = value.data();
      appCtrl.update();
      await appCtrl.storage.write(session.id, user["id"]);
      await appCtrl.storage.write(session.user, value.data());
    });
  }

  Future<void> checkAndCreateGroups() async {
    await checkAndCreateGroup(selectedCountry.value, "country", "country");
    await checkAndCreateGroup(selectedState.value, "state", "state");
    await checkAndCreateGroup(selectedCity.value, "city", "city");
  }

  Future<void> checkAndCreateGroup(String groupName, String groupType, String groupLevel) async {
    if (groupName.isEmpty) return;

    FirebaseFirestore.instance
        .collection(collectionName.groups)
        .where('name', isEqualTo: groupName)
        .where('type', isEqualTo: groupType)
        .where('level', isEqualTo: groupLevel)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        addUserToGroup(groupName, groupType, groupLevel, value.docs.first.id);
      } else {
        createGroup(groupName, groupType, groupLevel);
      }
    });
  }

  Future<void> addUserToGroup(String groupName, String groupType, String groupLevel, String groupId) async {
    await FirebaseFirestore.instance
        .collection(collectionName.groups)
        .doc(groupId)
        .update({
      "users": FieldValue.arrayUnion([{
        "id": user["id"],
        "name": user["name"],
        "phone": user["phone"],
        "image": user["image"]
      }])
    });
    GroupFirebaseApi groupApi = GroupFirebaseApi();
    GroupMessageController groupCtrl = Get.put(GroupMessageController());
    await groupApi.ExistGroupWithName(groupCtrl, groupName, groupType, groupLevel,groupId);
  }

  Future<void> createGroup(String groupName, String groupType, String groupLevel) async {
    GroupFirebaseApi groupApi = GroupFirebaseApi();
    GroupMessageController groupCtrl = Get.put(GroupMessageController());
    await groupApi.createGroupWithName(groupCtrl, groupName, groupType, groupLevel);
  }



  contactPermissions(userid) {
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(appFonts.contactList.tr,
                          style: AppCss.manropeBold18
                              .textColor(appCtrl.appTheme.txt)),
                      Icon(CupertinoIcons.multiply, color: appCtrl.appTheme.txt)
                          .inkWell(onTap: () => Get.back())
                    ])
              ]),
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VSpace(Sizes.s20),
                    Text(appFonts.contactPer.tr,
                        style: AppCss.manropeLight12
                            .textColor(appCtrl.appTheme.txt)
                            .textHeight(1.3)),
                    const VSpace(Sizes.s15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Divider(
                            height: 1,
                            color: appCtrl.appTheme.divider,
                            thickness: 1),
                        const VSpace(Sizes.s15),
                        Row(
                          children: [
                            Expanded(
                              child: ButtonCommon(
                                color: appCtrl.appTheme.white,
                                borderColor: appCtrl.appTheme.primary,
                                title: appFonts.cancel.tr,
                                style: AppCss.manropeMedium14
                                    .textColor(appCtrl.appTheme.primary),
                                onTap: () async {
                                  Get.back();
                                  final FetchContactController
                                      registerAvailableContact =
                                      Provider.of<FetchContactController>(
                                          Get.context!,
                                          listen: false);
                                  registerAvailableContact.setIsLoading(false);

                                  await appCtrl.storage
                                      .write(session.isIntro, true);
                                  await Future.delayed(DurationsClass.s3);
                                  isLoading = true;
                                  await appCtrl.storage
                                      .write(session.id, userid);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user["id"])
                                      .update({'status': "Online"});
                                  Get.offAllNamed(routeName.dashboard,
                                      arguments: pref);
                                },
                              ),
                            ),
                            const HSpace(Sizes.s15),
                            Expanded(
                              child: ButtonCommon(
                                title: appFonts.accept.tr,
                                style: AppCss.manropeMedium14
                                    .textColor(appCtrl.appTheme.white),
                                onTap: () async {
                                  Get.back();
                                  final FetchContactController
                                      registerAvailableContact =
                                      Provider.of<FetchContactController>(
                                          Get.context!,
                                          listen: false);
                                  log("INIT PAGEaaa");
                                  registerAvailableContact.fetchContacts(
                                      Get.context!,
                                      appCtrl.user["phone"],
                                      pref!,
                                      false);
                                  await appCtrl.storage
                                      .write(session.isIntro, true);
                                  await Future.delayed(DurationsClass.s3);
                                  isLoading = false;
                                  update();
                                  await appCtrl.storage
                                      .write(session.id, userid);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user["id"])
                                      .update({'status': "Online"});
                                  Get.forceAppUpdate();
                                  Get.offAllNamed(routeName.dashboard,
                                      arguments: pref);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ).width(MediaQuery.of(context).size.width)
                  ]).padding(horizontal: Sizes.s20, bottom: Insets.i20));
        });
  }

  updateUserData() {
    if (profileGlobalKey.currentState!.validate()) {
      isLoading = true;
      log("imageUrl : $imageUrl");
      update();
      String storageDialCode = appCtrl.storage.read(session.dialCode);
      Get.forceAppUpdate();
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      firebaseMessaging.getToken().then((token) async {
        if (isPhoneLogin) {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .where("email", isEqualTo: emailController.text)
              .limit(1)
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                  const SnackBar(content: Text("Email Already Exist")));
            } else {
              log("userNameController.text::${userNameController.text}");
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(user["id"])
                  .update({
                'image': imageUrl,
                'name': userNameController.text,
                'status': "Online",
                "typeStatus": "",
                "email": emailController.text,
                "statusDesc": statusController.text,
                "pushToken": token,
                "dialCode": dialCode,
                'phone':
                    "$dialCode${user['phone'].toString().replaceAll(storageDialCode, '')}",
                "dialCodePhoneList": phoneList(
                    phone: user['phone']
                        .toString()
                        .replaceAll(storageDialCode, ''),
                    dialCode: dialCode),
                "isActive": true
              }).then((result) async {
                log("new USer true");
                FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(user["id"])
                    .get()
                    .then((value) async {
                  appCtrl.user = value.data();
                  appCtrl.update();
                  await appCtrl.storage.write("id", user["id"]);
                  await appCtrl.storage.write(session.user, value.data());
                });
                flutterAlertMessage(
                    msg: appFonts.dataUpdatingSuccessfully.tr,
                    bgColor: appCtrl.appTheme.primary);
              }).catchError((onError) {
                log("onError11 :$onError");
              });
            }
          });
        } else {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .where("email", isEqualTo: emailController.text)
              .limit(1)
              .get()
              .then((value) {
            FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(user["id"])
                .update({
              'image': imageUrl,
              'name': userNameController.text,
              'status': "Online",
              "typeStatus": "",
              "email": emailController.text,
              "statusDesc": statusController.text,
              "pushToken": token,
              "dialCode": dialCode,
              'phone':
                  "$dialCode${user['phone'].toString().replaceAll(storageDialCode, '')}",
              "dialCodePhoneList": phoneList(
                  phone:
                      user['phone'].toString().replaceAll(storageDialCode, ''),
                  dialCode: dialCode),
              "isActive": true
            }).then((result) async {
              log("new USer true 1");
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(user["id"])
                  .get()
                  .then((value) async {
                appCtrl.user = value.data();
                appCtrl.update();
                await appCtrl.storage.write(session.id, user["id"]);
                await appCtrl.storage.write(session.user, value.data());
                log("USER DATTTTA ${value.data()}");
              });
              flutterAlertMessage(
                  msg: appFonts.dataUpdatingSuccessfully.tr,
                  bgColor: appCtrl.appTheme.primary);
            }).catchError((onError) {
              log("onError 22 :$onError");
            });
          });
        }
        isLoading = false;
        update();
      });
    }
  }

  noProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user["id"])
        .update({'image': ""}).then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user["id"])
          .get()
          .then((snap) async {
        await appCtrl.storage.write(session.user, snap.data());
        user = snap.data();
        final dashCtrl = Get.isRegistered<DashboardController>()
            ? Get.find<DashboardController>()
            : Get.put(DashboardController());
        dashCtrl.data = "";
        dashCtrl.update();
        imageUrl = '';
        update();
      });
    });
  }

  SharedPreferences? pref;

  @override
  void onReady() {
    /* pref = Get.arguments;
    profileSelectList = appArray.addProfilePhotoList;
    var data = Get.arguments ?? appCtrl.storage.read(session.user);
    log("DATA $data");
    user =  appCtrl.storage.read(session.user) ;
    number =  user["phone"] ?? "";
    log("NUMBER ${number}");
    userNameController.text = user["name"] ?? "";
    emailController.text = user["email"] ?? "";
    statusController.text = user["statusDesc"] ?? "";
    image = user["image"] ?? "";
    log("IMAGEEEEE $image");
    isPhoneLogin = data["isPhoneLogin"] ?? false;
    isLogin = data["isOnlyLogin"] ?? false;*/

    //statusText.text = "Hello, I am using Chatter";
    var data = Get.arguments;
    user = data["resultData"];
    pref = data["pref"];
    dialCode = data["dialCode"];
    phone = data["phone"];
    isPhoneLogin = data["isPhoneLogin"];
    userNameController.text = user["name"] ?? "";
    emailController.text = user["email"] ?? "";
    statusController.text = user["statusDesc"] ?? "";
    imageUrl = user["image"] ?? "";
    appCtrl.pref = pref;
    appCtrl.update();

    update();
    // TODO: implement onReady
    super.onReady();
  }
}
