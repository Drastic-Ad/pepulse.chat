import 'dart:developer';
import 'package:chatzy/screens/bottom_screens/message/layout/trailing_layout.dart';
import '../../../../config.dart';
import 'image_layout.dart';

class MessageCard extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, blockBy;

  const MessageCard({super.key, this.document, this.currentUserId, this.blockBy})
     ;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(document!["senderId"])
            .snapshots(),
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      ImageLayout(id: document!["senderId"]),
                      const HSpace(Sizes.s12),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text (( snapshot.hasData && snapshot.data!.exists && snapshot.data!.data() != null )?   snapshot.data!.data()!["name"] : document!['name'],
                                style: AppCss.manropeblack14
                                    .textColor(appCtrl.appTheme.darkText)),
                            const VSpace(Sizes.s6),

                          ])
                    ]),
                    TrailingLayout(
                        currentUserId: currentUserId, document: document).width(Sizes.s55)
                  ])
                  .width(MediaQuery.of(context).size.width)
                  .paddingOnly(left: Insets.i10,right: Insets.i10, bottom: Insets.i12)
                  .inkWell(onTap: () {
                UserContactModel userContact = UserContactModel(
                    username:( snapshot.hasData && snapshot.data!.exists && snapshot.data!.data() != null ) ?   snapshot.data!.data()!["name"] :document!["name"],
                    uid: document!["senderId"],
                    phoneNumber:( snapshot.hasData && snapshot.data!.exists && snapshot.data!.data() != null ) ? snapshot.data!["phone"]:"",
                    image:snapshot.data!.data() != null ?  snapshot.data!["image"] :"",
                    isRegister: true);

                var data = {"chatId": document!["chatId"], "data": userContact};
                log("SENDER MESSAGE CARD: $data");
                Get.toNamed(routeName.chatLayout, arguments: data);
                final chatCtrl = Get.isRegistered<ChatController>()
                    ? Get.find<ChatController>()
                    : Get.put(ChatController());
                chatCtrl.onReady();
              }),
              Divider(height: 1,color: appCtrl.appTheme.borderColor,thickness: 1).marginSymmetric(horizontal: Insets.i10)
            ],
          );
        });
  }
}
