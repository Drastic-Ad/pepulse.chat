import '../../../../config.dart';

class ChatFirebaseApi{

  //unblock
  unblockFunction(value,chatId,pId)async{
    var user = appCtrl.storage.read(session.user);
    DateTime now = DateTime.now();
    String? newChatId = chatId == "0"
        ? now.microsecondsSinceEpoch.toString()
        : chatId;
    chatId = newChatId;
  await  FirebaseFirestore.instance
        .collection('messages')
        .doc(newChatId)
        .collection("chat")
        .add({
      'sender': user["id"],
      'receiver': pId,
      'content': "You Unblock this contact",
      "chatId": newChatId,
      'type': MessageType.messageType.name,
      'messageType': "sender",
      'timestamp': DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
    });

    await FirebaseFirestore.instance
        .collection("contacts")
        .where("chatId", isEqualTo: newChatId)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('contacts')
            .doc(value.docs[0].id)
            .update({
          "isBlock": false,
          "blockBy": "",
          "blockUserId": ""
        });
      }
    });
  }
}