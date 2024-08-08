import 'package:intl/intl.dart';
import '../../../../config.dart';

import '../../../bottom_screens/message/message_firebase_api.dart';
import 'contact_list_tile.dart';

class ContactLayout extends StatelessWidget {
  final MessageModel? document;
  final VoidCallback? onLongPress, onTap;
final String? userId;
  final bool isReceiver, isBroadcast;

  const ContactLayout(
      {super.key,
      this.document,
      this.onLongPress,
      this.onTap,
      this.userId,
      this.isReceiver = false,
      this.isBroadcast = false})
     ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        InkWell(
            onLongPress: onLongPress,
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    decoration: ShapeDecoration(
                        color: isReceiver
                            ? appCtrl.appTheme.primary.withOpacity(0.5)
                            : appCtrl.appTheme.primary,
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius.only(
                                topLeft: const SmoothRadius(
                                    cornerRadius: 20, cornerSmoothing: 1),
                                topRight: const SmoothRadius(
                                    cornerRadius: 20, cornerSmoothing: 1),
                                bottomLeft: SmoothRadius(
                                    cornerRadius: isReceiver ? 0 : 20,
                                    cornerSmoothing: 1),
                                bottomRight: SmoothRadius(
                                    cornerRadius: isReceiver ? 20 : 0,
                                    cornerSmoothing: 1)))),
                    width: Sizes.s250,
                    height: Sizes.s110,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ContactListTile(
                                        document: document, isReceiver: isReceiver)
                                    .marginOnly(top: Insets.i5)
                              ]),
                          const VSpace(Sizes.s8),
                          Divider(
                              thickness: 1.5,
                              color: isReceiver
                                  ? appCtrl.appTheme.sameWhite
                                  : appCtrl.appTheme.sameWhite,
                              height: 1),
                          InkWell(
                              onTap: () {
                                UserContactModel user = UserContactModel(
                                    uid: "0",
                                    isRegister: false,
                                    image: decryptMessage(document!.content).split('-BREAK-')[2],
                                    username:
                                        decryptMessage(document!.content).split('-BREAK-')[0],
                                    phoneNumber: phoneNumberExtension(
                                        decryptMessage(document!.content).split('-BREAK-')[1]),
                                    description: "");
                                MessageFirebaseApi().saveContact(user);
                              },
                              child: Text(appFonts.message.tr,
                                      textAlign: TextAlign.center,
                                      style: AppCss.manropeBold12.textColor(
                                          isReceiver
                                              ? appCtrl.appTheme.sameWhite
                                              : appCtrl.appTheme.sameWhite))
                                  .marginSymmetric(vertical: Insets.i15))
                        ])),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  if (document!.isFavourite != null)
                    if (document!.isFavourite == true)
                      if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                      Icon(Icons.star,
                          color: appCtrl.appTheme.sameWhite, size: Sizes.s10),
                  const HSpace(Sizes.s3),
                  if (!isBroadcast && !isReceiver)
                    Icon(Icons.done_all_outlined,
                        size: Sizes.s15,
                        color: document!.isSeen == true
                            ? appCtrl.appTheme.sameWhite
                            : appCtrl.appTheme.tick),
                  const HSpace(Sizes.s5),
                  Text(
                      DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document!.timestamp!))),
                      style:
                      AppCss.manropeMedium12.textColor(appCtrl.appTheme.sameWhite))
                ]).padding(horizontal: Insets.i10,bottom: Insets.i10 )
              ]
            ).decorated(color: appCtrl.appTheme.primary,borderRadius: SmoothBorderRadius(
                cornerRadius: 15, cornerSmoothing: 1)).marginSymmetric(horizontal: Insets.i10)).paddingOnly(bottom: Insets.i10),
        if (document!.emoji != null)
          EmojiLayout(emoji: document!.emoji)
      ],
    );
  }
}
