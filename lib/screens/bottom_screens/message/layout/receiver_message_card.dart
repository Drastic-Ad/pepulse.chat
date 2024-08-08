import 'dart:developer';
import 'package:chatzy/screens/bottom_screens/message/layout/image_layout.dart';
import 'package:chatzy/screens/bottom_screens/message/layout/sub_title_layout.dart';
import 'package:chatzy/screens/bottom_screens/message/layout/trailing_layout.dart';
import '../../../../config.dart';

class ReceiverMessageCard extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, blockBy;

  const ReceiverMessageCard(
      {super.key, this.currentUserId, this.blockBy, this.document})
     ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatDashController>(builder: (msgCtrl) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(document!["receiverId"])
              .snapshots(),
          builder: (context, snapshot) {

            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          ImageLayout(id: ( snapshot.hasData && snapshot.data!.exists && snapshot.data!.data() != null )?snapshot.data!['id']:document!['receiverId']),
                          const HSpace(Sizes.s12),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(( snapshot.hasData && snapshot.data!.exists && snapshot.data!.data() != null )?snapshot.data!["name"]:document!['name'],
                                    style: AppCss.manropeblack14
                                        .textColor(appCtrl.appTheme.darkText)),
                                const VSpace(Sizes.s5),
                                document!["lastMessage"] != null && document!["lastMessage"] != ""
                                    ? SubTitleLayout(
                                    document: document,
                                    name:( snapshot.hasData && snapshot.data!.exists && snapshot.data!.data() != null )? snapshot.data!["name"]:document!['name'],
                                    blockBy: blockBy)
                                    : Container()
                              ])
                        ]),
                        TrailingLayout(
                            document: document, currentUserId: currentUserId)
                            .width(Sizes.s55)
                      ])
                      .width(MediaQuery.of(context).size.width)
                      .paddingOnly(
                      left: Insets.i10, bottom: Insets.i12,right: Insets.i10)
                      .inkWell(onTap: () {
                    UserContactModel userContact = UserContactModel(
                        username: snapshot.data!["name"],
                        uid: document!["receiverId"],
                        phoneNumber: snapshot.data!["phone"],
                        image: snapshot.data!["image"],
                        isRegister: true);
                    var data = {"chatId": document!["chatId"], "data": userContact};
                    log("RECEIVER M CARD $data");
                    Get.toNamed(routeName.chatLayout, arguments: data);
                    final chatCtrl = Get.isRegistered<ChatController>()
                        ? Get.find<ChatController>()
                        : Get.put(ChatController());
                    chatCtrl.onReady();
                  }),
                  Divider(height: 0,color: appCtrl.appTheme.borderColor,thickness: 1,).paddingSymmetric(horizontal: Insets.i10)
                ]
            );
          });
    });
  }
}
