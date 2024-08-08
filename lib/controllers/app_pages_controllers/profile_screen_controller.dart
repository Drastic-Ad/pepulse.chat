import 'dart:developer';
import 'dart:io';

import 'package:chatzy/config.dart';
import 'package:chatzy/models/status_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:localstorage/localstorage.dart';

import '../../widgets/reaction_pop_up/emoji_picker_widget.dart';

class ProfileScreenController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  GlobalKey<FormState> profileGlobalKey = GlobalKey<FormState>();

  bool isLoading = false;
  String imageUrl = "";
  XFile? imageFile;
  String? image;

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

  updateUserData() {
    if (profileGlobalKey.currentState!.validate()) {
      isLoading = true;
      log("imageUrl : $imageUrl");
      update();
      Get.forceAppUpdate();
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      firebaseMessaging.getToken().then((token) async {
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .where("email", isEqualTo: emailController.text)
            .limit(1)
            .get()
            .then((value) {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(appCtrl.user["id"])
              .update({
            'image': imageUrl != "" ? imageUrl : appCtrl.user["image"],
            'name': userNameController.text,
            'status': "Online",
            "typeStatus": "",
            "email": emailController.text,
            "statusDesc": statusController.text,
            "pushToken": token,
            "isActive": true
          }).then((result) async {
            log("new USer true 1");
            await FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(appCtrl.user["id"])
                .get()
                .then((value) async {
              appCtrl.user = value.data();
              appCtrl.update();
              await appCtrl.storage.write(session.id, appCtrl.user["id"]);
              await appCtrl.storage.write(session.user, value.data());
              log("USER DATTTTA ${value.data()}");
            });
            flutterAlertMessage(
                msg: appFonts.dataUpdatingSuccessfully.tr,
                bgColor: appCtrl.appTheme.primary);
          }).catchError((onError) {
            log("onError");
          });
        });
        /*if (isPhoneLogin) {
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .where("email", isEqualTo: emailController.text)
            .limit(1)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            ScaffoldMessenger.of(Get.context!)
                .showSnackBar(
                const SnackBar(content: Text("Email Already Exist")));
          } else {
            FirebaseFirestore.instance.collection(collectionName.users)
                .doc(appCtrl.user["id"])
                .update(
                {
                  'image': imageUrl,
                  'name': userNameController.text,
                  'status': "Online",
                  "typeStatus": "",
                  "email": emailController.text,
                  "statusDesc": statusController.text,
                  "pushToken": token,
                  "isActive": true
                })
                .then((result) async {
              log("new USer true");
              FirebaseFirestore.instance.collection(collectionName.users)
                  .doc(appCtrl.user["id"])
                  .get()
                  .then((value) async {
                await appCtrl.storage.write("id", appCtrl.user["id"]);
                await appCtrl.storage.write(session.user, value.data());
              });
              flutterAlertMessage(msg: appFonts.dataUpdatingSuccessfully,
                  bgColor: appCtrl.appTheme.primary);
            }).catchError((onError) {
              log("onError");
            });
          }
        });
      } else {

      }*/
        isLoading = false;
        update();
      });
    }
  }

