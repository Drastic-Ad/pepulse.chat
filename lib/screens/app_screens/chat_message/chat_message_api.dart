
import 'dart:developer' as log;
import 'package:chatzy/models/call_model.dart';
import 'package:intl/intl.dart';
import '../../../config.dart';

class ChatMessageApi {
  Future saveMessage(newChatId, pId, encrypted,MessageType type,dateTime,senderId,
      {isBlock = false,
      isSeen = false,
      isBroadcast = false,
      blockBy = "",
      blockUserId = "" }) async {
    log.log("SAVE");
    dynamic userData = appCtrl.storage.read(session.user);
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(senderId)
        .collection(collectionName.messages)
        .doc(newChatId)
        .collection(collectionName.chat)
        .doc(dateTime)
        .set({
      'sender': userData["id"],
      'receiver': pId,
      'content': encrypted,
      "chatId": newChatId,
      'type': type.name,
      'messageType': "sender",
      "isBlock": isBlock,
      "isSeen": isSeen,
      "isBroadcast": isBroadcast,
      "blockBy": blockBy,
      "blockUserId": blockUserId,
      'timestamp': dateTime,
    }, SetOptions(merge: true));
  }

  //save message in user
  saveMessageInUserCollection(
      id, receiverId, newChatId, content, senderId, userName, MessageType type,
      {isBlock = false, isBroadcast = false}) async {
    final chatCtrl = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController());
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(id)
        .collection(collectionName.chats)
        .where("chatId", isEqualTo: newChatId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id)
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": content,
          "senderId": senderId,
          "messageType": type.name,
          "chatId": newChatId,
          "isSeen": false,
          "isGroup": false,
          "name": userName,
          "isBlock": isBlock ?? false,
          "isOneToOne": true,
          "isBroadcast": isBroadcast,
          "blockBy": isBlock ? id : "",
          "blockUserId": isBlock ? receiverId : "",
          "receiverId": receiverId,
          "type": type.name
        }).then((value) {
          chatCtrl.textEditingController.text = "";
          chatCtrl.update();
        });
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id)
            .collection(collectionName.chats)
            .add({
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": content,
          "senderId": senderId,
          "isSeen": false,
          "isGroup": false,
          "chatId": newChatId,
          "isBlock": isBlock ?? false,
          "isOneToOne": true,
          "name": userName,
          "isBroadcast": isBroadcast,
          "blockBy": isBlock ? id : "",
          "blockUserId": isBlock ? receiverId : "",
          "receiverId": receiverId,
          "type": type.name
        }).then((value) {
          chatCtrl.textEditingController.text = "";
          chatCtrl.update();
        });
      }
    }).then((value) {
      chatCtrl.isLoading = false;
      chatCtrl.update();
      Get.forceAppUpdate();
    });
  }

  //save group data
  saveGroupData(
    id,
    groupId,
    content,
    pData,
      type,groupImage
  ) async {
    var user = appCtrl.storage.read(session.user);
    List receiver = pData["groupData"]["users"];
    receiver.asMap().entries.forEach((element) async {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(element.value["id"])
          .collection(collectionName.chats)
          .where("groupId", isEqualTo: groupId)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(element.value["id"])
              .collection(collectionName.chats)
              .doc(value.docs[0].id)
              .update({
            "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "lastMessage": content,
            "senderId": user["id"],
            "name": pData["groupData"]["name"],
            "groupImage": groupImage
          });
          if (user["id"] != element.value["id"]) {
            FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(element.value["id"])
                .get()
                .then((snap) {
              if (snap.data()!["pushToken"] != "") {
                firebaseCtrl.sendNotification(
                    title: "Group Message",
                    msg: groupMessageTypeCondition(type,content),
                    groupId: groupId,
                    token: snap.data()!["pushToken"],
                    dataTitle: pData["groupData"]["name"]);
              }
            });
          }
        }
      });
    });
  }

  //audio and video call api
  audioAndVideoCallApi({toData, isVideoCall}) async {
    try {

      var userData = appCtrl.storage.read(session.user);
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(toData['id'])
          .get()
          .then((value) {
            log.log("TODAT :%${value.data()}");
        toData = value.data();

      });
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      Map<String, dynamic>? response = await firebaseCtrl.getAgoraTokenAndChannelName();

      log.log("response :$userData");
      log.log("response :$toData");
      if(response != null){
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
          "channelId": response['channelName'],
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
            "channelId": response['channelName'],
            "isVideoCall": isVideoCall,
            "agoraToken": token,
          }).then((value) async {
            Get.back();
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
              log.log("call.channelId : ${call.channelId}");
              var data = {
                "channelName": call.channelId,
                "call": call,
                "token": response["agoraToken"]
              };

              Get.toNamed(routeName.videoCall, arguments: data);
            }
          });
        });
      }else{
        Fluttertoast.showToast(msg: "Failed to call");
      }

    /*  Call call = Call(
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
          isGroup: false,
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
        "channelId": "flutterTheme",
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
              "token": "007eJxTYEh70D/fPHShsHdd3hkF1pBPgVzl3BFcfafKjvy45n7/x1EFhjSz5MQk42RDE0OjFBPDFHOLtLS05ETLJCODFGNDEyMT91LG1IZARgYdCx9WRgYIBPF5GNJySktKUotCMlJzUxkYACbNIXo="
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
            log.log("call.channelId : ${call.channelId}");
            var data = {
              "channelName": call.channelId,
              "call": call,
              "token": "007eJxTYEh70D/fPHShsHdd3hkF1pBPgVzl3BFcfafKjvy45n7/x1EFhjSz5MQk42RDE0OjFBPDFHOLtLS05ETLJCODFGNDEyMT91LG1IZARgYdCx9WRgYIBPF5GNJySktKUotCMlJzUxkYACbNIXo="
            };

            Get.toNamed(routeName.videoCall, arguments: data);
          }
        });
      });*/
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      log.log("Failed with error '${e.code}': ${e.message}");
    }
  }


  getMessageAsPerDate(snapshot){
    final chatCtrl = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController());
    List<QueryDocumentSnapshot<Object?>> message =
        (snapshot.data!).docs;
    List reveredList = message.reversed.toList();
    List<QueryDocumentSnapshot<Object?>> todayMessage = [];
    List<QueryDocumentSnapshot<Object?>> yesterdayMessage = [];
    List<QueryDocumentSnapshot<Object?>> newMessageList = [];
    reveredList.asMap().entries.forEach((element) {
      if (getDate(element.value.id) == "Today") {

        bool isExist = chatCtrl.message
            .where((element) => element["title"].toString().contains("Today"))
            .isNotEmpty;
        if (isExist) {
          if(!todayMessage.contains(element.value)) {
            todayMessage.add(element.value);
            int index = chatCtrl.message.indexWhere(
                    (element) =>
                element["title"].toString().contains("Today"));
            chatCtrl.message[index]["message"] =
                todayMessage;
          }
        } else {
          if(!todayMessage.contains(element.value)) {
            todayMessage.add(element.value);
            var data = {
              "title": getDate(element.value.id),
              "message": todayMessage
            };

            chatCtrl.message = [data];
          }

        }
      }
      if (getDate(element.value.id) == "Yesterday") {
        bool isExist = chatCtrl.message
            .where((element) => element["title"] == "Yesterday")
            .isNotEmpty;

        if (isExist) {
          if(!yesterdayMessage.contains(element.value)) {
            yesterdayMessage.add(element.value);
            int index = chatCtrl.message.indexWhere(
                    (element) =>
                element["title"] == "Yesterday");
            chatCtrl.message[index]["message"] =
                yesterdayMessage;
          }
        } else {
          if(!yesterdayMessage.contains(element.value)) {
            yesterdayMessage.add(element.value);
            var data = {
              "title": "${getDate(element.value.id)} ${DateFormat("hh:mm aa").format(DateTime.parse(DateTime.fromMillisecondsSinceEpoch(int.parse(element.value.id)).toString()))}",
              "message": yesterdayMessage
            };

            if(chatCtrl.message.isNotEmpty){
              chatCtrl.message.add(data);
            }else {
              chatCtrl.message = [data];
            }
          }
        }
      }
      if(getDate(element.value.id) != "Yesterday" && getDate(element.value.id) != "Today"){

        bool isExist = chatCtrl.message
            .where((element) => element["title"].contains("-other"))
            .isNotEmpty;

        if (isExist) {
          if(!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            int index = chatCtrl.message.indexWhere(
                    (element) =>
                    element["title"].contains("-other"));
            chatCtrl.message[index]["message"] =
                newMessageList;
          }
        } else {
          if(!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            var data = {
              "title": getDate(element.value.id),
              "message": newMessageList
            };

            if(chatCtrl.message.isNotEmpty){
              chatCtrl.message.add(data);
            }else {
              chatCtrl.message = [data];
            }
          }
        }

      }
    });

  }




  getLocalMessage() {
    final chatCtrl = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController());
    List<QueryDocumentSnapshot<Object?>> message = chatCtrl.allMessages;
    List reveredList = message.reversed.toList();
    chatCtrl.localMessage = [];


    reveredList.asMap().entries.forEach((element) {
      log.log("getDate(element.value.id) ; %${getDate(element.value.id)}");
      MessageModel messageModel = MessageModel(
          blockBy: element.value.data()["blockBy"],
          blockUserId: element.value.data()["blockUserId"],
          chatId: element.value.data()["chatId"],
          content: element.value.data()["content"],
          docId: element.value.id,
          emoji: element.value.data()["emoji"],
          favouriteId: element.value.data()["favouriteId"],
          isBlock: element.value.data()["isBlock"],
          isBroadcast: element.value.data()["isBroadcast"],
          isFavourite: element.value.data()["isFavourite"],
          isSeen: element.value.data()["isSeen"],
          messageType: element.value.data()["messageType"],
          receiver: element.value.data()["receiver"],
          sender: element.value.data()["sender"],
          timestamp: element.value.data()["timestamp"],
          type: element.value.data()["type"]);
      if (getDate(element.value.id) == "Today") {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time == "Today")
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip =
          DateTimeChip(time: getDate(element.value.id), message: message);
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage
              .indexWhere((element) => element.time == "Today");

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }

      if (getDate(element.value.id) == "Yesterday") {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time == "Yesterday")
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip =
          DateTimeChip(time: getDate(element.value.id), message: message);
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage
              .indexWhere((element) => element.time == "Yesterday");

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }

      if (getDate(element.value.id).contains("-other")) {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time!.contains("-other"))
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip =
          DateTimeChip(time: getDate(element.value.id), message: message);
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage
              .indexWhere((element) => element.time!.contains("-other"));

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }
    });

    chatCtrl.update();
  }

  getLocalGroupMessage() {
    final chatCtrl = Get.isRegistered<GroupChatMessageController>()
        ? Get.find<GroupChatMessageController>()
        : Get.put(GroupChatMessageController());
    List<QueryDocumentSnapshot<Object?>> message = chatCtrl.allMessages;
    List reveredList = message.reversed.toList();
    chatCtrl.localMessage = [];

    reveredList.asMap().entries.forEach((element) {
      MessageModel messageModel = MessageModel(
          blockBy: element.value.data()["blockBy"],
          blockUserId: element.value.data()["blockUserId"],
          chatId: element.value.data()["chatId"],
          content: element.value.data()["content"],
          docId: element.value.id,
          groupId: element.value.data()["groupId"],
          emoji: element.value.data()["emoji"],
          favouriteId: element.value.data()["favouriteId"],
          isBlock: element.value.data()["isBlock"],
          isBroadcast: element.value.data()["isBroadcast"],
          isFavourite: element.value.data()["isFavourite"],
          isSeen: element.value.data()["isSeen"],
          messageType: element.value.data()["messageType"],
          receiverList: element.value.data()["receiver"],
          senderName: element.value.data()["senderName"],
          sender: element.value.data()["sender"],
          timestamp: element.value.data()["timestamp"],
          type: element.value.data()["type"]);
      if (getDate(element.value.id) == "Today") {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time == "Today")
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip =
          DateTimeChip(time: getDate(element.value.id), message: message);
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage
              .indexWhere((element) => element.time == "Today");

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }

      if (getDate(element.value.id) == "Yesterday") {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time == "Yesterday")
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip =
          DateTimeChip(time: getDate(element.value.id), message: message);
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage
              .indexWhere((element) => element.time == "Yesterday");

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }
      if (getDate(element.value.id).contains("-other")) {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time!.contains("-other"))
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip =
          DateTimeChip(time: getDate(element.value.id), message: message);
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage
              .indexWhere((element) => element.time!.contains("-other"));

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }
    });

    chatCtrl.update();
  }

  getLocalBroadcastMessage() {
    final chatCtrl = Get.isRegistered<BroadcastChatController>()
        ? Get.find<BroadcastChatController>()
        : Get.put(BroadcastChatController());
    List<QueryDocumentSnapshot<Object?>> message = chatCtrl.allMessages;
    List reveredList = message.reversed.toList();
    chatCtrl.localMessage = [];

    reveredList.asMap().entries.forEach((element) {
      MessageModel messageModel = MessageModel(
          blockBy: "",
          blockUserId: "",
          broadcastId: element.value.data()["broadcastId"],
          content: element.value.data()["content"],
          docId: element.value.id,
          emoji: element.value.data()["emoji"],
          favouriteId: element.value.data()["favouriteId"],
          isBlock: element.value.data()["isBlock"],
          isBroadcast: element.value.data()["isBroadcast"],
          isFavourite: element.value.data()["isFavourite"],
          isSeen: element.value.data()["isSeen"],
          messageType: element.value.data()["messageType"],
          receiverList: element.value.data()["receiverId"],
          sender: element.value.data()["sender"],
          timestamp: element.value.data()["timestamp"],
          type: element.value.data()["type"]);
      if (getDate(element.value.id) == "Today") {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time == "Today")
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip =
          DateTimeChip(time: getDate(element.value.id), message: message);
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage
              .indexWhere((element) => element.time == "Today");

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }

      if (getDate(element.value.id) == "Yesterday") {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time == "Yesterday")
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip =
          DateTimeChip(time: getDate(element.value.id), message: message);
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage
              .indexWhere((element) => element.time == "Yesterday");

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }
      if (getDate(element.value.id).contains("-other")) {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time!.contains("-other"))
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip =
          DateTimeChip(time: getDate(element.value.id), message: message);
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage
              .indexWhere((element) => element.time!.contains("-other"));

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }
    });

    chatCtrl.update();
  }

}
