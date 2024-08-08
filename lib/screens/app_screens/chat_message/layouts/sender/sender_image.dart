
import 'package:intl/intl.dart';
import '../../../../../config.dart';

class SenderImage extends StatelessWidget {
  final MessageModel? document;
  final VoidCallback? onPressed, onLongPress;
  final bool isBroadcast;
  final String? userId;

  const   SenderImage({super.key, this.document, this.onPressed, this.onLongPress,this.isBroadcast =false,this.userId})
     ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        InkWell(
            onLongPress: onLongPress,
            onTap:onPressed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: Insets.i10,),
                  decoration: ShapeDecoration(
                    color: appCtrl.appTheme.primary,
                    shape:  SmoothRectangleBorder(
                        borderRadius:SmoothBorderRadius(cornerRadius: 20,cornerSmoothing: 1)),
                  ),
                  child: ClipSmoothRect(
                    clipBehavior: Clip.hardEdge,
                    radius: SmoothBorderRadius(
                      cornerRadius: 20,
                      cornerSmoothing: 1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Material(
                          borderRadius: SmoothBorderRadius(cornerRadius: 15,cornerSmoothing: 1),
                          clipBehavior: Clip.hardEdge,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                                width: Sizes.s160,

                                decoration: ShapeDecoration(
                                  color: appCtrl.appTheme.primary,
                                  shape:  SmoothRectangleBorder(
                                      borderRadius:SmoothBorderRadius(cornerRadius: 10,cornerSmoothing: 1)),
                                ),
                                child: Container()),
                            imageUrl: decryptMessage(document!.content),
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
                                    color: appCtrl.appTheme.sameWhite, size: Sizes.s10),
                            const HSpace(Sizes.s3),
                            if (!isBroadcast)
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
                              style: AppCss.manropeMedium12
                                  .textColor(appCtrl.appTheme.sameWhite),
                            )
                          ],
                        ).paddingAll(Insets.i10)
                      ],
                    ),
                  ),
                ),

              ],
            )).paddingOnly(bottom: Insets.i10),
        if (document!.emoji != null)
          EmojiLayout(emoji: document!.emoji)
      ],
    );
  }
}
