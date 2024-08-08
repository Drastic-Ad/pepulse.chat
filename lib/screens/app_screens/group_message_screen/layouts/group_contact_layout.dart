
import 'package:intl/intl.dart';

import '../../../../config.dart';
import '../../../bottom_screens/message/message_firebase_api.dart';
import '../../chat_message/layouts/contact_list_tile.dart';

class GroupContactLayout extends StatelessWidget {
  final MessageModel? document;
  final VoidCallback? onLongPress,onTap;
  final String? currentUserId;
  final bool isReceiver;
  final List? userList;
  const GroupContactLayout(
      {super.key,
      this.document,
      this.onLongPress,
      this.currentUserId,
      this.isReceiver = false,this.onTap,this.userList})
     ;

  @override
  Widget build(BuildContext context) {
    List seen = [];
    seen = document!.seenMessageList ?? [];

    return InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: appCtrl.languageVal == "ar" || appCtrl.isRTL ? Alignment.bottomRight : Alignment.bottomLeft,
          children: [
            Container(
                decoration: ShapeDecoration(
                    color: isReceiver
                        ? appCtrl.appTheme.primary
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
                width:  Sizes.s250 ,
                height:isReceiver ? Sizes.s150:Sizes.s120,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (document!.sender != currentUserId)
                        Column(children: [
                          Text(document!.senderName!,
                              style: AppCss.manropeMedium12
                                  .textColor(appCtrl.appTheme.primary)).paddingAll(Insets.i5).decorated(color: appCtrl.appTheme.white,borderRadius: BorderRadius.circular(AppRadius.r20)),

                        ]).marginSymmetric(horizontal: Insets.i10,vertical: Insets.i5),
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
                              : appCtrl.appTheme.white,
                          height: 1),
                      Column(
                        children: [
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
                                  style: AppCss.manropeExtraBold12.textColor(
                                      isReceiver
                                          ? appCtrl.appTheme.sameWhite
                                          : appCtrl.appTheme.white))
                                  .marginSymmetric(vertical: Insets.i12)),
                          IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (document!.isFavourite != null)
                                  if (document!.isFavourite == true)
                                    if(appCtrl.user["id"] == document!.favouriteId.toString())
                                    Icon(Icons.star,color: appCtrl.appTheme.sameWhite,size: Sizes.s10),
                                  const HSpace(Sizes.s3),
                                  if(!isReceiver)
                                  Icon(Icons.done_all_outlined,
                                      size: Sizes.s15,
                                      color: userList!.length == seen.length
                                          ? appCtrl.appTheme.primary
                                          : appCtrl.appTheme.sameWhite),
                                  const HSpace(Sizes.s3),
                                  Text(
                                    DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(document!.timestamp.toString()))),
                                    style:
                                    AppCss.manropeMedium12.textColor(appCtrl.appTheme.sameWhite),
                                  ),
                                ],
                              ).alignment(Alignment.bottomRight).marginSymmetric(horizontal: Insets.i10)
                          )
                        ],
                      )
                    ])).paddingOnly(bottom: document!.emoji != null ? Insets.i8 : 0),
            if (document!.emoji != null)
              EmojiLayout(emoji: document!.emoji)
          ],
        )

            .marginSymmetric(horizontal: Insets.i10, vertical: Insets.i10));
  }
}
