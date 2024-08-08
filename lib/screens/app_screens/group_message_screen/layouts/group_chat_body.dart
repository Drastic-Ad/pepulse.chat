import '../../../../config.dart';
import 'group_input_box.dart';
import 'group_message_box.dart';

class GroupChatBody extends StatelessWidget {
  const GroupChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return chatCtrl.backgroundImage != null &&
              chatCtrl.backgroundImage != ""
          ? Column(children: <Widget>[
              // List of messages
              const GroupMessageBox(),
              // Sticker
              Container(),
              // Input content
              const GroupInputBox(),
        if (chatCtrl.isShowSticker)
          chatCtrl.showBottomSheet()
            ])
          .chatBgExtension(chatCtrl.selectedWallpaper)
              .inkWell(onTap: () {
              chatCtrl.enableReactionPopup = false;
              chatCtrl.showPopUp = false;
              chatCtrl.update();
            })
          : Column(children: <Widget>[
              // List of messages
              const GroupMessageBox(),

                  Container(),              // Input content
              const GroupInputBox(),
        if (chatCtrl.isShowSticker)
          chatCtrl.showBottomSheet()
            ]).chatBgExtension(chatCtrl.selectedWallpaper).inkWell(onTap: () {
              chatCtrl.enableReactionPopup = false;
              chatCtrl.showPopUp = false;
              chatCtrl.isChatSearch = false;
              chatCtrl.update();

            });
    });
  }
}
