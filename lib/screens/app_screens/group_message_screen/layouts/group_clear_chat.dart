import '../../../../config.dart';

class GroupClearDialog extends StatelessWidget {
  const GroupClearDialog({super.key});

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
                      height: Sizes.s160,
                      margin: const EdgeInsets.symmetric(
                          horizontal: Insets.i10, vertical: Insets.i15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: Insets.i15, vertical: Insets.i15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              appFonts.clearChatId.tr,
                              style: AppCss.manropeblack16
                                  .textColor(appCtrl.appTheme.darkText)
                          ),
                          const VSpace(Sizes.s12),
                          Text(
                            appFonts.deleteOptions.tr,
                            style: AppCss.manropeMedium16
                                .textColor(appCtrl.appTheme.darkText),
                          ),
                          const VSpace(Sizes.s20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: ButtonCommon(
                                    title: appFonts.cancel.tr,
                                    onTap: () => Get.back(),
                                    style: AppCss.manropeMedium14
                                        .textColor(appCtrl.appTheme.white),
                                  )),
                              const HSpace(Sizes.s10),
                              Expanded(
                                  child: ButtonCommon(
                                      onTap: () async {
                                        Get.back();

                                        await FirebaseFirestore.instance
                                            .collection(collectionName.users)
                                            .doc(appCtrl.user["id"])
                                            .collection(collectionName.groupMessage)
                                            .doc(chatCtrl.pId)
                                            .collection(collectionName.chat)
                                            .get()
                                            .then((value) async {
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
                                                  .update({"lastMessage": ""});
                                            }

                                          });

                                          chatCtrl.localMessage = [];
                                          chatCtrl.update();

                                        });
                                      },
                                      title: appFonts.clearChat.tr,
                                      style: AppCss.manropeMedium14
                                          .textColor(appCtrl.appTheme.white))),
                            ],
                          )
                        ],
                      )).decorated(color: appCtrl.appTheme.white,borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r8))).paddingAll(Insets.i20));
            });
          }),
    );
  }
}
