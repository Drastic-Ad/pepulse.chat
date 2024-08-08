
import 'package:chatzy/screens/bottom_screens/message/layout/receiver_message_card.dart';

import '../../../../config.dart';
import 'broadcast_card.dart';
import 'group_message_card.dart';
import 'message_card.dart';

class LoadUser extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, blockBy;

  const LoadUser({super.key, this.document, this.currentUserId, this.blockBy})
     ;

  @override
  Widget build(BuildContext context) {

    if (document!["isGroup"] == false && document!["isBroadcast"] == false ) {
      if (document!["senderId"] == currentUserId ) {
        return   ReceiverMessageCard(
            document: document, currentUserId: currentUserId, blockBy: blockBy).marginOnly(bottom: Insets.i12);
      } else {
        return MessageCard(
          blockBy: blockBy,
          document: document,
          currentUserId: currentUserId
        ).marginOnly(bottom: Insets.i12);
      }
    } else if (document!["isGroup"] == true) {
      List user = document!["receiverId"];
      return user
              .where((element) => element["id"] == currentUserId)
              .isNotEmpty
          ? GroupMessageCard(
              document: document,
              currentUserId: currentUserId,
            ).marginOnly(bottom: Insets.i12)
          : Container();
    } else if (document!["isBroadcast"] == true ) {

      return document!["senderId"] == currentUserId
          ? BroadCastMessageCard(
              document: document,
              currentUserId: currentUserId,
            ).marginOnly(bottom: Insets.i12)
          :  MessageCard(
          document: document, currentUserId: currentUserId, blockBy: blockBy).marginOnly(bottom: Insets.i12);
    } else{
      return Container();
    }
  }
}
