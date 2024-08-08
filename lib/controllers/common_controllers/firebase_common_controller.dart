import 'dart:developer';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../config.dart';
import '../../models/status_model.dart';

class FirebaseCommonController extends GetxController {
  List<PhotoUrl> newPhotoList = [];

  //online status update
  void setIsActive() async {
    var user = appCtrl.storage.read(session.user) ?? "";

    if (user != "") {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .update(
        {
          "status": "Online",
          "isSeen": true,
          "lastSeen": DateTime.now().millisecondsSinceEpoch.toString()
        },
      );
      log("IS CALL");
    }
  }

  //last seen update
  void setLastSeen() async {
    var user = appCtrl.storage.read(session.user) ?? "";
    if (user != "") {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .update(
        {
          "status": "Offline",
          "lastSeen": DateTime.now().millisecondsSinceEpoch.toString()
        },
      );
    }
  }

  //last seen update
  void groupTypingStatus(pId, isTyping) async {
    var user = appCtrl.storage.read(session.user);

    String nameList = "";

    await FirebaseFirestore.instance
        .collection(collectionName.groups)
        .doc(pId)
        .get()
        .then((value) {
      if (value.exists) {
        nameList = value.data()!["status"] ?? "";
        if (nameList != "") {
          String newName = nameList.split(" is typing")[0];
          nameList = "$newName, ${user["name"]}";
        }
      }
    });
    await FirebaseFirestore.instance.collection("groups").doc(pId).update(
      {"status": isTyping ? "$nameList is typing" : ""},
    );
  }

