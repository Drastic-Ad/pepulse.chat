import 'dart:developer';

import '../../config.dart';
import '../../models/call_model.dart';

class CallListController extends GetxController {
  List settingList = [];
  dynamic user;
  bool isSearch = false;
  bool isContactSearch = false;
  TextEditingController searchText = TextEditingController();
  TextEditingController searchContactText = TextEditingController();
  bool bannerAdIsLoaded = false;
  List<RegisterContactDetail> searchList = [];
  DateTime now = DateTime.now();

  @override
  void onReady() {
    // TODO: implement onReady

    super.onReady();
  }

  //delete chat layout
  buildPopupDialog() async {
    await showDialog(
        context: Get.context!,
        builder: (_) => GetBuilder<CallListController>(builder: (chatCtrl) {
              return AlertDialog(
                backgroundColor: appCtrl.appTheme.screenBG,
                title: Text(appFonts.alert.tr),
                content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Are you sure you want to delete the call history")
                    ]),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Get.back(), child: const Text('Close')),
                  TextButton(
                    onPressed: () async {
                      Get.back();
                      await FirebaseFirestore.instance
                          .collection(collectionName.calls)
                          .doc(appCtrl.user["id"])
                          .collection(collectionName.collectionCallHistory)
                          .get()
                          .then((value) {
                        value.docs.asMap().entries.forEach((doc) {
                          doc.value.reference.delete();
                        });
                      });
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            }));
  }

  callList() async {
    int count = 0;
    FirebaseFirestore.instance
        .collection(collectionName.users)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.asMap().entries.forEach((e) {
          FirebaseFirestore.instance
              .collection(collectionName.calls)
              .doc(e.value.id)
              .collection(collectionName.collectionCallHistory)
              .get()
              .then((value) {
            count = count + value.docs.length;
            update();
          });
        });
      }
    });
  }

  Stream onSearch(val) {
    Stream<QuerySnapshot<Map<String, dynamic>>>? snapshots = FirebaseFirestore
        .instance
        .collection(collectionName.calls)
        .doc(appCtrl.user["id"])
        .collection(collectionName.collectionCallHistory)
        .where("callerName", isGreaterThanOrEqualTo: val)
        .snapshots();
    return snapshots;
  }

  onContactSearch(val) {
    log("valval : ${val != ""}");
    if (val != "") {
      final FetchContactController availableContacts =
      Provider.of<FetchContactController>(Get.context!, listen: false);
      availableContacts.registerContactUser
          .asMap()
          .entries
          .forEach((element) {

        if (element.value.name!.replaceAll(" ", "")
            .toLowerCase()
            .contains(val.toString().toLowerCase())) {
          if (searchList.isEmpty) {
            searchList = [element.value];
          } else {
            log("ELEMENT11 ${searchList.contains(element.value)}");

            if (!searchList.contains(element.value)) {
              searchList.add(element.value);
              update();
            }
          }
          update();
Get.forceAppUpdate();
        }
      });
    }else{
      log("fjxghcdfkjhg");
      searchList = [];
      update();
    }
    log("isDATSF $searchList");
  }

  //audio and video call tap
  audioVideoCallTap(isVideoCall, pData) async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(pData["id"] == appCtrl.user["id"]
            ? pData["receiverId"]
            : pData["id"])
        .get()
        .then((value) {
      if (value.exists) {
        pData["receiverName"] = value.data()!["name"];
        pData["receiverName"] = value.data()!["name"];
        pData["receiverToken"] = value.data()!["pushToken"];
      }
      update();
    });

    await audioAndVideoCallApi(toData: pData, isVideoCall: isVideoCall);
  }

  callFromList(isVideoCall, pData) async {
    await audioAndVideoCallApi(toData: pData, isVideoCall: isVideoCall);
  }

  audioAndVideoCallApi({toData, isVideoCall}) async {
    try {
      var userData = appCtrl.storage.read(session.user);

      int timestamp = DateTime.now().millisecondsSinceEpoch;

      Map<String, dynamic>? response =
          await firebaseCtrl.getAgoraTokenAndChannelName();

      log("FUNCTION ; $response");
      if (response != null) {
        String channelId = response["channelName"];
        String token = response["agoraToken"];
        Call call = Call(
            timestamp: timestamp,
            callerId: userData["id"],
            callerName: userData["name"],
            callerPic: userData["image"],
            receiverId: toData["id"],
            receiverName: toData["name"],
            receiverPic: toData["image"],
            callerToken: userData["pushToken"],
            receiverToken: toData["pushToken"],
            channelId: channelId,
            isVideoCall: isVideoCall,
            agoraToken: token,
            receiver: null);

        await FirebaseFirestore.instance
            .collection(collectionName.calls)
            .doc(call.callerId)
            .collection(collectionName.calling)
            .add({
          "timestamp": timestamp,
          "callerId": userData["id"],
          "callerName": userData["name"],
          "callerPic": userData["image"],
          "receiverId": toData["id"],
          "receiverName": toData["name"],
          "receiverPic": toData["image"],
          "callerToken": userData["pushToken"],
          "receiverToken": toData["pushToken"],
          "hasDialled": true,
          "channelId": channelId,
          "isVideoCall": isVideoCall,
          "agoraToken": token,
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection(collectionName.calls)
              .doc(call.receiverId)
              .collection(collectionName.calling)
              .add({
            "timestamp": timestamp,
            "callerId": userData["id"],
            "callerName": userData["name"],
            "callerPic": userData["image"],
            "receiverId": toData["id"],
            "receiverName": toData["name"],
            "receiverPic": toData["image"],
            "callerToken": userData["pushToken"],
            "receiverToken": toData["pushToken"],
            "hasDialled": false,
            "channelId": channelId,
            "isVideoCall": isVideoCall,
            "agoraToken": token,
          }).then((value) async {
            call.hasDialled = true;
            if (isVideoCall == false) {
              firebaseCtrl.sendNotification(
                  title: "Incoming Audio Call...",
                  msg: "${call.callerName} audio call",
                  token: call.receiverToken,
                  pName: call.callerName,
                  image: userData["image"],
                  dataTitle: call.callerName);
              var data = {
                "channelName": call.channelId,
                "call": call,
                "token": response["agoraToken"]
              };
              Get.toNamed(routeName.audioCall, arguments: data);
            } else {
              firebaseCtrl.sendNotification(
                  title: "Incoming Video Call...",
                  msg: "${call.callerName} video call",
                  token: call.receiverToken,
                  pName: call.callerName,
                  image: userData["image"],
                  dataTitle: call.callerName);

              var data = {
                "channelName": call.channelId,
                "call": call,
                "token": response["agoraToken"]
              };

              Get.toNamed(routeName.videoCall, arguments: data);
            }
          });
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to call");
      }
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      log("Failed with error '${e.code}': ${e.message}");
    }
  }
}
