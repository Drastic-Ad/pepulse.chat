import 'package:intl/intl.dart';
import '../../../../../config.dart';


class GroupContent extends StatelessWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final bool isSearch;
  final List? userList;

  const GroupContent({super.key, this.document, this.onLongPress, this.onTap,this.isSearch = false,this.userList})
     ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: appCtrl.isRTL || appCtrl.languageVal == "ar" ? Alignment.bottomRight : Alignment.bottomLeft,
      children: [
        InkWell(
            onLongPress: onLongPress,
            onTap: onTap,
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              decryptMessage(document!.content).length > 40
                  ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Insets.i12, vertical: Insets.i14),
                  width: Sizes.s280,
                  decoration: ShapeDecoration(
                    color: appCtrl.appTheme.primary,
                    shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.only(
                            topLeft: SmoothRadius(
                                cornerRadius: 20, cornerSmoothing: 1),
                            topRight: SmoothRadius(
                                cornerRadius: 20, cornerSmoothing: 1),
                            bottomLeft: SmoothRadius(
                                cornerRadius: 20, cornerSmoothing: 1))),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(decryptMessage(document!.content),
                          overflow: TextOverflow.clip,
                          style: AppCss.manropeSemiBold14
                              .textColor(appCtrl.appTheme.sameWhite)
                              .letterSpace(.2)
                              .textHeight(1.2)),
                      const VSpace(Sizes.s8),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (document!.isFavourite != null)
                              if (document!.isFavourite == true)
                                if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                                  Icon(Icons.star,
                                      color: appCtrl.appTheme.sameWhite,
                                      size: Sizes.s10),
                            const HSpace(Sizes.s3),
                              Icon(Icons.done_all_outlined,
                                  size: Sizes.s15,
                                  color: document!.isSeen == true
                                      ? appCtrl.appTheme.tick
                                      : appCtrl.appTheme.sameWhite),
                            const HSpace(Sizes.s5),
                            Text(
                                DateFormat('hh:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(document!.timestamp!))),
                                style: AppCss.manropeMedium12
                                    .textColor(appCtrl.appTheme.sameWhite))
                          ])
                    ],
                  )).paddingOnly(bottom: Insets.i10)
                  : Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Insets.i12, vertical: Insets.i10),
                  decoration: ShapeDecoration(
                      color: appCtrl.appTheme.primary,
                      shape: const SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.only(
                              topLeft: SmoothRadius(
                                cornerRadius: 18,
                                cornerSmoothing: 1,
                              ),
                              topRight: SmoothRadius(
                                cornerRadius: 18,
                                cornerSmoothing: 1,
                              ),
                              bottomLeft: SmoothRadius(
                                  cornerRadius: 18, cornerSmoothing: 1)))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(decryptMessage(document!.content),
                            overflow: TextOverflow.clip,
                            style: AppCss.manropeSemiBold14
                                .textColor(appCtrl.appTheme.sameWhite)
                                .letterSpace(.2)
                                .textHeight(1.2)),
                        const VSpace(Sizes.s8),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (document!.isFavourite != null)
                                if (document!.isFavourite == true)
                                  if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                                    Icon(Icons.star,
                                        color: appCtrl.appTheme.sameWhite,
                                        size: Sizes.s10),
                              const HSpace(Sizes.s3),

                                Icon(Icons.done_all_outlined,
                                    size: Sizes.s15,
                                    color: document!.isSeen == true
                                        ? appCtrl.appTheme.sameWhite
                                        : appCtrl.appTheme.tick),
                              const HSpace(Sizes.s5),
                              Text(
                                  DateFormat('hh:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(
                                              document!.timestamp!))),
                                  style: AppCss.manropeMedium12.textColor(
                                      appCtrl.appTheme.sameWhite))
                            ])
                      ])).paddingOnly(bottom: document!.emoji != null ? Insets.i5 : 0 ),

            ]).marginSymmetric(horizontal: Insets.i15)),
        if (document!.emoji != null)
          EmojiLayout(emoji: document!.emoji)
      ],
    );
  }
}
