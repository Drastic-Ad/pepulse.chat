import 'dart:developer';

import '../../../../config.dart';

class DeleteAlert extends StatelessWidget {
  final DocumentSnapshot? documentReference;

  const DeleteAlert({super.key, this.documentReference});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      return AlertDialog(
        backgroundColor: appCtrl.appTheme.screenBG,
        title:  Text(appFonts.alert.tr),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  <Widget>[
              Text(appFonts.areYouSureToDelete.tr)
            ]),
        actions: <Widget>[
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
          TextButton(
            onPressed: () async {
              dynamic  userData = appCtrl.storage.read(session.user);
              Get.back();
              chatCtrl.selectedIndexId.asMap().entries.forEach((element)async {
                log("ONNN : ${element.value}");
                await FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(appCtrl.user["id"])
                    .collection(collectionName.messages)
                    .doc(chatCtrl.chatId)
                    .collection(collectionName.chat)
                    .doc(element.value)
                    .delete();
              });
              await FirebaseFirestore.instance
                  .runTransaction((transaction) async {});
              chatCtrl.listScrollController.animateTo(0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);

              await FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(appCtrl.user["id"])
                  .collection(collectionName.messages)
                  .doc(chatCtrl.chatId)
                  .collection(collectionName.chat)
                  .orderBy("timestamp", descending: true)
                  .limit(1)
                  .get()
                  .then((value) {
                if (value.docs.isEmpty) {
                  FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(userData["id"])
                      .collection(collectionName.chats)
                      .where("chatId", isEqualTo: chatCtrl.chatId)
                      .get()
                      .then((value) {
                    FirebaseFirestore.instance
                        .collection(collectionName.users)
                        .doc(userData["id"]).collection(collectionName.chats).doc(value.docs[0].id)
                        .delete();
                  });
                } else {
                  FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(userData["id"])
                      .collection(collectionName.chats)
                      .where("chatId", isEqualTo: chatCtrl.chatId)
                      .get()
                      .then((snapShot) {
                    if (snapShot.docs.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(snapShot.docs[0].id)
                          .update({
                        "updateStamp":
                        DateTime.now().millisecondsSinceEpoch.toString(),
                        "lastMessage": value.docs[0].data()["content"],
                        "senderId": value.docs[0].data()["senderId"],
                        'sender': {
                          "id": value.docs[0].data()["sender"]['id'],
                          "name": value.docs[0].data()["sender"]['name'],
                          "image": value.docs[0].data()["sender"]["image"]
                        },
                        "receiverId": value.docs[0].data()["receiverId"],
                        "receiver": {
                          "id": value.docs[0].data()["receiver"]["id"],
                          "name": value.docs[0].data()["receiver"]["name"],
                          "image": value.docs[0].data()["receiver"]["image"]
                        }
                      });
                    }
                  });
                }
              });
              chatCtrl.selectedIndexId = [];
              chatCtrl.showPopUp =false;
              chatCtrl.enableReactionPopup =false;
              chatCtrl.update();
            },
            child: const Text('Yes'),
          ),
        ],
      );
    });
  }
}
