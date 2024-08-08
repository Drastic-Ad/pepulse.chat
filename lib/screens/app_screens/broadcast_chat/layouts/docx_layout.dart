import 'package:intl/intl.dart';

import '../../../../config.dart';
import '../../chat_message/layouts/doc_content.dart';

class DocxLayout extends StatelessWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final bool isReceiver, isGroup, isBroadcast;
  final String? currentUserId;

  const DocxLayout(
      {super.key,
      this.document,
      this.onLongPress,
      this.isReceiver = false,
      this.isGroup = false,
      this.isBroadcast = false,
      this.currentUserId,
      this.onTap})
     ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              DocContent(
                      isReceiver: isReceiver,
                      isBroadcast: isBroadcast,
                      document: document,
                      currentUserId: currentUserId,
                      isGroup: isGroup)
                  .paddingAll(Insets.i8)
                  .decorated(
                      color: isReceiver
                          ? appCtrl.appTheme.white
                          : appCtrl.appTheme.primary,
                      borderRadius: BorderRadius.circular(AppRadius.r8))
                  .marginSymmetric(horizontal: Insets.i10, vertical: Insets.i2),
              if (document!.emoji != null)
                EmojiLayout(emoji: document!.emoji)
            ]
          ),
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              if (document!.isFavourite != null)
              if (document!.isFavourite == true)
                if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                Icon(Icons.star,
                    color: appCtrl.appTheme.greyText, size: Sizes.s10),
              const HSpace(Sizes.s3),
              if (!isGroup)
                if (!isReceiver && !isBroadcast)
                  Icon(Icons.done_all_outlined,
                      size: Sizes.s15,
                      color: document!.isSeen == true
                          ? appCtrl.appTheme.primary
                          : appCtrl.appTheme.greyText),
              const HSpace(Sizes.s5),
              Text(
                  DateFormat('HH:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document!.timestamp.toString()))),
                  style: AppCss.manropeMedium12
                      .textColor(appCtrl.appTheme.greyText))
            ]).marginSymmetric(vertical: Insets.i3, horizontal: Insets.i10)
          )
        ]));
  }
}
