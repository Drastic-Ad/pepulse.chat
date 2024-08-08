import 'package:intl/intl.dart';
import '../../../../config.dart';

class GifLayout extends StatelessWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final bool isReceiver, isGroup;
  final String? currentUserId;

  const GifLayout(
      {super.key,
      this.document,
      this.onLongPress,
      this.isReceiver = false,
      this.isGroup = false,
      this.currentUserId,
      this.onTap})
     ;

  @override
  Widget build(BuildContext context) {
    List seen = [];
    if (isGroup) {
      seen = document!.seenMessageList != null ? document!.seenMessageList! : [];
    }
    return Stack(
      alignment: appCtrl.isRTL || appCtrl.languageVal == "ar" ? Alignment.bottomRight : Alignment.bottomLeft,
      children: [
        InkWell(
            onLongPress: onLongPress,
            onTap: onTap,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Column(
                  children: [
                    if (isGroup)
                      if (isReceiver)
                        if (document!.sender != currentUserId)
                          Align(
                              alignment: Alignment.topLeft,
                              child: Column(children: [
                                Text(document!.senderName!,
                                    style: AppCss.manropeBold12
                                        .textColor(appCtrl.appTheme.primary))
                                    .paddingSymmetric(
                                    horizontal: Insets.i10, vertical: Insets.i5)
                                    .decorated(
                                    color: appCtrl.appTheme.white,
                                    borderRadius:
                                    BorderRadius.circular(AppRadius.r20))
                              ])).paddingAll(Insets.i5),
                    ClipRRect(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 15, cornerSmoothing: 1),
                            child: Image.network(decryptMessage(document!.content),
                                height: Sizes.s120, fit: BoxFit.contain))
                        .paddingAll(Insets.i5),
                  ],
                ),
                Row(children: [
                  if (document!.isFavourite != null)
                  if (document!.isFavourite == true)
                    if (appCtrl.user["id"] != document!.favouriteId)
                      Icon(Icons.star,
                          color: appCtrl.appTheme.sameWhite, size: Sizes.s10),
                  const HSpace(Sizes.s3),
                  isGroup
                      ? Icon(Icons.done_all_outlined,
                          size: Sizes.s15,
                          color: seen.contains(currentUserId)
                              ? appCtrl.appTheme.sameWhite
                              : appCtrl.appTheme.tick)
                      : !isReceiver ? Icon(Icons.done_all_outlined,
                          size: Sizes.s15,
                          color: document!.isSeen == true
                              ? appCtrl.appTheme.sameWhite
                              : appCtrl.appTheme.tick) : Container(),
                  const HSpace(Sizes.s5),
                  Text(
                      DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document!.timestamp!))),
                      style: AppCss.manropeSemiBold12
                          .textColor(appCtrl.appTheme.sameWhite))
                ]).padding(horizontal: Insets.i10, bottom: Insets.i5)
              ]).decorated(
                  color: appCtrl.appTheme.primary,
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 1))
            ]).padding(horizontal: Insets.i10, bottom: Insets.i5)),
        if (document!.emoji != null)
          EmojiLayout(emoji: document!.emoji)
      ],
    );
  }
}
