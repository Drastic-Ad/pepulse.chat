import 'dart:developer';
import 'package:fast_contacts/fast_contacts.dart';

import '../../../config.dart';

class MessageFirebaseApi {
  String? currentUserId;
  final messageCtrl = Get.isRegistered<ChatDashController>()? Get.find<ChatDashController>():Get.put(ChatDashController());


  //get contact list
  getContactList(List<Contact> contacts) async {
    List message = [];
    final data = appCtrl.storage.read(session.user);
    currentUserId = data["id"];
    var statusesSnapshot =
        await FirebaseFirestore.instance.collection(collectionName.users).get();
    for (int i = 0; i < statusesSnapshot.docs.length; i++) {
      for (int j = 0; j < contacts.length; j++) {
        if (contacts[j].phones.isNotEmpty) {
          String phone =
              phoneNumberExtension(contacts[j].phones[0].number.toString());

          if (phone == statusesSnapshot.docs[i]["phone"]) {
            var messageSnapshot = await FirebaseFirestore.instance
                .collection('contacts')
                .orderBy("updateStamp", descending: true)
                .get();
            for (int a = 0; a < messageSnapshot.docs.length; a++) {
              if (messageSnapshot.docs[a].data()["isGroup"] == false) {
                if (messageSnapshot.docs[a].data()["senderId"] ==
                        currentUserId ||
                    messageSnapshot.docs[a].data()["receiverId"] ==
                            statusesSnapshot.docs[i]["id"] &&
                        messageSnapshot.docs[a].data()["senderId"] ==
                            statusesSnapshot.docs[i]["id"] ||
                    messageSnapshot.docs[a].data()["receiverId"] ==
                        currentUserId) {
                  message.add(messageSnapshot.docs[a]);
                }
              } else {
                if (messageSnapshot.docs[a].data()["senderId"] ==
                    currentUserId) {
                  message.add(messageSnapshot.docs[a]);
                } else {
                  List groupReceiver =
                      messageSnapshot.docs[a].data()["receiverId"];
                  if (groupReceiver
                      .where((element) => element["id"] == currentUserId)
                      .isNotEmpty) {
                    message.add(messageSnapshot.docs[a]);
                  }
                }
              }
            }
            return message;
          }
        }
      }
    }
    return message;
  }

  //check contact in firebase and if not exists
  saveContact(UserContactModel userModel, {message}) async {
    bool isRegister = false;
log("SUCCESS}");

    await FirebaseFirestore.instance.collection(collectionName.users).where("phone",isEqualTo: userModel.phoneNumber).limit(1).get().then((value) {
      if(value.docs.isNotEmpty){
        isRegister = true;
        userModel.uid = value.docs[0].id;
      }else{
        isRegister = false;
      }
    });


    final data = appCtrl.storage.read(session.user);
    currentUserId = data["id"];

    UserContactModel userContact = userModel;
    if (isRegister) {
      log("val: ${userContact.uid}");
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(currentUserId)
          .collection("chats")
          .where("isOneToOne", isEqualTo: true)
          .get()
          .then((value) {

        bool isEmpty = value.docs
            .where((element) =>
                element.data()["senderId"] == userContact.uid ||
                element.data()["receiverId"] == userContact.uid)
            .isNotEmpty;
        if (!isEmpty) {
          var data = {"chatId": "0", "data": userContact,"message":message};

          Get.back();
          Get.toNamed(routeName.chatLayout, arguments: data);
        } else {
          value.docs.asMap().entries.forEach((element) { 
            if(element.value.data()["senderId"]  == userContact.uid ||
                element.value.data()["receiverId"] == userContact.uid){
              var data = {"chatId": element.value.data()["chatId"], "data": userContact,"message":message};
              Get.back();
              Get.toNamed(routeName.chatLayout,arguments: data);
            }
          });
        }
      });
    } else {
      String? encodeQueryParameters(Map<String, String> params) {
        return params.entries
            .map((e) =>
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
      }

      Uri smsUri = Uri(
        scheme: 'sms',
        path: '${userModel.phoneNumber}',
        query: encodeQueryParameters(
            <String, String>{'body': "Hello, let's chat with Pepulse. Download the app from google play store"}),
      );

      try {
        await launchUrl(smsUri);
      } catch (e) {
        throw "Can't phone that number.";
      }
    }
  }

  //chat list

  List chatListWidget(
  AsyncSnapshot<dynamic> snapshot) {
    List message = [];
    for (int a = 0; a < snapshot.data!.docs.length; a++) {
      message.add(snapshot.data!.docs[a]);
    }
    return message;
  }
}
