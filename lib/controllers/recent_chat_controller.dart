import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import '../config.dart';
import '../models/data_model.dart';
import '../screens/bottom_screens/message/layout/broadcast_card.dart';
import '../screens/bottom_screens/message/layout/group_message_card.dart';
import '../screens/bottom_screens/message/layout/message_card.dart';
import '../screens/bottom_screens/message/layout/receiver_message_card.dart';

class RecentChatController with ChangeNotifier {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> userData = [];
  List<Widget> messageWidgetList = [];



  void updateChats(List<QueryDocumentSnapshot<Map<String, dynamic>>> newChats) {
    if (_isSameList(userData, newChats)) {
      return;
    }
    userData = newChats;
    getMessageList();
    notifyListeners();
  }

  bool _isSameList(List<QueryDocumentSnapshot<Map<String, dynamic>>> oldList, List<QueryDocumentSnapshot<Map<String, dynamic>>> newList) {
    if (oldList.length != newList.length) {
      return false;
    }
    for (int i = 0; i < oldList.length; i++) {
      if (oldList[i].id != newList[i].id || oldList[i].data() != newList[i].data()) {
        return false;
      }
    }
    return true;
  }

  DataModel? getModel(user, {isSearch = false, name}) {
    appCtrl.cachedModel ??= DataModel(user["phone"]);
    Future.delayed(DurationsClass.s1).then((value) {
      userData = appCtrl.cachedModel!.userData;
      if (isSearch) {
        getMessageList(name: name);

      } else {
        getMessageList();

      }
    });
    //notifyListeners();
    return appCtrl.cachedModel;
  }

  notify(){
    notifyListeners();
  }

