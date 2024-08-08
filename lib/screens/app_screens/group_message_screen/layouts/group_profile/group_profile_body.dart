import '../../../../../config.dart';
import '../../../../../controllers/app_pages_controllers/add_participants_controller.dart';
import '../../../../../utils/snack_and_dialogs_utils.dart';
import '../../../../../widgets/common_image_layout.dart';
import '../../../../../widgets/group_media_share.dart';

class GroupProfileBody extends StatelessWidget {
  const GroupProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName.groups)
              .doc(chatCtrl.pId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.exists) {
                chatCtrl.allData = snapshot.data!.data();
                if (chatCtrl.allData != null) {
                  List user = chatCtrl.allData["users"];
                  chatCtrl.userList = user.length <= 5
                      ? user
                      : chatCtrl.allData["users"].getRange(0, 5).toList();
                }
                chatCtrl.isThere = chatCtrl.userList.any(
                        (element) => element["id"].contains(chatCtrl.user["id"]));
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: chatCtrl.groupOptionLists
                                  .asMap()
                                  .entries
                                  .where((e) => e.key != 0)
                                  .map((e) => Column(
                                children: [
                                  SizedBox(
                                      child: SvgPicture.asset(e.key == 1 ? chatCtrl.isThere  ?  e.value["icon"] : eSvgAssets.trash : e.value["icon"] ,height: Sizes.s24,width: Sizes.s24,fit: BoxFit.scaleDown,colorFilter: ColorFilter.mode(e.key == 1 || e.key == 2 ? appCtrl.appTheme.redColor : appCtrl.appTheme.darkText, BlendMode.srcIn)).paddingAll(Insets.i13)
                                  ).boxDecoration(),
                                  const VSpace(Sizes.s8),
                                  Text(e.key == 1 ? chatCtrl.isThere  ?  e.value["title"].toString().tr : appFonts.deleteGroup.tr : e.value["title"].toString().tr,style: AppCss.manropeSemiBold12.textColor(e.key == 1 || e.key == 2 ? appCtrl.appTheme.redColor : appCtrl.appTheme.darkText))
                                ]
                              ).inkWell(
                                onTap: () async{

                                  if(e.key == 1){
                                    chatCtrl.isThere
                                        ? leaveDialogs(note: "If you’ll leave “${chatCtrl.pName}“ Group, you won’t be able to send anything. Still want to leave ?",
                                    exitText: appFonts.yesLeave,
                                    title: appFonts.leaveGroup,onTap:(){
                                          FirebaseFirestore.instance
                                              .collection(collectionName.groups)
                                              .doc(chatCtrl.pId)
                                              .get()
                                              .then((value) async {
                                            if (value.exists) {
                                              List userList = value.data()!["users"];
                                              userList.removeWhere((element) =>
                                              element["id"] ==
                                                  appCtrl.user["id"]);

                                              await FirebaseFirestore.instance
                                                  .collection(collectionName.groups)
                                                  .doc(chatCtrl.pId)
                                                  .update({"users": userList}).then((value) {
                                                chatCtrl.getPeerStatus();
                                              });
                                            }
                                          });
                                          Get.back();
                                        })
                                        : chatCtrl.deleteGroup();

                                  } else if (e.key == 2) {
                                   /* await FirebaseFirestore.instance
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
                                    });*/
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
                                      Get.back();
                                      Get.back();
                                      Get.back();
                                    });
                                  } else if (e.key == 0) {
                                    if (appCtrl.contactList.isEmpty) {

                                      final groupChatCtrl = Get.isRegistered<AddParticipantsController>()
                                          ? Get.find<AddParticipantsController>()
                                          : Get.put(AddParticipantsController());


                                      groupChatCtrl.refreshContacts();
                                      var data ={
                                        "exitsUser":chatCtrl.userList,
                                        "groupId":chatCtrl.pId,
                                        "isGroup": true
                                      };

                                      Get.toNamed(routeName.addParticipants,arguments: data);
                                    } else {
                                      var data ={
                                        "exitsUser":chatCtrl.userList,
                                        "groupId":chatCtrl.pId,
                                        "isGroup": true
                                      };

                                      Get.toNamed(routeName.addParticipants,arguments: data);
                                    }
                                  }
                                  chatCtrl.update();
                                }
                              ).paddingOnly(right: Insets.i25))
                                  .toList(),
                            ).paddingSymmetric(vertical: Insets.i20),
                            Divider(height: 1,thickness: 2,color: appCtrl.appTheme.borderColor,indent: 20,endIndent: 20,),
                            const VSpace(Sizes.s20),
                          ])),
                      Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                           Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(appFonts.groupDetails.tr,
                                          textAlign: TextAlign.center,
                                          style: AppCss.manropeMedium13
                                              .textColor(
                                                  appCtrl.appTheme.greyText)),
                                      const VSpace(Sizes.s8),
                                      Text(
                                              chatCtrl.allData != null
                                                  ? chatCtrl.allData["desc"] ??
                                                      appFonts
                                                          .addGroupDescription
                                                          .tr
                                                  : appFonts
                                                      .addGroupDescription.tr,
                                              textAlign: TextAlign.center,
                                              style: AppCss.manropeMedium14
                                                  .textColor(appCtrl
                                                      .appTheme.darkText))
                                    ]
                                  ),
                            Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: appCtrl.appTheme.borderColor)
                                .paddingSymmetric(vertical: Insets.i20),
                                GroupMediaShare(chatId: chatCtrl.pId)
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
                                      "${chatCtrl.userList.length.toString()} ${appFonts.people.tr}",
                                      style: AppCss.manropeMedium14
                                          .textColor(appCtrl.appTheme.greyText))
                                ]),
                            Divider(
                                    color: appCtrl.appTheme.borderColor,
                                    thickness: 1,
                                    height: 1)
                                .paddingSymmetric(vertical: Insets.i20),
                            ...chatCtrl.userList.asMap().entries.map((e) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection(collectionName.users)
                                      .doc(e.value["id"])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data!.data() != null
                                          ? GestureDetector(
                                              onTapDown: (pos) {
                                                if (e.value["id"] !=
                                                    chatCtrl.user["id"]) {
                                                  chatCtrl.getTapPosition(pos);
                                                }
                                              },
                                              onLongPress: () {
                                                if (e.value["id"] !=
                                                    chatCtrl.user["id"]) {
                                                  chatCtrl.showContextMenu(
                                                      context,
                                                      e.value,
                                                      snapshot);
                                                }
                                              },
                                              child: Row(children: [
                                                CommonImage(
                                                    image: snapshot.data!
                                                            .data()!["image"] ??
                                                        "",
                                                    name: snapshot.data!
                                                                    .data()![
                                                                "id"] ==
                                                            chatCtrl.user["id"]
                                                        ? "Me"
                                                        : snapshot.data!
                                                            .data()!["name"],
                                                    height: Sizes.s40,
                                                    width: Sizes.s40),
                                                const HSpace(Sizes.s10),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          snapshot.data!.data()![
                                                                      "id"] ==
                                                                  (FirebaseAuth
                                                                              .instance
                                                                              .currentUser !=
                                                                          null
                                                                      ? FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid
                                                                      : chatCtrl
                                                                              .user[
                                                                          "id"])
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
                                                          snapshot.data!
                                                                  .data()![
                                                              "statusDesc"],
                                                          style: AppCss
                                                              .manropeMedium14
                                                              .textColor(appCtrl
                                                                  .appTheme
                                                                  .greyText))
                                                    ])
                                              ]).marginOnly(bottom: Insets.i15))
                                          : Container();
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
                      const VSpace(Sizes.s35)
                    ]));
          });
    });
  }
}
