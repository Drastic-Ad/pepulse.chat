import 'package:intl/intl.dart';

import '../../../../config.dart';
import 'doc_content.dart';

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
    return Stack(
      children: [
        InkWell(
            onLongPress: onLongPress,
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DocContent(
                        isReceiver: isReceiver,
                        isBroadcast: isBroadcast,
                        document: document,
                        currentUserId: currentUserId,
                        isGroup: isGroup)
                    .marginSymmetric(horizontal: Insets.i10),
                Row(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.end, children: [
                  if (document!.isFavourite != null)
                    if (document!.isFavourite == true)
                      if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                      Icon(Icons.star,
                          color: appCtrl.appTheme.sameWhite, size: Sizes.s10),
                  const HSpace(Sizes.s3),
                  if (!isGroup)
                    if (!isReceiver && !isBroadcast)
                      Icon(Icons.done_all_outlined,
                          size: Sizes.s15,
                          color: document!.isSeen == true
                              ? appCtrl.appTheme.sameWhite
                              : appCtrl.appTheme.tick),
                  const HSpace(Sizes.s5),
                  IntrinsicHeight(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (document!.isFavourite != null)
                              if (document!.isFavourite == true)
                                if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                                Icon(Icons.star,
                                    color: appCtrl.appTheme.sameWhite, size: Sizes.s10),
                            const HSpace(Sizes.s3),
                            Text(
                                DateFormat('hh:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(document!.timestamp!))),
                                style: AppCss.manropeMedium12
                                    .textColor(appCtrl.appTheme.sameWhite))
                          ]))
                ]).marginSymmetric(vertical: Insets.i8, horizontal: Insets.i10)
              ]
            ).decorated(
                color:  appCtrl.appTheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.r8))).paddingSymmetric(vertical: Insets.i10,horizontal: Insets.i10),
        if (document!.emoji != null)
          EmojiLayout(emoji: document!.emoji)
      ],
    );
  }
}
