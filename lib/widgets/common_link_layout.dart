import 'dart:developer';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:intl/intl.dart';

import '../config.dart';

class CommonLinkLayout extends StatelessWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final bool isReceiver, isGroup, isBroadcast;
  final String? currentUserId;

  const CommonLinkLayout(
      {super.key,
      this.document,
      this.onLongPress,
      this.isReceiver = false,
      this.isGroup = false,
      this.currentUserId,
      this.isBroadcast = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: appCtrl.isRTL || appCtrl.languageVal == "ar" ? Alignment.bottomRight : Alignment.bottomLeft,
      children: [
        Container(
            margin: const EdgeInsets.only(bottom: Insets.i15,right: Insets.i15,left: Insets.i15),
            padding: linkCondition(document)
                ? const EdgeInsets.all(Insets.i8)
                : const EdgeInsets.all(0),
            width: Sizes.s250,
            decoration: ShapeDecoration(
                color: appCtrl.appTheme.primary,
                shape:  SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                        topLeft: const SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                        topRight:
                            const SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                        bottomLeft:
                            SmoothRadius(cornerRadius: isReceiver ? 0 : 20, cornerSmoothing: 1),
                    bottomRight: SmoothRadius(cornerRadius: isReceiver ? 20 : 0, cornerSmoothing: 1),
                    ))),
            child: AnyLinkPreview.builder(
                link: decryptMessage(document!.content),
                itemBuilder: (context, metadata, imageProvider) {
                  log("IMAGE PRO $imageProvider");
                  return Column(children: [
                    if (isGroup)
                      if (isReceiver)
                        if (document!.sender != currentUserId)
                          Align(
                              alignment: Alignment.topLeft,
                              child: Column(children: [
                                Text(document!.senderName!,
                                    style: AppCss.manropeMedium12
                                        .textColor(appCtrl.appTheme.primary)),
                                const VSpace(Sizes.s8)
                              ])),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          linkCondition(document)
                              ? imageProvider != null
                                  ? Container(
                                      constraints: BoxConstraints(
                                          maxHeight:
                                              MediaQuery.of(context).size.width *
                                                  0.5),
                                      width: Sizes.s250,
                                      decoration: BoxDecoration(
                                          borderRadius: SmoothBorderRadius(
                                              cornerRadius: AppRadius.r12),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover)))
                                  : Container()
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    imageProvider != null
                                        ? Container(
                                            constraints: BoxConstraints(
                                                maxHeight: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2),
                                            width: Sizes.s70,
                                            decoration: BoxDecoration(
                                                borderRadius: SmoothBorderRadius(
                                                    cornerRadius: AppRadius.r12),
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover)))
                                        : Container(),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                          if (metadata.title != null)
                                            Text(metadata.title!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: AppCss.manropeSemiBold13
                                                    .textColor(appCtrl
                                                        .appTheme.sameWhite)),
                                          const SizedBox(height: 5),
                                          Text(
                                              metadata.url ??
                                                  decryptMessage(
                                                      document!.content),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: AppCss.manropeSemiBold13
                                                  .textColor(
                                                      appCtrl.appTheme.sameWhite))
                                        ]).paddingSymmetric(
                                            horizontal: Insets.i12,
                                            vertical: Insets.i14))
                                  ]
                                ).paddingAll(Insets.i8).decorated(
                                  color: appCtrl.appTheme.white.withOpacity(0.2)),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: Insets.i10,
                                  horizontal: linkCondition(document)
                                      ? Insets.i5
                                      : Insets.i12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (metadata.title != null)
                                      Text(metadata.title!,
                                          maxLines: 1,
                                          style: AppCss.manropeSemiBold13.textColor(
                                              appCtrl.appTheme.sameWhite)),
                                    const SizedBox(height: 5),
                                    Text(
                                        metadata.url ??
                                            decryptMessage(document!.content),
                                        maxLines: 1,
                                        style: AppCss.manropeSemiBold13
                                            .textColor(appCtrl.appTheme.sameWhite))
                                  ])),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (!isGroup)
                                  if (!isReceiver && !isBroadcast)
                                    Icon(Icons.done_all_outlined,
                                        size: Sizes.s15,
                                        color: document!.isSeen == true
                                            ? appCtrl.appTheme.sameWhite
                                            : appCtrl.appTheme.tick),
                                const HSpace(Sizes.s5),
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (document!.isFavourite != null)
                                        if (document!.isFavourite == true)
                                          if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                                          Icon(Icons.star,
                                              color: isReceiver
                                                  ? appCtrl.appTheme.sameWhite
                                                  : appCtrl.appTheme.sameWhite,
                                              size: Sizes.s10),
                                      const HSpace(Sizes.s3),
                                      Text(
                                          DateFormat('hh:mm a').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  int.parse(
                                                      document!.timestamp!))),
                                          style: AppCss.manropeMedium12.textColor(
                                              isReceiver
                                                  ? appCtrl.appTheme.sameWhite
                                                  : appCtrl.appTheme.sameWhite))
                                    ])
                              ]).paddingAll(linkCondition(document) ? 0 : Insets.i8)
                        ])
                  ]);
                })).inkWell(onTap: onTap, onLongPress: onLongPress),
        if (document!.emoji != null)
          EmojiLayout(emoji: document!.emoji).paddingOnly(bottom: Insets.i3)
      ]
    ).paddingOnly(bottom: document!.emoji != null ? Insets.i5 : 0);
  }
}
