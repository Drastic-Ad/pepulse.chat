/*
import 'dart:developer';

import '../../../../config.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ClearDialog extends StatelessWidget {
  const ClearDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
          return Align(
              alignment: Alignment.center,
              child: Container(
                  height: Sizes.s170,
                  color: appCtrl.appTheme.white,
                  margin: const EdgeInsets.symmetric(
                      horizontal: Insets.i30, vertical: Insets.i15),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Insets.i20, vertical: Insets.i22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fonts.clearChatId.tr,
                        style: AppCss.manropeblack20
                            .textColor(appCtrl.appTheme.darkText),
                      ),
                      const VSpace(Sizes.s12),
                      Text(
                        fonts.deleteOption.tr,
                        style: AppCss.manropeMedium14
                            .textColor(appCtrl.appTheme.greyText),
                      ),
                      const VSpace(Sizes.s20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: CommonButton(
                            title: fonts.cancel.tr,
                            margin: 0,
                            onTap: () => Get.back(),
                            style: AppCss.poppinsMedium14
                                .textColor(appCtrl.appTheme.white),
                          )),
                          const HSpace(Sizes.s10),
                          Expanded(
                              child: CommonButton(
                                margin: 0,
                                  onTap: () async {
                                    Get.back();

                                    await FirebaseFirestore.instance
                                        .collection(collectionName.users)
                                        .doc(appCtrl.user["id"])
                                        .collection(collectionName.groupMessage)
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
                                                  collectionName.groupMessage)
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
                                          .collection(collectionName.groupMessage)
                                          .doc(chatCtrl.pId)
                                          .collection(collectionName.chat)
                                          .get()
                                          .then((value) async {
                                        if (value.docs.isEmpty) {
                                          List userList = chatCtrl.pData["groupData"]["users"];
                                          final key = encrypt.Key.fromUtf8('my 32 length key................');
                                          final iv = encrypt.IV.fromLength(16);

                                          final encrypter = encrypt.Encrypter(encrypt.AES(key));

                                          final encrypted =
                                              encrypter.encrypt(fonts.noteEncrypt.tr, iv: iv).base64;
                                          await FirebaseFirestore.instance
                                              .collection(collectionName.users)
                                              .doc(appCtrl.user["id"])
                                              .collection(collectionName.groupMessage)
                                              .doc(chatCtrl.pId)
                                              .collection(collectionName.chat)
                                              .where("type", isEqualTo: MessageType.note.name)
                                              .limit(1)
                                              .get()
                                              .then((noteMessage) async {
                                            if (noteMessage.docs.isEmpty) {
                                              await FirebaseFirestore.instance
                                                  .collection(collectionName.users)
                                                  .doc(appCtrl.user["id"])
                                                  .collection(collectionName.groupMessage)
                                                  .doc(chatCtrl.pId)
                                                  .collection(collectionName.chat)
                                                  .doc(DateTime.now().millisecondsSinceEpoch.toString())
                                                  .set({
                                                'sender': appCtrl.user["id"],
                                                'senderName': appCtrl.user["name"],
                                                'receiver': chatCtrl.pData["groupData"]["users"],
                                                'content': encrypted,
                                                "groupId":chatCtrl.pId,
                                                'type': MessageType.note.name,
                                                'messageType': "sender",
                                                "status": "",
                                                'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                                              });
                                            }
                                          });
                                        }
                                      });
                                      await FirebaseFirestore.instance
                                          .collection(collectionName.users)
                                          .doc(appCtrl.user["id"])
                                          .collection(collectionName.chats)
                                          .where("groupId",
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
                                    });
                                  },
                                  title: fonts.clearChat.tr,
                                  style: AppCss.poppinsMedium14
                                      .textColor(appCtrl.appTheme.white))),
                        ],
                      )
                    ],
                  )));
        });
      }),
    );
  }
}
*/
