import '../../../../config.dart';
import 'broadcast_box.dart';
import 'broadcast_message.dart';

class BroadcastBody extends StatelessWidget {
  const BroadcastBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(
      builder: (chatCtrl) {
        return Column(children: <Widget>[
          // List of messages
          const BroadcastMessage(),
          // Sticker
          Container(),
          // Input content
          const BroadcastInputBox(),
          if (chatCtrl.isShowSticker)
            chatCtrl.showBottomSheet()
        ]);
      }
    );
  }
}
