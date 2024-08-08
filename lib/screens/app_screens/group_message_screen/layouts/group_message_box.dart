import '../../../../config.dart';
import '../../../../widgets/common_note_encrypt.dart';

class GroupMessageBox extends StatelessWidget {
  const GroupMessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return Flexible(
              child: chatCtrl.pId == null
                      ? Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  appCtrl.appTheme.primary)))
                      :ListView(
                controller: chatCtrl.listScrollController,
                reverse: true,
                children: [

                  ...chatCtrl.localMessage.asMap().entries.map((e) => chatCtrl
                      .timeLayout(
                    e.value,
                  ).marginOnly(bottom: Insets.i18)),
                  Container(
                      margin: const EdgeInsets.only(bottom: 2.0),
                      padding: const EdgeInsets.only(
                          left: Insets.i10, right: Insets.i10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.center,
                            child: CommonNoteEncrypt(),
                          ).paddingOnly(bottom: Insets.i8)
                        ],
                      )),
                ],
              ) );
    });
  }
}