  //typing update
  void setTyping() async {
    var user = appCtrl.storage.read(session.user);
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user["id"])
        .update(
      {
        "status": "typing...",
        "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }

  //status delete after 24 hours
  //status delete after 24 hours
  /*statusDeleteAfter24Hours() async {
    var user = appCtrl.storage.read(session.user) ?? "";
    if (user != "") {
      FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .collection(collectionName.status)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          Status status = Status.fromJson(value.docs[0].data());
          List<PhotoUrl> photoUrl = status.photoUrl!;
          await getPhotoUrl(status.photoUrl!).then((list) async {
            List<PhotoUrl> photoUrls = list;
            log("photoUrls : ${photoUrls.length}");
            if (photoUrls.isEmpty) {
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(user["id"])
                  .collection(collectionName.status)
                  .doc(value.docs[0].id)
                  .delete();
            } else {
              if (photoUrls.length <= status.photoUrl!.length) {
                log("URL : ${photoUrls.length <= status.photoUrl!.length}");
                var statusesSnapshot = await FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(user["id"])
                    .collection(collectionName.status)
                    .get();
                await FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(user["id"])
                    .collection(collectionName.status)
                    .doc(statusesSnapshot.docs[0].id)
                    .update(
                        {'photoUrl': photoUrl.map((e) => e.toJson()).toList()});
              }
            }
          });
        }
      });
    }
  }*/

  syncContact() async {
    await Firebase.initializeApp();
    dynamic user = appCtrl.storage.read(session.user);
    if (user != null) {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .get()
          .then((value) async {
        if (value.exists) {
          log("value : ${value.exists}");
          bool isWebLogin = value.data()!["isWebLogin"] ?? false;
          if (isWebLogin == true) {
            log("appCtrl.contactList.isNotEmpty: ${appCtrl.contactList.isNotEmpty}");
            if (appCtrl.contactList.isNotEmpty) {
              List<Map<String, dynamic>> contactsData =
                  appCtrl.contactList.map((contact) {
                return {
                  'name': contact.displayName,
                  'phoneNumber': contact.phones.isNotEmpty
                      ? phoneNumberExtension(
                          contact.phones[0].number.toString())
                      : null,
                  // Include other necessary contact details
                };
              }).toList();
              await FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(FirebaseAuth.instance.currentUser != null
                      ? FirebaseAuth.instance.currentUser!.uid
                      : user["id"])
                  .collection(collectionName.userContact)
                  .get()
                  .then((allContact) {
                log("CHECK EMPTY : ${allContact.docs.length}");
                if (allContact.docs.isEmpty) {
                  FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(FirebaseAuth.instance.currentUser != null
                          ? FirebaseAuth.instance.currentUser!.uid
                          : user["id"])
                      .collection(collectionName.userContact)
                      .add({'contacts': contactsData});
                }
              });
              log("CHECK EMPTY1 :");
            } else {
              log("CHECK CONTACT");
              if (appCtrl.contactList.isNotEmpty) {
                List<Map<String, dynamic>> contactsData =
                    appCtrl.contactList.map((contact) {
                  return {
                    'name': contact.displayName,
                    'phoneNumber': contact.phones.isNotEmpty
                        ? phoneNumberExtension(
                            contact.phones[0].number.toString())
                        : null,
                    // Include other necessary contact details
                  };
                }).toList();
                await FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(appCtrl.user["id"])
                    .collection(collectionName.userContact)
                    .get()
                    .then((allContact) {
                  log("CHECK EMPTY2: ${allContact.docs.length}");
                  if (allContact.docs.isEmpty) {
                    FirebaseFirestore.instance
                        .collection(collectionName.users)
                        .doc(appCtrl.user["id"])
                        .collection(collectionName.userContact)
                        .add({'contacts': contactsData});
                  }
                });
              }
            }
          }
        }
      });
    }
  }

  bool isMoreThan24HoursAgo(DateTime givenTime) {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Calculate the time difference
    Duration timeDifference = currentTime.difference(givenTime);
    int hour =
        int.parse(appCtrl.usageControlsVal!.statusDeleteTime!.split(" hrs")[0]);
    // Check if the time difference is greater than 24 hours
    return timeDifference.inHours > hour;
  }

  bool isMoreThanMinAgo(DateTime givenTime) {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Calculate the time difference
    Duration timeDifference = currentTime.difference(givenTime);
    int hour =
        int.parse(appCtrl.usageControlsVal!.statusDeleteTime!.split(" min")[0]);



    // Check if the time difference is greater than 24 hours
    return timeDifference.inMinutes >= hour;
  }

  Future<List<PhotoUrl>> getPhotoUrl(List<PhotoUrl> photoUrl) async {
    for (int i = 0; i < photoUrl.length; i++) {
      newPhotoList = [];
      DateTime dt = DateTime.fromMillisecondsSinceEpoch(int.parse(photoUrl[i].expiryDate!
          .toString()));
      var date = DateTime.now();

      debugPrint("diff : ${dt.hour}");

      debugPrint("diff : ${date.hour}");
      debugPrint(
          "diff : ${appCtrl.usageControlsVal!.statusDeleteTime!.contains(" hrs")}");
      if (appCtrl.usageControlsVal!.statusDeleteTime!.contains(" hrs")) {
        /* if (dt.hour <= date.hour) {
          debugPrint("minute : ${dt.minute}");
          debugPrint("minute : ${date.minute}");
          if (dt.minute <= date.minute) {
            debugPrint("minute : ${dt.minute}");
            debugPrint("minute : ${date.minute}");
            newPhotoList.add(photoUrl[i]);
          }
        }*/
        bool isMoreThan24Hours = isMoreThan24HoursAgo(dt);
        if (!isMoreThan24Hours) {
          newPhotoList.add(photoUrl[i]);
        }
      } else if (appCtrl.usageControlsVal!.statusDeleteTime!.contains(" min")) {
        log("ISIIS:");
        bool isMoreThan24Hours = isMoreThanMinAgo(dt);
log("isMoreThan24Hours: $isMoreThan24Hours");
        if (!isMoreThan24Hours) {

          newPhotoList.add(photoUrl[i]);
        }
      }
      update();
    }
    update();
    log("NEWLIST : ${newPhotoList.length}");

    return newPhotoList;
  }

  //send notification
  Future<void> sendNotification(
      {title,
      msg,
      token,
      image,
      dataTitle,
      chatId,
      groupId,
      userContactModel,
      pId,
      pName}) async {
    log('token : $token');
    log("F KEY ${appCtrl.userAppSettingsVal!.firebaseServerToken}");

    final data = {
      "notification": {
        "body": msg,
        "title": dataTitle,
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "alertMessage": 'true',
        "title": title,
        "chatId": chatId,
        "groupId": groupId,
        "userContactModel": userContactModel,
        "pId": pId,
        "pName": pName,
        "imageUrl": image,
        "isGroup": false
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=${appCtrl.userAppSettingsVal!.firebaseServerToken}'
    };

    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: headers,
    );

    try {
      final response = await Dio(options)
          .post('https://fcm.googleapis.com/fcm/send', data: data);
      debugPrint('NOTIFICATION RES $response');
      if (response.statusCode == 200) {
        debugPrint('Alert push notification send');
      } else {
        debugPrint('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      debugPrint('exception $e');
    }
  }

  getAgoraTokenAndChannelName() async {

    final agoraData = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.agoraToken)
        .get();
    await appCtrl.storage.write(session.agoraToken, agoraData.data());
    try {
      HttpsCallable httpsCallable =
          FirebaseFunctions.instance.httpsCallable("generateToken");
      log("agoraData : $agoraData");

      dynamic result = await httpsCallable.call({
        "appId": agoraData["agoraAppId"],
        "appCertificate": agoraData["appCertificate"]
      });

      if (result.data != null) {
        Map<String, dynamic> response = {
          "agoraToken": result.data['data']["token"],
          "channelName": result.data['data']["channelName"],
        };

        return response;
      } else {
        return null;
      }
    } catch (e) {
      log("ERROR WHILE FETCH CREDENTIALS : $e");
    }
  }

  deleteForAllUsers() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .get()
        .then((value) async {
      for (QueryDocumentSnapshot<Map<String, dynamic>> user in value.docs) {
        if(appCtrl.user != null) {
          if (user.id != appCtrl.user['id']) {
            await FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(user.id)
                .collection(collectionName.status)
                .get()
                .then((statusData) {
              for (QueryDocumentSnapshot<Map<String, dynamic>> statusVal
              in statusData.docs) {
                Status status = Status.fromJson(statusVal.data());
                List<PhotoUrl> photoList = status.photoUrl ?? [];
                List<PhotoUrl> newList = [];

                for (PhotoUrl photoUrl in photoList) {
                  DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(photoUrl.expiryDate ?? DateTime
                          .now()
                          .millisecondsSinceEpoch
                          .toString()));
                  if (appCtrl.usageControlsVal!.statusDeleteTime!
                      .contains(" hrs")) {
                    bool isMoreThan24Hours = isMoreThan24HoursAgo(expiryDate);
                    if (!isMoreThan24Hours) {
                      newList.add(photoUrl);
                    }
                  } else if (appCtrl.usageControlsVal!.statusDeleteTime!
                      .contains(" min")) {
                    bool isMoreThan24Hours = isMoreThanMinAgo(expiryDate);

                    if (!isMoreThan24Hours) {
                      newList.add(photoUrl);
                    }
                  }
                }
                FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(user.id)
                    .collection(collectionName.status)
                    .doc(statusVal.id)
                    .update(
                    {"photoUrl": newPhotoList.map((e) => e.toJson()).toList()});
              }
            });
          }
        }else{
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(user.id)
              .collection(collectionName.status)
              .get()
              .then((statusData) {
            for (QueryDocumentSnapshot<Map<String, dynamic>> statusVal
            in statusData.docs) {
              Status status = Status.fromJson(statusVal.data());
              List<PhotoUrl> photoList = status.photoUrl ?? [];
              List<PhotoUrl> newList = [];

              for (PhotoUrl photoUrl in photoList) {
                DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(photoUrl.expiryDate ?? DateTime
                        .now()
                        .millisecondsSinceEpoch
                        .toString()));
                if (appCtrl.usageControlsVal!.statusDeleteTime!
                    .contains(" hrs")) {
                  bool isMoreThan24Hours = isMoreThan24HoursAgo(expiryDate);
                  if (!isMoreThan24Hours) {
                    newList.add(photoUrl);
                  }
                } else if (appCtrl.usageControlsVal!.statusDeleteTime!
                    .contains(" min")) {
                  bool isMoreThan24Hours = isMoreThanMinAgo(expiryDate);

                  if (!isMoreThan24Hours) {
                    newList.add(photoUrl);
                  }
                }
              }
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(user.id)
                  .collection(collectionName.status)
                  .doc(statusVal.id)
                  .update(
                  {"photoUrl": newPhotoList.map((e) => e.toJson()).toList()});
            }
          });
        }
      }
    });
  }
}
