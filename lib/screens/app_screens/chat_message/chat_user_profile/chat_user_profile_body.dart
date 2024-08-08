import 'package:intl/intl.dart';
import '../../../../../config.dart';
import 'chat_user_images.dart';

class ChatUserProfileBody extends StatelessWidget {
  const ChatUserProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {

      return Container(
          decoration: ShapeDecoration(
              color: appCtrl.appTheme.screenBG,
              shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: 20, cornerSmoothing: 1))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10),
                decoration: ShapeDecoration(
                    color: appCtrl.appTheme.screenBG,
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 20, cornerSmoothing: 1))),
                child: Column(children: [
                  Text(chatCtrl.pData["name"],
                      style: AppCss.manropeSemiBold16
                          .textColor(appCtrl.appTheme.darkText)),
                  const VSpace(Sizes.s10),
                  Text(chatCtrl.pData["phone"],
                      style: AppCss.manropeSemiBold16
                          .textColor(appCtrl.appTheme.darkText)),
                  const VSpace(Sizes.s10),
                  Text(
                      chatCtrl.userData["status"] == "Offline"
                          ? DateFormat('HH:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(chatCtrl.userData['lastSeen'])))
                          : chatCtrl.userData["status"],
                      textAlign: TextAlign.center,
                      style: AppCss.manropeMedium14
                          .textColor(appCtrl.appTheme.greyText)),
                  const VSpace(Sizes.s20)
                ])),
            Text(
              chatCtrl.userData["statusDesc"],
              textAlign: TextAlign.center,
              style:
                  AppCss.manropeMedium14.textColor(appCtrl.appTheme.darkText),
            )
                .width(MediaQuery.of(context).size.width)
                .paddingAll(Insets.i20)
                .decorated(
                    color: appCtrl.appTheme.greyText,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppRadius.r20),
                        bottomRight: Radius.circular(AppRadius.r20))),
            const VSpace(Sizes.s5),
            ChatUserImagesVideos(chatId: chatCtrl.chatId),
            const VSpace(Sizes.s5),

            const VSpace(Sizes.s35)
          ]));
    });
  }
}