// GET IMAGE FROM GALLERY
  Future getImage(source) async {
    final ImagePicker picker = ImagePicker();
    XFile? compressedFiles = (await picker.pickImage(source: source))!;

    File compressedFile = await FlutterNativeImage.compressImage(
        compressedFiles.path,
        quality: 30);
    imageFile = XFile(compressedFile.path);
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
        await appCtrl.storage.write(session.user, appCtrl.user);
        imageUrl = downloadUrl;
        log(appCtrl.user["id"]);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(appCtrl.user["id"])
            .update({'image': imageUrl}).then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(appCtrl.user["id"])
              .get()
              .then((snap) async {
            await appCtrl.storage.write(session.user, snap.data());
            appCtrl.user = snap.data();
            final dashCtrl = Get.isRegistered<DashboardController>()
                ? Get.find<DashboardController>()
                : Get.put(DashboardController());
            dashCtrl.data = imageUrl;
            dashCtrl.update();
            update();
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

  onTapProfile(profileCtrl) {
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
                      Text(appFonts.addProfile,
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
                  Text(appFonts.selectFromGallery,
                      style: AppCss.manropeBold14
                          .textColor(appCtrl.appTheme.darkText))
                ]).inkWell(onTap: () {
                  getImage(ImageSource.gallery);
                  Get.back();
                }).paddingOnly(bottom: Insets.i30),
                Row(children: [
                  Image.asset(eImageAssets.camera, height: Sizes.s44),
                  const HSpace(Sizes.s15),
                  Text(appFonts.openCamera,
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
              ]).padding(horizontal: Sizes.s20, bottom: Insets.i20));
        });
  }

  noProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(appCtrl.user["id"])
        .update({'image': ""}).then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(appCtrl.user["id"])
          .get()
          .then((snap) async {
        await appCtrl.storage.write(session.user, snap.data());
        appCtrl.user = snap.data();
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

  deleteUser() async {
    await showDialog(
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
                Image.asset(eImageAssets.deleteAccount,
                    height: Sizes.s115, width: Sizes.s115),
                Text(appFonts.deleteAccount.tr,
                    style: AppCss.manropeBold16
                        .textColor(appCtrl.appTheme.darkText)),
                const VSpace(Sizes.s10),
                Text(appFonts.youWillLostAllData.tr,
                    textAlign: TextAlign.center,
                    style: AppCss.manropeMedium14
                        .textColor(appCtrl.appTheme.greyText)),
                Divider(
                        height: 1,
                        color: appCtrl.appTheme.borderColor,
                        thickness: 1)
                    .paddingSymmetric(vertical: Insets.i15),
                Text(appFonts.deleteAccount.tr,
                        style: AppCss.manropeblack14
                            .textColor(appCtrl.appTheme.redColor))
                    .inkWell(onTap: () async {
                  isLoading = true;
                  update();

                  await FirebaseFirestore.instance
                      .collection(collectionName.calls)
                      .doc(appCtrl.user["id"])
                      .delete();
                  await FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(appCtrl.user["id"])
                      .collection(collectionName.status)
                      .get()
                      .then((value) {
                    for (QueryDocumentSnapshot<Map<String, dynamic>> ds
                        in value.docs) {
                      Status status = Status.fromJson(ds.data());
                      List<PhotoUrl> photoUrl = status.photoUrl ?? [];
                      for (var list in photoUrl) {
                        if (list.statusType == StatusType.image.name ||
                            list.statusType == StatusType.video.name) {
                          FirebaseStorage.instance
                              .refFromURL(list.image!)
                              .delete();
                        }
                      }
                    }
                  });
                  await FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(appCtrl.user["id"])
                      .collection(collectionName.chats)
                      .get()
                      .then((value) {
                    for (DocumentSnapshot ds in value.docs) {
                      ds.reference.delete();
                    }
                  });
                  await FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(appCtrl.user["id"])
                      .collection(collectionName.messages)
                      .get()
                      .then((value) {
                    for (QueryDocumentSnapshot<Map<String, dynamic>> ds
                        in value.docs) {
                      if (ds.data()["type"] == MessageType.image.name ||
                          ds.data()["type"] == MessageType.audio.name ||
                          ds.data()["type"] == MessageType.video.name ||
                          ds.data()["type"] == MessageType.doc.name ||
                          ds.data()["type"] == MessageType.gif.name ||
                          ds.data()["type"] == MessageType.imageArray.name) {
                        String url = decryptMessage(ds.data()["content"]);
                        FirebaseStorage.instance
                            .refFromURL(url.contains("-BREAK-")
                                ? url.split("-BREAK-")[0]
                                : url)
                            .delete();
                      }
                      ds.reference.delete();
                    }
                  });
                  await FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(appCtrl.user["id"])
                      .collection(collectionName.groupMessage)
                      .get()
                      .then((value) {
                    for (QueryDocumentSnapshot<Map<String, dynamic>> ds
                        in value.docs) {
                      if (ds.data()["type"] == MessageType.image.name ||
                          ds.data()["type"] == MessageType.audio.name ||
                          ds.data()["type"] == MessageType.video.name ||
                          ds.data()["type"] == MessageType.doc.name ||
                          ds.data()["type"] == MessageType.gif.name ||
                          ds.data()["type"] == MessageType.imageArray.name) {
                        String url = decryptMessage(ds.data()["content"]);
                        FirebaseStorage.instance
                            .refFromURL(url.contains("-BREAK-")
                                ? url.split("-BREAK-")[0]
                                : url)
                            .delete();
                      }
                      ds.reference.delete();
                    }
                  });

                  await FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(appCtrl.user["id"])
                      .collection(collectionName.broadcastMessage)
                      .get()
                      .then((value) {
                    for (QueryDocumentSnapshot<Map<String, dynamic>> ds
                        in value.docs) {
                      if (ds.data()["type"] == MessageType.image.name ||
                          ds.data()["type"] == MessageType.audio.name ||
                          ds.data()["type"] == MessageType.video.name ||
                          ds.data()["type"] == MessageType.doc.name ||
                          ds.data()["type"] == MessageType.gif.name ||
                          ds.data()["type"] == MessageType.imageArray.name) {
                        String url = decryptMessage(ds.data()["content"]);
                        FirebaseStorage.instance
                            .refFromURL(url.contains("-BREAK-")
                                ? url.split("-BREAK-")[0]
                                : url)
                            .delete();
                      }
                      ds.reference.delete();
                    }
                  });

                  await FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(appCtrl.user["id"])
                      .delete();
                  await appCtrl.storage.remove(session.isDarkMode);
                  await appCtrl.storage.remove(session.isRTL);
                  await appCtrl.storage.remove(session.languageCode);
                  await appCtrl.storage.remove(session.languageCode);
                  await appCtrl.storage.remove(session.user);
                  await appCtrl.storage.remove(session.id);
                  FirebaseAuth.instance.signOut();
                  isLoading = false;
                  update();
                  appCtrl.pref!.remove('storageUserString');
                  appCtrl.user = null;
                  appCtrl.pref = null;
                  final LocalStorage storage = LocalStorage('model');
                  final LocalStorage cachedContacts = LocalStorage('cachedContacts');
                  final LocalStorage messageModel = LocalStorage('messageModel');
                  final LocalStorage statusModel = LocalStorage('statusModel');
                  await storage.clear();
                  await cachedContacts.clear();

                  await messageModel.clear();

                  await statusModel.clear();
                  Get.offAllNamed(routeName.phoneWrap,
                      arguments: appCtrl.pref);
                })
              ]).padding(horizontal: Sizes.s20, bottom: Insets.i20));
        });
  }

  @override
  void onReady() {
    emailController.text = appCtrl.user["email"] ?? '';
    statusController.text = appCtrl.user["statusDesc"] ?? '';
    userNameController.text = appCtrl.user["name"] ?? '';
    update();

    // TODO: implement onReady
    super.onReady();
  }
}
