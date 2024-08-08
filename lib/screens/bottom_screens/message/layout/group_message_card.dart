
import 'dart:developer';

import '../../../../config.dart';
import 'group_message_card_layout.dart';

class GroupMessageCard extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId;

  const GroupMessageCard({super.key, this.document, this.currentUserId})
     ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionName.groups)
            .doc(document!["groupId"])
            .snapshots(),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(document!["senderId"])
                  .snapshots(),
              builder: (context, userSnapShot) {
                return GroupMessageCardLayout(
                    snapshot: snapshot,
                    document: document,
                    currentUserId: currentUserId,
                    userSnapShot: userSnapShot)
                    .inkWell(onTap: () {
                  var data = {
                    "message": document!.data(),
                    "groupData": snapshot.data!.data()
                  };
                  Get.toNamed(routeName.groupChatMessage,
                      arguments: data);
                });
              })
              .width(MediaQuery.of(context).size.width)
              .paddingSymmetric(horizontal: Insets.i10, vertical: Insets.i4);
        });
  }
}
