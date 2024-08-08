import 'package:intl/intl.dart';

import '../../../../../config.dart';

class ReceiverImage extends StatelessWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;

  const ReceiverImage({super.key, this.document, this.onLongPress,this.onTap})
     ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            clipBehavior: Clip.none ,
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: appCtrl.appTheme.borderColor,
                  shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.only(
                          topLeft: SmoothRadius(
                            cornerRadius: 20,
                            cornerSmoothing:1
                          ),
                          topRight: SmoothRadius(
                            cornerRadius: 20,
                            cornerSmoothing: 1
                          ),
                          bottomRight: SmoothRadius(
                            cornerRadius: 20,
                            cornerSmoothing: 1
                          ))),
                ),
                child:ClipSmoothRect(
                    clipBehavior: Clip.hardEdge,
                    radius: SmoothBorderRadius(
                      cornerRadius: 20,
                      cornerSmoothing: 1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Material(
                          borderRadius: SmoothBorderRadius(cornerRadius: 20,cornerSmoothing: 1),
                          clipBehavior: Clip.hardEdge,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                                width: Sizes.s160,

                                decoration: BoxDecoration(
                                  color: appCtrl.appTheme.primary,
                                  borderRadius: BorderRadius.circular(AppRadius.r8),
                                ),
                                child: Container()),
                            imageUrl: decryptMessage(document!.content!),
                            width: Sizes.s160,

                            fit: BoxFit.fill,
                          ),
                        ).padding(horizontal:Insets.i10,top: Insets.i10),
                        Row(
                          children: [
                            if (document!.isFavourite != null)
                              if (document!.isFavourite == true)
                                if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                                Icon(Icons.star,
                                    color: appCtrl.appTheme.greyText, size: Sizes.s10),
                            const HSpace(Sizes.s3),
                            Text(
                              DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(document!.timestamp!))),
                              style: AppCss.manropeMedium12
                                  .textColor(appCtrl.appTheme.greyText),
                            ).marginSymmetric(horizontal: Insets.i5, vertical: Insets.i8),
                          ],
                        ).paddingAll(Insets.i5)
                      ],
                    )
                )
              ),
              if (document!.emoji != null)
                EmojiLayout(emoji: document!.emoji)
            ],
          ),

        ],
      ),
    ).paddingSymmetric(horizontal: Insets.i15);
  }
}
