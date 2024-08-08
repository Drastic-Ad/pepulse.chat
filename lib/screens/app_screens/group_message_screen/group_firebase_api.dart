import 'dart:developer';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';

import '../../../config.dart';

class GroupFirebaseApi {
  late encrypt.Encrypter cryptor;
  final iv = encrypt.IV.fromLength(8);

  //create group
  createGroup(GroupMessageController groupCtrl) async {
    Map<String, dynamic>? arg;
    groupCtrl.dismissKeyboard();
    groupCtrl.isLoading = true;
    groupCtrl.update();
    final user = appCtrl.storage.read(session.user);
    groupCtrl.update();
    var userData = {
      "id": user["id"],
      "name": user["name"],
      "phone": user["phone"],
      "image": user["image"]
    };
    groupCtrl.selectedContact.add(userData);
    groupCtrl.imageFile = groupCtrl.pickerCtrl.imageFile;
    if (groupCtrl.imageFile != null) {
      await groupCtrl.uploadFile();
    }
    groupCtrl.update();
    final now = DateTime.now();
    String id = now.microsecondsSinceEpoch.toString();

    await Future.delayed(DurationsClass.s3);

    await FirebaseFirestore.instance
        .collection(collectionName.groups)
        .doc(id)
        .set({
      "name": groupCtrl.txtGroupName.text,
      "image": groupCtrl.imageUrl,
      "users": groupCtrl.selectedContact,
      "groupId": id,
      "status": "",
      "createdBy": user,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });

    Encrypted encrypteded = encryptFun(
        "Welcome");
    String encrypted = encrypteded.base64;

    Encrypted encrypteded1 = encryptFun(
        "Welcome");
    String encrypted1 = encrypteded1.base64;

    groupCtrl.selectedContact.asMap().entries.forEach((e) async {
      FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(e.value["id"])
          .collection(collectionName.groupMessage)
          .doc(id)
          .collection(collectionName.chat)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'sender': user["id"],
        'senderName': user["name"],
        'receiver': groupCtrl.selectedContact,
        'content': appCtrl.user['id'] == e.value['id'] ?encrypted:encrypted1,
        "groupId": id,
        'type': MessageType.messageType.name,
        'messageType': "sender",
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });
    await FirebaseFirestore.instance
        .collection(collectionName.groups)
        .doc(id)
        .get()
        .then((value) async {
      groupCtrl.selectedContact.map((e) {
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(e["id"])
            .collection(collectionName.chats)
            .add({
          "isSeen": false,
          'receiverId': groupCtrl.selectedContact,
          "senderId": user["id"],
          'chatId': "",
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": appCtrl.user['id'] == e['id'] ? encrypted : encrypted1,
          "messageType": MessageType.messageType.name,
          "isGroup": true,
          "isBlock": false,
          "isBroadcast": false,
          "isBroadcastSender": false,
          "isOneToOne": false,
          "blockBy": "",
          "blockUserId": "",
          "name": groupCtrl.txtGroupName.text,
          "groupId": id,
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString()
        });
      }).toList();
      groupCtrl.selectedContact = [];
      groupCtrl.txtGroupName.text = "";
      groupCtrl.isLoading = false;
      groupCtrl.imageUrl = "";
      groupCtrl.image = null;
      groupCtrl.imageFile = null;
      groupCtrl.update();
      arg = value.data();
    });
    log("back");
    dynamic messageData;
    log("back : $arg");
    Get.back();
    Get.back();
    groupCtrl.imageUrl = "";
    groupCtrl.imageFile = null;
    groupCtrl.image = null;
    FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userData["id"])
        .collection(collectionName.chats)
        .where("groupId", isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        messageData = value.docs[0].data();
      }
    }).then((value) {
      groupCtrl.isLoading = false;
      groupCtrl.update();
      var data = {"message": messageData, "groupData": arg};
      Get.toNamed(routeName.groupChatMessage, arguments: data);
    });
  }



  /*Future<void> ExistGroupWithName(GroupMessageController groupCtrl, String groupName, String groupType, String groupLevel) async {
    groupCtrl.dismissKeyboard();
    groupCtrl.isLoading = true;
    groupCtrl.update();

    final user = appCtrl.storage.read(session.user);

    var userData = {
      "id": user["id"],
      "name": user["name"],
      "phone": user["phone"],
      "image": user["image"]
    };

    Set<Map<String, dynamic>> uniqueContacts = {userData};
    groupCtrl.selectedContact = uniqueContacts.toList();

    groupCtrl.imageFile = groupCtrl.pickerCtrl.imageFile;
    if (groupCtrl.imageFile != null) {
      await groupCtrl.uploadFile();
    }

    groupCtrl.update();

    // Check if the group already exists
    var groupQuery = await FirebaseFirestore.instance
        .collection(collectionName.groups)
        .where('name', isEqualTo: groupName)
        .where('type', isEqualTo: groupType)
        .where('level', isEqualTo: groupLevel)
        .get();

    if (groupQuery.docs.isNotEmpty) {
      // Group exists, add user to the group
      var groupId = groupQuery.docs.first.id;

      await FirebaseFirestore.instance
          .collection(collectionName.groups)
          .doc(groupId)
          .update({
        "users": FieldValue.arrayUnion([userData])
      });

      Encrypted encrypteded = encryptFun("Welcome");
      String encrypted = encrypteded.base64;

      await FirebaseFirestore.instance.collection(collectionName.users).doc(user["id"]).collection(collectionName.groupMessage).doc(groupId).collection(collectionName.chat).add({
        'sender': user["id"],
        'senderName': user["name"],
        'receiver': groupCtrl.selectedContact,
        'content': encrypted,
        "groupId": groupId,
        'type': MessageType.messageType.name,
        'messageType': "sender",
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      groupCtrl.selectedContact.clear();
      groupCtrl.txtGroupName.text = "";
      groupCtrl.isLoading = false;
      groupCtrl.imageUrl = "";
      groupCtrl.image = null;
      groupCtrl.imageFile = null;
      groupCtrl.update();

      Get.back();
      Get.back();
    } else {
      // Group does not exist, create a new group
      final now = DateTime.now();
      String id = now.microsecondsSinceEpoch.toString();

      await FirebaseFirestore.instance.collection(collectionName.groups).doc(id).set({
        "name": groupName,
        "type": groupType,
        "level": groupLevel,
        "image": groupCtrl.imageUrl,
        "users": groupCtrl.selectedContact,
        "groupId": id,
        "status": "",
        "createdBy": user,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      Encrypted encrypteded = encryptFun("Welcome");
      String encrypted = encrypteded.base64;

      for (var e in groupCtrl.selectedContact) {
        await FirebaseFirestore.instance.collection(collectionName.users).doc(e["id"]).collection(collectionName.groupMessage).doc(id).collection(collectionName.chat).add({
          'sender': user["id"],
          'senderName': user["name"],
          'receiver': groupCtrl.selectedContact,
          'content': encrypted,
          "groupId": id,
          'type': MessageType.messageType.name,
          'messageType': "sender",
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      }

      await FirebaseFirestore.instance.collection(collectionName.groups).doc(id).get().then((value) async {
        for (var e in groupCtrl.selectedContact) {
          await FirebaseFirestore.instance.collection(collectionName.users).doc(e["id"]).collection(collectionName.chats).add({
            "isSeen": false,
            'receiverId': groupCtrl.selectedContact,
            "senderId": user["id"],
            'chatId': "",
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            "lastMessage": encrypted,
            "messageType": MessageType.messageType.name,
            "isGroup": true,
            "isBlock": false,
            "isBroadcast": false,
            "isBroadcastSender": false,
            "isOneToOne": false,
            "blockBy": "",
            "blockUserId": "",
            "name": groupName,
            "groupId": id,
            "updateStamp": DateTime.now().millisecondsSinceEpoch.toString()
          });
        }
        groupCtrl.selectedContact.clear();
        groupCtrl.txtGroupName.text = "";
        groupCtrl.isLoading = false;
        groupCtrl.imageUrl = "";
        groupCtrl.image = null;
        groupCtrl.imageFile = null;
        groupCtrl.update();
        Get.back();
        Get.back();
      });
    }
  }*/

  Future<void> createGroupWithName(GroupMessageController groupCtrl, String groupName, String groupType, String groupLevel) async {
    Map<String, dynamic>? arg;
    groupCtrl.dismissKeyboard();
    groupCtrl.isLoading = true;
    groupCtrl.update();
    final user = appCtrl.storage.read(session.user);
    groupCtrl.update();

    var userData = {
      "id": user["id"],
      "name": user["name"],
      "phone": user["phone"],
      "image": user["image"]
    };

    // Use a set to ensure uniqueness
    Set<Map<String, dynamic>> uniqueContacts = {userData};

    groupCtrl.selectedContact = uniqueContacts.toList();

    groupCtrl.imageFile = groupCtrl.pickerCtrl.imageFile;
    if (groupCtrl.imageFile != null) {
      await groupCtrl.uploadFile();
    }
    groupCtrl.update();

    final now = DateTime.now();
    String id = now.microsecondsSinceEpoch.toString();

    await Future.delayed(DurationsClass.s3);

    await FirebaseFirestore.instance.collection(collectionName.groups).doc(id).set({
      "name": groupName,
      "type": groupType,
      "level": groupLevel,
      "image": groupCtrl.imageUrl,
      "users": groupCtrl.selectedContact,
      "groupId": id,
      "status": "",
      "createdBy": user,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });

    Encrypted encrypteded = encryptFun("Welcome");
    String encrypted = encrypteded.base64;

    for (var e in groupCtrl.selectedContact) {
      await FirebaseFirestore.instance.collection(collectionName.users).doc(e["id"]).collection(collectionName.groupMessage).doc(id).collection(collectionName.chat).doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
        'sender': user["id"],
        'senderName': user["name"],
        'receiver': groupCtrl.selectedContact,
        'content': encrypted,
        "groupId": id,
        'type': MessageType.messageType.name,
        'messageType': "sender",
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }

    await FirebaseFirestore.instance.collection(collectionName.groups).doc(id).get().then((value) async {
      for (var e in groupCtrl.selectedContact) {
        await FirebaseFirestore.instance.collection(collectionName.users).doc(e["id"]).collection(collectionName.chats).add({
          "isSeen": false,
          'receiverId': groupCtrl.selectedContact,
          "senderId": user["id"],
          'chatId': "",
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": encrypted,
          "messageType": MessageType.messageType.name,
          "isGroup": true,
          "isBlock": false,
          "isBroadcast": false,
          "isBroadcastSender": false,
          "isOneToOne": false,
          "blockBy": "",
          "blockUserId": "",
          "name": groupName,
          "groupId": id,
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString()
        });
      }
      groupCtrl.selectedContact.clear();
      groupCtrl.txtGroupName.text = "";
      groupCtrl.isLoading = false;
      groupCtrl.imageUrl = "";
      groupCtrl.image = null;
      groupCtrl.imageFile = null;
      groupCtrl.update();
      arg = value.data();
    });

    dynamic messageData;
    Get.back();
    Get.back();
    groupCtrl.imageUrl = "";
    groupCtrl.imageFile = null;
    groupCtrl.image = null;
    FirebaseFirestore.instance.collection(collectionName.users).doc(userData["id"]).collection(collectionName.chats).where("groupId", isEqualTo: id).get().then((value) {
      if (value.docs.isNotEmpty) {
        messageData = value.docs[0].data();
      }
    }).then((value) {
      groupCtrl.isLoading = false;
      groupCtrl.update();
      var data = {"message": messageData, "groupData": arg};
      // Navigate back to the same page (profile_setup_controller)
      Get.back();
      Get.back();
    });
  }

  Future<void> ExistGroupWithName(GroupMessageController groupCtrl, String groupName, String groupType, String groupLevel,String groupId) async {
    Map<String, dynamic>? arg;
    groupCtrl.dismissKeyboard();
    groupCtrl.isLoading = true;
    groupCtrl.update();
    final user = appCtrl.storage.read(session.user);
    groupCtrl.update();

    var userData = {
      "id": user["id"],
      "name": user["name"],
      "phone": user["phone"],
      "image": user["image"]
    };

    // Use a set to ensure uniqueness
    Set<Map<String, dynamic>> uniqueContacts = {userData};

    groupCtrl.selectedContact = uniqueContacts.toList();

    groupCtrl.imageFile = groupCtrl.pickerCtrl.imageFile;
    if (groupCtrl.imageFile != null) {
      await groupCtrl.uploadFile();
    }
    groupCtrl.update();

    final now = DateTime.now();
   // String id = now.microsecondsSinceEpoch.toString();

    await Future.delayed(DurationsClass.s3);

  /*  await FirebaseFirestore.instance.collection(collectionName.groups).doc(id).set({
      "name": groupName,
      "type": groupType,
      "level": groupLevel,
      "image": groupCtrl.imageUrl,
      "users": groupCtrl.selectedContact,
      "groupId": id,
      "status": "",
      "createdBy": user,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });*/

    Encrypted encrypteded = encryptFun("Welcome");
    String encrypted = encrypteded.base64;

    for (var e in groupCtrl.selectedContact) {
      await FirebaseFirestore.instance.collection(collectionName.users).doc(e["id"]).collection(collectionName.groupMessage).doc(groupId).collection(collectionName.chat).doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
        'sender': user["id"],
        'senderName': user["name"],
        'receiver': groupCtrl.selectedContact,
        'content': encrypted,
        "groupId": groupId,
        'type': MessageType.messageType.name,
        'messageType': "sender",
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }

    await FirebaseFirestore.instance.collection(collectionName.groups).doc(groupId).get().then((value) async {
      for (var e in groupCtrl.selectedContact) {
        await FirebaseFirestore.instance.collection(collectionName.users).doc(e["id"]).collection(collectionName.chats).add({
          "isSeen": false,
          'receiverId': groupCtrl.selectedContact,
          "senderId": user["id"],
          'chatId': "",
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": encrypted,
          "messageType": MessageType.messageType.name,
          "isGroup": true,
          "isBlock": false,
          "isBroadcast": false,
          "isBroadcastSender": false,
          "isOneToOne": false,
          "blockBy": "",
          "blockUserId": "",
          "name": groupName,
          "groupId": groupId,
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString()
        });
      }
      groupCtrl.selectedContact.clear();
      groupCtrl.txtGroupName.text = "";
      groupCtrl.isLoading = false;
      groupCtrl.imageUrl = "";
      groupCtrl.image = null;
      groupCtrl.imageFile = null;
      groupCtrl.update();
      arg = value.data();
    });

    dynamic messageData;
    Get.back();
    Get.back();
    groupCtrl.imageUrl = "";
    groupCtrl.imageFile = null;
    groupCtrl.image = null;
    FirebaseFirestore.instance.collection(collectionName.users).doc(userData["id"]).collection(collectionName.chats).where("groupId", isEqualTo: groupId).get().then((value) {
      if (value.docs.isNotEmpty) {
        messageData = value.docs[0].data();
      }
    }).then((value) {
      groupCtrl.isLoading = false;
      groupCtrl.update();
      var data = {"message": messageData, "groupData": arg};
      // Navigate back to the same page (profile_setup_controller)
      Get.back();
      Get.back();
    });
  }

}