  getMessageList({name}) async {
    LocalStorage storage = LocalStorage('messageModel');
    messageWidgetList = [];
    notifyListeners();

    storage.ready.then((ready) {

      if (ready) {

        notifyListeners();
        userData.asMap().entries.forEach((element) {
          if (element.value.exists) {
            var data = {
              "name": element.value["name"],
              "groupMessage": element.value["lastMessage"] == ""
                  ? ""
                  : decryptMessage(element.value["lastMessage"])
                          .contains(".gif")
                      ? "gif"
                      : element.value["lastMessage"] == ""
                          ? ""
                          : (decryptMessage(element.value["lastMessage"])
                                  .contains("media"))
                              ? "Media Share"
                              : (decryptMessage(element.value["lastMessage"])
                                          .contains(".pdf") ||
                                      decryptMessage(element.value["lastMessage"])
                                          .contains(".doc") ||
                                      decryptMessage(element.value["lastMessage"])
                                          .contains(".mp3") ||
                                      decryptMessage(element.value["lastMessage"])
                                          .contains(".mp4") ||
                                      decryptMessage(element.value["lastMessage"])
                                          .contains(".xlsx") ||
                                      decryptMessage(element.value["lastMessage"])
                                          .contains(".ods"))
                                  ? decryptMessage(element.value["lastMessage"])
                                      .split("-BREAK-")[0]
                                  : decryptMessage(
                                              element.value["lastMessage"]) ==
                                          ""
                                      ? appCtrl.user["id"] ==
                                              element.value["senderId"]
                                          ? "You Create this group ${element.value["group"]['name']}"
                                          : "${element.value["sender"]['name']} added you"
                                      : decryptMessage(
                                          element.value["lastMessage"]),
              "receiverMessage": element.value["lastMessage"] == ""
                  ? ""
                  : (decryptMessage(element.value["lastMessage"])
                          .contains("media"))
                      ? "Media Share"
                      : element.value["isBlock"] == true &&
                              element.value["isBlock"] == "true"
                          ? element.value["blockBy"] != appCtrl.user["id"]
                              ? element.value["blockUserMessage"]
                              : decryptMessage(element.value["lastMessage"])
                                  .contains("http")
                          : (decryptMessage(element.value["lastMessage"])
                                      .contains(".pdf") ||
                                  decryptMessage(element.value["lastMessage"])
                                      .contains(".doc") ||
                                  decryptMessage(element.value["lastMessage"])
                                      .contains(".mp3") ||
                                  decryptMessage(element.value["lastMessage"])
                                      .contains(".mp4") ||
                                  decryptMessage(element.value["lastMessage"])
                                      .contains(".xlsx") ||
                                  decryptMessage(element.value["lastMessage"])
                                      .contains(".ods"))
                              ? decryptMessage(element.value["lastMessage"])
                                  .split("-BREAK-")[0]
                              : decryptMessage(element.value["lastMessage"]),
              "senderMessage": element.value["lastMessage"] == null ||
                      element.value["lastMessage"] == ""
                  ? ""
                  : decryptMessage(element.value["lastMessage"])
                          .contains(".gif")
                      ? "gif"
                      : (decryptMessage(element.value["lastMessage"])
                              .contains("media"))
                          ? "You Share Media"
                          : element.value["isBlock"] == true &&
                                  element.value["isBlock"] == "true"
                              ? element.value["blockBy"] != appCtrl.user["id"]
                                  ? element.value["blockUserMessage"]
                                  : decryptMessage(element.value["lastMessage"])
                                      .contains("http")
                              : (decryptMessage(element.value["lastMessage"])
                                          .contains(".pdf") ||
                                      decryptMessage(element.value["lastMessage"])
                                          .contains(".doc") ||
                                      decryptMessage(element.value["lastMessage"])
                                          .contains(".mp3") ||
                                      decryptMessage(element.value["lastMessage"])
                                          .contains(".mp4") ||
                                      decryptMessage(
                                              element.value["lastMessage"])
                                          .contains(".xlsx") ||
                                      decryptMessage(
                                              element.value["lastMessage"])
                                          .contains(".ods"))
                                  ? decryptMessage(element.value["lastMessage"])
                                      .split("-BREAK-")[0]
                                  : decryptMessage(element.value["lastMessage"]),
              "time": DateFormat('HH:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.value['updateStamp']))),
            };

            if (name != null) {
              if (data["name"]
                  .toString()
                  .replaceAll(" ", "")
                  .toLowerCase()
                  .contains(name)) {
                if (element.value.data()["isGroup"] == false &&
                    element.value.data()["isBroadcast"] == false) {
                  if (element.value.data()["senderId"] == appCtrl.user["id"]) {
                    log("JJJJ");
                    if (!messageWidgetList.contains(ReceiverMessageCard(
                            document: element.value,
                            currentUserId: appCtrl.user["id"],
                            blockBy: appCtrl.user['id'])
                        .marginOnly(bottom: Insets.i12))) {
                      messageWidgetList.add(ReceiverMessageCard(
                              document: element.value,
                              currentUserId: appCtrl.user["id"],
                              blockBy: appCtrl.user['id'])
                          .marginOnly(bottom: Insets.i12));
                      notifyListeners();
                    }
                  } else {
                    log("qqqq");
                    if (!messageWidgetList.contains(MessageCard(
                            blockBy: appCtrl.user["id"],
                            document: element.value,
                            currentUserId: appCtrl.user["id"])
                        .marginOnly(bottom: Insets.i12))) {
                      messageWidgetList.add(MessageCard(
                              blockBy: appCtrl.user["id"],
                              document: element.value,
                              currentUserId: appCtrl.user["id"])
                          .marginOnly(bottom: Insets.i12));
                    }
                  }
                } else if (element.value.data()["isGroup"] == true) {
                  log("qqererqq");
                  if (!messageWidgetList.contains(GroupMessageCard(
                    document: element.value,
                    currentUserId: appCtrl.user["id"],
                  ).marginOnly(bottom: Insets.i12))) {
                    messageWidgetList.add(GroupMessageCard(
                      document: element.value,
                      currentUserId: appCtrl.user["id"],
                    ).marginOnly(bottom: Insets.i12));
                  }
                } else if (element.value.data()["isBroadcast"] == true) {
                  log("dsfdsfg");
                  if (!messageWidgetList.contains(
                      element.value.data()["senderId"] == appCtrl.user["id"]
                          ? BroadCastMessageCard(
                              document: element.value,
                              currentUserId: appCtrl.user["id"],
                            ).marginOnly(bottom: Insets.i12)
                          : MessageCard(
                                  document: element.value,
                                  currentUserId: appCtrl.user["id"],
                                  blockBy: appCtrl.user["id"])
                              .marginOnly(bottom: Insets.i12))) {
                    element.value.data()["senderId"] == appCtrl.user["id"]
                        ? messageWidgetList.add(BroadCastMessageCard(
                            document: element.value,
                            currentUserId: appCtrl.user["id"],
                          ).marginOnly(bottom: Insets.i12))
                        : messageWidgetList.add(MessageCard(
                                document: element.value,
                                currentUserId: appCtrl.user["id"],
                                blockBy: appCtrl.user["id"])
                            .marginOnly(bottom: Insets.i12));
                    notifyListeners();
                  }
                } else {
                  messageWidgetList.add(Container());
                }
              }
            } else {
              log("dsfdsfg");
              if (element.value.data()["isGroup"] == false &&
                  element.value.data()["isBroadcast"] == false) {
                if (element.value.data()["senderId"] == appCtrl.user["id"]) {
                  messageWidgetList.add(ReceiverMessageCard(
                          document: element.value,
                          currentUserId: appCtrl.user["id"],
                          blockBy: appCtrl.user['id'])
                      .marginOnly(bottom: Insets.i12));
                  notifyListeners();
                } else {
                  messageWidgetList.add(MessageCard(
                          blockBy: appCtrl.user["id"],
                          document: element.value,
                          currentUserId: appCtrl.user["id"])
                      .marginOnly(bottom: Insets.i12));
                  notifyListeners();
                }
              } else if (element.value.data()["isGroup"] == true) {
                messageWidgetList.add(GroupMessageCard(
                  document: element.value,
                  currentUserId: appCtrl.user["id"],
                ).marginOnly(bottom: Insets.i12));
                notifyListeners();
              } else if (element.value.data()["isBroadcast"] == true) {
                element.value.data()["senderId"] == appCtrl.user["id"]
                    ? messageWidgetList.add(BroadCastMessageCard(
                        document: element.value,
                        currentUserId: appCtrl.user["id"],
                      ).marginOnly(bottom: Insets.i12))
                    : messageWidgetList.add(MessageCard(
                            document: element.value,
                            currentUserId: appCtrl.user["id"],
                            blockBy: appCtrl.user["id"])
                        .marginOnly(bottom: Insets.i12));
                notifyListeners();
              } else {
                messageWidgetList.add(Container());
              }
              notifyListeners();
            }
            log("messageWidgetList :${messageWidgetList.length}");
          }

          notifyListeners();
        });
      }
      notifyListeners();
    });
  }

}
