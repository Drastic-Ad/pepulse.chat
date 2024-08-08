import 'package:intl/intl.dart';

import '../../../../../config.dart';

class ReceiverContent extends StatelessWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;

  const ReceiverContent({super.key, this.document, this.onLongPress, this.onTap})
     ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Stack(clipBehavior: Clip.none, children: [
            decryptMessage(document!.content).length > 40
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Insets.i12, vertical: Insets.i14),
                    width: Sizes.s230,
                    decoration: ShapeDecoration(
                      color: appCtrl.appTheme.primary,
                      shape: const SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.only(
                              topLeft: SmoothRadius(
                                  cornerRadius: 20, cornerSmoothing: 1),
                              topRight: SmoothRadius(
                                  cornerRadius: 20, cornerSmoothing: 1),
                              bottomRight: SmoothRadius(
                                  cornerRadius: 20, cornerSmoothing: 1))),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(decryptMessage(document!.content),
                            style: AppCss.manropeSemiBold14
                                .textColor(appCtrl.appTheme.darkText)
                                .letterSpace(.2)
                                .textHeight(1.2)),
                        const VSpace(Sizes.s8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (document!.isFavourite != null)
                            if (document!.isFavourite == true)
                              if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                                Icon(Icons.star,
                                    color: appCtrl.appTheme.greyText,
                                    size: Sizes.s10),
                            if (document!.isBroadcast!)
                              const HSpace(Sizes.s3),
                            if (document!.isBroadcast!)
                              const Icon(Icons.volume_down, size: Sizes.s15),
                            const HSpace(Sizes.s5),
                            Text(
                              DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(document!.timestamp!))),
                              style: AppCss.manropeMedium12
                                  .textColor(appCtrl.appTheme.greyText),
                            ),
                          ],
                        ).alignment(Alignment.bottomRight)
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
                                        cornerRadius: 18, cornerSmoothing: 1),
                                    topRight: SmoothRadius(
                                        cornerRadius: 18, cornerSmoothing: 1),
                                    bottomRight:
                                        SmoothRadius(
                                            cornerRadius: 18,
                                            cornerSmoothing: 1)))),
                        child:
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(decryptMessage(document!.content),
                                  style: AppCss.manropeSemiBold14
                                      .textColor(appCtrl.appTheme.darkText)
                                      .letterSpace(.2)
                                      .textHeight(1.2)),
                              const VSpace(Sizes.s8),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (document!.isFavourite != null)
                                      if (document!.isFavourite == true)
                                        if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                                        Icon(Icons.star,
                                            color: appCtrl.appTheme.greyText,
                                            size: Sizes.s10),
                                    if (document!.isBroadcast!)
                                      const HSpace(Sizes.s3),
                                    if (document!.isBroadcast!)
                                      const Icon(Icons.volume_down,
                                          size: Sizes.s15),
                                    const HSpace(Sizes.s5),
                                    Text(
                                        DateFormat('hh:mm a').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                                    document!.timestamp!))),
                                        style: AppCss.manropeMedium12.textColor(
                                            appCtrl.appTheme.sameWhite))
                                  ])
                            ]))
                    .paddingOnly(
                        bottom: document!.emoji != null
                            ? Insets.i10
                            : 0),
            if (document!.emoji != null)
              EmojiLayout(emoji: document!.emoji)
          ])
        ]).marginSymmetric(horizontal: Insets.i12));
  }
}
