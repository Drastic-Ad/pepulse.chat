

import '../../../../config.dart';

class BroadCastDeleteAlert extends StatelessWidget {
  final DocumentSnapshot? documentReference;

  const BroadCastDeleteAlert({super.key, this.documentReference});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
      return AlertDialog(
        backgroundColor: appCtrl.appTheme.white,
        title: Text(appFonts.alert.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(appFonts.areYouSureToDelete.tr),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(appFonts.close.tr),
          ),
          TextButton(
            onPressed: () async {
              Get.back();

              await FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(appCtrl.user["id"])
                  .collection(collectionName.broadcastMessage)
                  .doc(chatCtrl.pId)
                  .collection(collectionName.chat)
                  .get()
                  .then((value) {
                if (value.docs.isNotEmpty) {
                  value.docs
                      .asMap()
                      .entries
                      .forEach((element) async {

                    await FirebaseFirestore.instance
                        .collection(collectionName.users)
                        .doc(appCtrl.user["id"])
                        .collection(
                        collectionName.broadcastMessage)
                        .doc(chatCtrl.pId)
                        .collection(collectionName.chat)
                        .doc(element.value.id)
                        .delete();
                  });
                }
              }).then((value) async {
                await FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(appCtrl.user["id"])
                    .collection(collectionName.chats)
                    .where("broadcastId",
                    isEqualTo: chatCtrl.pId)
                    .get()
                    .then((userGroup) {
                  if (userGroup.docs.isNotEmpty) {
                    FirebaseFirestore.instance
                        .collection(collectionName.users)
                        .doc(appCtrl.user["id"])
                        .collection(collectionName.chats)
                        .doc(userGroup.docs[0].id)
                        .update({
                      "lastMessage": "",
                      "senderId": appCtrl.user["id"]
                    });
                  }
                  chatCtrl.update();

                });

                chatCtrl.localMessage = [];
                chatCtrl.update();

              });

            },
            child: Text(appFonts.yes.tr),
          ),
        ],
      );
    });
  }
}
