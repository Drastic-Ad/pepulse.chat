import 'dart:developer';
import 'package:intl/intl.dart';

import '../../../../../config.dart';

class GroupReceiverImage extends StatelessWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;

  const GroupReceiverImage(
      {super.key, this.document, this.onLongPress, this.onTap})
     ;

  @override
  Widget build(BuildContext context) {
    log("RECEIVER : ${document!.content}");
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              decoration: ShapeDecoration(
                color: appCtrl.appTheme.primaryLight,
                shape: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                        topLeft:
                            SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                        topRight:
                            SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                        bottomRight: SmoothRadius(
                            cornerRadius: 20, cornerSmoothing: 1))),
              ),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(document!.senderName.toString(),
                        style: AppCss.manropeSemiBold12
                            .textColor(appCtrl.appTheme.greyText))
                    .paddingOnly(
                        left: Insets.i12,
                        right: Insets.i12,
                        top: Insets.i12,
                        bottom: Insets.i10),
                ClipSmoothRect(
                    clipBehavior: Clip.hardEdge,
                    radius: SmoothBorderRadius(
                        cornerRadius: 20, cornerSmoothing: 1),
                    child: Material(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 20, cornerSmoothing: 1),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                    width: Sizes.s160,

                                    decoration: BoxDecoration(
                                      color: appCtrl.appTheme.primaryLight,
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.r8),
                                    ),
                                    child: Container()),
                                imageUrl: decryptMessage(document!.content),
                                width: Sizes.s160,

                                fit: BoxFit.cover))
                        .paddingSymmetric(horizontal: Insets.i10)
                        .paddingOnly(bottom: Insets.i12))
              ])),
          IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (document!.isFavourite != null)
                  if (document!.isFavourite == true)
                    if(appCtrl.user["id"] == document!.favouriteId.toString())
                    Icon(Icons.star,color: appCtrl.appTheme.greyText,size: Sizes.s10),
                  const HSpace(Sizes.s3),
                  Text(
                    DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document!.timestamp.toString()))),
                    style:
                    AppCss.manropeMedium12.textColor(appCtrl.appTheme.greyText),
                  ),
                ],
              )
          )
              .marginSymmetric(horizontal: Insets.i5, vertical: Insets.i8)
        ],
      ),
    );
  }
}
