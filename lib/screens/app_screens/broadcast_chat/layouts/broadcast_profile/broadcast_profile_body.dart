import '../../../../../config.dart';
import '../../../../../controllers/app_pages_controllers/add_participants_controller.dart';
import '../../../../../utils/snack_and_dialogs_utils.dart';
import '../../../../../widgets/broadcast_media_share.dart';
import '../../../../../widgets/common_image_layout.dart';

class BroadcastProfileBody extends StatelessWidget {
  const BroadcastProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
      return StreamBuilder(
          stream:  FirebaseFirestore.instance
              .collection(collectionName.broadcast)
              .doc(chatCtrl.pId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.exists) {
                chatCtrl.broadData = snapshot.data!.data();
                chatCtrl.userList = chatCtrl.pData.isNotEmpty
                    ? chatCtrl.pData.length < 5
                    ? chatCtrl.pData
                    : chatCtrl.pData.getRange(0, 5).toList()
                    : [];
                chatCtrl.isThere = chatCtrl.userList.any((element) =>
                    element["id"].contains(chatCtrl.userData["id"]));
              }
            }
            return Container(
                color: appCtrl.appTheme.screenBG,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: ShapeDecoration(
                              color: appCtrl.appTheme.screenBG,
                              shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: 20, cornerSmoothing: 1))),
                          child: Column(children: [

                            /* AudioVideoButtonLayout(
                              isGroup: true,
                              callTap: () async {
                                await chatCtrl.permissionHandelCtrl
                                    .getCameraMicrophonePermissions()
                                    .then((value) {
                                  if (value == true) {
                                    // chatCtrl.audioVideoCallTap(false);
                                  }
                                });
                              },
                              videoTap: () async {
                                await chatCtrl.permissionHandelCtrl
                                    .getCameraMicrophonePermissions()
                                    .then((value) {
                                  if (value == true) {
                                    //chatCtrl.audioVideoCallTap(true);
                                  }
                                });
                              },
                              addTap: () async {
                                log("ADD PARTICIPATE : ${appCtrl.contactList.length}");
                                if (appCtrl.contactList.isEmpty) {
                                  final groupChatCtrl = Get.isRegistered<
                                          AddParticipantsController>()
                                      ? Get.find<AddParticipantsController>()
                                      : Get.put(AddParticipantsController());

                                  groupChatCtrl.refreshContacts();
                                  var data = {
                                    "exitsUser": chatCtrl.userList,
                                    "groupId": chatCtrl.pId
                                  };
                                  log("arg : $data");
                                  Get.toNamed(routeName.addParticipants,
                                      arguments: data);
                                } else {
                                  final groupChatCtrl = Get.isRegistered<
                                          AddParticipantsController>()
                                      ? Get.find<AddParticipantsController>()
                                      : Get.put(AddParticipantsController());
                                  if (groupChatCtrl.contactList.isEmpty) {
                                    groupChatCtrl.getFirebaseContact();
                                  }
                                  var data = {
                                    "exitsUser": chatCtrl.userList,
                                    "groupId": chatCtrl.pId
                                  };
                                  log("arg : $data");
                                  Get.toNamed(routeName.addParticipants,
                                      arguments: data);
                                }
                              },
                            ),*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: chatCtrl.broadcastOptionsList
                                  .asMap()
                                  .entries
                                  .map((e) => Column(
                                  children: [
                                    SizedBox(
                                        child: SvgPicture.asset(e.value["icon"],height: Sizes.s24,width: Sizes.s24,fit: BoxFit.scaleDown,colorFilter: ColorFilter.mode(e.key == 1 ? appCtrl.appTheme.redColor : appCtrl.appTheme.darkText , BlendMode.srcIn),).paddingAll(Insets.i13)
                                    ).boxDecoration(),
                                    const VSpace(Sizes.s8),
                                    Text(e.value["title"],style: AppCss.manropeSemiBold12.textColor(e.key == 1 ? appCtrl.appTheme.redColor : appCtrl.appTheme.darkText ))
                                  ]
                              ).inkWell(
                                  onTap: () {
                                    if(e.key == 1) {
                                      leaveDialogs(note: "If you’ll delete “${chatCtrl.pName}“ broadcast, you won’t be able to send anything. Still want to delete ?",
                                          exitText: appFonts.yesDelete,
                                          title: appFonts.deleteBroadcast,onTap:()=> chatCtrl.deleteBroadCast() );
                                    } else {
                                      if (appCtrl.contactList.isEmpty) {
                                        final groupChatCtrl = Get.isRegistered<AddParticipantsController>()
                                            ? Get.find<AddParticipantsController>()
                                            : Get.put(AddParticipantsController());
                                        groupChatCtrl.refreshContacts();
                                        var data ={
                                          "exitsUser":chatCtrl.userList,
                                          "groupId":chatCtrl.pId,
                                          "isGroup": false
                                        };
                                        Get.toNamed(routeName.addParticipants,arguments: data);
                                      } else {
                                        var data = {
                                          "exitsUser":chatCtrl.userList,
                                          "groupId":chatCtrl.pId,
                                          "isGroup": false
                                        };
                                        Get.toNamed(routeName.addParticipants,arguments: data);
                                      }
                                    }
                                  }
                              ).paddingOnly(right: Insets.i25))
                                  .toList()
                            ).paddingSymmetric(vertical: Insets.i20),
                            Divider(height: 1,thickness: 2,color: appCtrl.appTheme.borderColor,indent: 20,endIndent: 20,),
                            const VSpace(Sizes.s20),
                          ])),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                                height: 1,
                                thickness: 1,
                                color: appCtrl.appTheme.borderColor)
                                .paddingSymmetric(vertical: Insets.i20),
                            BroadcastMediaShare(chatId: chatCtrl.pId)
                            /*Text(
                                "${appFonts.createdBy.tr} ${chatCtrl.allData["createdBy"]["name"]}, ${DateFormat("dd/MM/yyy").format(DateTime.fromMillisecondsSinceEpoch(int.parse(chatCtrl.allData['timestamp'])))}",
                                textAlign: TextAlign.center,
                                style: AppCss.manropeMedium12
                                    .textColor(appCtrl.appTheme.greyText)),*/
                          ])
                          .paddingSymmetric(horizontal: Insets.i20)
                          .width(MediaQuery.of(context).size.width),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(appFonts.totalPeople.tr,
                                      style: AppCss.manropeSemiBold14.textColor(
                                          appCtrl.appTheme.darkText)),
                                  Text(
                                      "${chatCtrl.pData.length.toString()} ${appFonts.people.tr}",
                                      style: AppCss.manropeMedium14
                                          .textColor(appCtrl.appTheme.greyText))
                                ]),
                            Divider(
                                color: appCtrl.appTheme.borderColor,
                                thickness: 1,
                                height: 1)
                                .paddingSymmetric(vertical: Insets.i20),
                            ...chatCtrl.pData.asMap().entries.map((e) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection(collectionName.users)
                                      .doc(e.value["id"])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return GestureDetector(
                                        onTapDown: (pos) {
                                          if (e.value["id"] !=
                                              chatCtrl.userData["id"]) {
                                            chatCtrl.getTapPosition(pos);
                                          }
                                        },
                                        onLongPress: () {
                                          if (e.value["id"] !=
                                              chatCtrl.userData["id"]) {
                                            chatCtrl.showContextMenu(
                                                context, e.value,
                                                snapshot);
                                          } else {

                                            /*Get.toNamed(routeName.editProfile,
                                                arguments: {"resultData": chatCtrl.userData, "isPhoneLogin": false});*/
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            CommonImage(
                                                image: snapshot.data!
                                                    .data()!["image"],
                                                name: snapshot.data!
                                                    .data()!["id"] ==
                                                    (FirebaseAuth.instance
                                                        .currentUser != null ?        FirebaseAuth.instance
                                                        .currentUser!.uid : chatCtrl.userData["id"])
                                                    ? "Me"
                                                    : snapshot.data!
                                                    .data()!["name"],
                                                height: Sizes.s40,
                                                width: Sizes.s40),
                                            const HSpace(Sizes.s10),
                                            Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      snapshot.data!.data()![
                                                      "id"] ==
                                                          (FirebaseAuth.instance
                                                              .currentUser != null ?        FirebaseAuth.instance
                                                              .currentUser!.uid : chatCtrl.userData["id"])
                                                          ? "Me"
                                                          : snapshot.data!
                                                          .data()![
                                                      "name"],
                                                      style: AppCss
                                                          .manropeSemiBold14
                                                          .textColor(appCtrl
                                                          .appTheme
                                                          .darkText)),
                                                  const VSpace(Sizes.s5),
                                                  Text(
                                                      snapshot.data!.data()![
                                                      "statusDesc"],
                                                      style: AppCss
                                                          .manropeMedium14
                                                          .textColor(appCtrl
                                                          .appTheme
                                                          .greyText)),
                                                ])
                                          ],
                                        ).marginOnly(bottom: Insets.i15),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  });
                            })
                          ])
                          .paddingSymmetric(
                          vertical: Insets.i20, horizontal: Insets.i15)
                          .boxDecoration()
                          .paddingSymmetric(horizontal: Insets.i20),
                      /* BlockReportLayout(
                          icon: eSvgAssets.exit,
                          name: chatCtrl.isThere
                              ? appFonts.exitGroup.tr
                              : appFonts.deleteGroup.tr,
                          onTap: () => chatCtrl.isThere
                              ? chatCtrl.exitGroupDialog()
                              : chatCtrl.deleteGroup()),
                      BlockReportLayout(
                          icon: eSvgAssets.dislike,
                          name: appFonts.reportGroup.tr,
                          onTap: () async {
                            accessDenied(
                                "Are you sure you want to report ${chatCtrl.pName} group?. Once you report this group you will be remove from this group without notify anyone",
                                onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection(collectionName.groups)
                                  .doc(chatCtrl.pId)
                                  .get()
                                  .then((value) {
                                if (value.exists) {
                                  List users = value.data()!["users"];
                                  users.removeWhere((element) =>
                                      element["id"] == chatCtrl.user["id"]);
                                  FirebaseFirestore.instance
                                      .collection(collectionName.groups)
                                      .doc(chatCtrl.pId)
                                      .update({"users": users}).then(
                                          (value) async {
                                    await FirebaseFirestore.instance
                                        .collection(collectionName.users)
                                        .doc(chatCtrl.user["id"])
                                        .collection(collectionName.chats)
                                        .where("groupId",
                                            isEqualTo: chatCtrl.pId)
                                        .limit(1)
                                        .get()
                                        .then((userChat) {
                                      if (userChat.docs.isNotEmpty) {
                                        FirebaseFirestore.instance
                                            .collection(collectionName.users)
                                            .doc(chatCtrl.user["id"])
                                            .collection(collectionName.chats)
                                            .doc(userChat.docs[0].id)
                                            .delete();
                                      }
                                    });
                                  });
                                }
                              });
                              await FirebaseFirestore.instance
                                  .collection(collectionName.report)
                                  .add({
                                "reportFrom": chatCtrl.user["id"],
                                "reportTo": chatCtrl.pId,
                                "isSingleChat": false,
                                "timestamp":
                                    DateTime.now().millisecondsSinceEpoch
                              }).then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(appFonts.reportSend.tr),
                                  backgroundColor: appCtrl.appTheme.online,
                                ));
                              });
                            });
                          }),*/
                      const VSpace(Sizes.s35)
                    ]));
          });
    });
  }
}
