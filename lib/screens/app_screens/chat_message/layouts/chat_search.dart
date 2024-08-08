import '../../../../config.dart';

class ChatSearch extends StatelessWidget {
  const ChatSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (chatCtrl) {
        return TextField(
          controller: chatCtrl.txtChatSearch,
          onChanged: (val) async {
            chatCtrl.count = null;
            chatCtrl.searchChatId = [];
            chatCtrl.selectedIndexId = [];
            chatCtrl.message.asMap().entries.forEach((e) {
              if (decryptMessage(e.value.data()["content"])
                  .toLowerCase()
                  .contains(val)) {
                if (!chatCtrl.searchChatId.contains(e.key)) {
                  chatCtrl.searchChatId.add(e.key);
                } else {
                  chatCtrl.searchChatId.remove(e.key);
                }
              }
              chatCtrl.update();
            });
          },
          autofocus: true,
          //Display the keyboard when TextField is displayed
          cursorColor: appCtrl.appTheme.primary,
          style: AppCss.manropeSemiBold14.textColor(appCtrl.appTheme.darkText),
          textInputAction: TextInputAction.search,
          //Specify the action button on the keyboard
          decoration: InputDecoration(
            //Style of TextField
            enabledBorder: UnderlineInputBorder(
              //Default TextField border
                borderSide: BorderSide(color: appCtrl.appTheme.borderColor)),
            focusedBorder: UnderlineInputBorder(
              //Borders when a TextField is in focus
                borderSide: BorderSide(color: appCtrl.appTheme.borderColor)),
            hintText: 'Search', //Text that is displayed when nothing is entered.
          ),
        );
      }
    );
  }
}
