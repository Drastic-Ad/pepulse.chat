/*
import 'dart:developer';

import '../../../../../config.dart';

class BroadcastSearchUser extends StatelessWidget {
  const BroadcastSearchUser({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
      List userList = Get.arguments;
      log("userList 1: $userList");
      log("userList 1: ${chatCtrl.textSearchController.text.isNotEmpty}");

      return Scaffold(
          appBar: CommonAppBar(text: fonts.searchUser.tr),
          backgroundColor: appCtrl.appTheme.bgColor,
          body: Column(
            children: [
              CommonTextBox(
                  controller: chatCtrl.textSearchController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      userList
                          .asMap()
                          .entries
                          .forEach((element) {
                        if (element.value["name"]
                            .toString()
                            .toLowerCase()
                            .contains(value)) {
                          if (!chatCtrl.searchUserList
                              .contains(element.value)) {
                            chatCtrl.searchUserList.add(element.value);
                          }
                        }
                        chatCtrl.update();
                      });
                    } else {
                      chatCtrl.searchUserList = [];
                      chatCtrl.update();
                    }
                    log("chatCtrl.searchUserList : ${chatCtrl.searchUserList}");
                  },
                  labelText: fonts.searchUser.tr,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: appCtrl.appTheme.primary))),
              const VSpace(Sizes.s20),
              chatCtrl.textSearchController.text.isNotEmpty
                  ? Column(
                children: [
                  ...chatCtrl.searchUserList
                      .asMap()
                      .entries
                      .map((user) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(collectionName.users)
                            .doc(user.value["id"])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.exists) {
                              return Row(children: [
                                CommonImage(
                                    image:
                                    snapshot.data!.data()!["image"] ??
                                        "",
                                    name: user.value["id"] ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid
                                        ? "Me"
                                        : user.value["name"],
                                    height: Sizes.s40,
                                    width: Sizes.s40),
                                const HSpace(Sizes.s10),
                                Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          user.value["id"] ==
                                              FirebaseAuth.instance
                                                  .currentUser!.uid
                                              ? "Me"
                                              : user.value["name"],
                                          style: AppCss.poppinsSemiBold14
                                              .textColor(appCtrl
                                              .appTheme.blackColor)),
                                      const VSpace(Sizes.s5),
                                      Text(
                                          snapshot.data!
                                              .data()!["statusDesc"],
                                          style: AppCss.poppinsMedium12
                                              .textColor(appCtrl
                                              .appTheme.txtColor))
                                    ])
                              ]).marginOnly(bottom: Insets.i15).inkWell(onTap: (){
                                var data = {
                                  "uid": user.value["id"],
                                  "username": user.value["name"],
                                  "phoneNumber": user.value["phone"],
                                  "image": snapshot.data!.data()!["image"],
                                  "description": snapshot.data!
                                      .data()!["statusDesc"],
                                  "isRegister": true,
                                };
                                UserContactModel userContactModel = UserContactModel
                                    .fromJson(data);
                                chatCtrl.saveContact(userContactModel);
                              });
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        });
                  }).toList()
                ],
              )
                  : Column(
                children: [
                  ...userList
                      .asMap()
                      .entries
                      .map((user) {
                    log("IDSS: ${user.value}");
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(collectionName.users)
                            .doc(user.value["id"])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.exists) {
                              return Row(children: [
                                CommonImage(
                                    image:
                                    snapshot.data!.data()!["image"] ??
                                        "",
                                    name: user.value["id"] ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid
                                        ? "Me"
                                        : user.value["name"],
                                    height: Sizes.s40,
                                    width: Sizes.s40),
                                const HSpace(Sizes.s10),
                                Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          user.value["id"] ==
                                              FirebaseAuth.instance
                                                  .currentUser!.uid
                                              ? "Me"
                                              : user.value["name"],
                                          style: AppCss.poppinsSemiBold14
                                              .textColor(appCtrl
                                              .appTheme.blackColor)),
                                      const VSpace(Sizes.s5),
                                      Text(
                                          snapshot.data!
                                              .data()!["statusDesc"],
                                          style: AppCss.poppinsMedium12
                                              .textColor(appCtrl
                                              .appTheme.txtColor))
                                    ])
                              ]).marginOnly(bottom: Insets.i15).inkWell(
                                  onTap: () {
                                    var data = {
                                      "uid": user.value["id"],
                                      "username": user.value["name"],
                                      "phoneNumber": user.value["phone"],
                                      "image": snapshot.data!.data()!["image"],
                                      "description": snapshot.data!
                                          .data()!["statusDesc"],
                                      "isRegister": true,
                                    };
                                    UserContactModel userContactModel = UserContactModel
                                        .fromJson(data);
                                    chatCtrl.saveContact(userContactModel);
                                  });
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        });
                  }).toList()
                ],
              )
            ],
          ).marginSymmetric(horizontal: Insets.i20));
    });
  }
}
*/
