import 'package:intl/intl.dart';
import '../../../../../config.dart';

class GroupReceiverContent extends StatelessWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
final bool isSearch;
  const GroupReceiverContent({super.key, this.document, this.onLongPress,this.onTap,this.isSearch =false})
     ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(document!.sender)
            .snapshots(),
        builder: (context, snapshot) {
          return InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    decryptMessage(document!.content).length > 40
                        ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Insets.i12, vertical: Insets.i14),
                        width: Sizes.s230,
                        decoration: ShapeDecoration(
                          color: appCtrl.appTheme.primaryLight,
                          shape: const SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.only(
                                  topLeft:
                                  SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                                  topRight: SmoothRadius(
                                      cornerRadius: 20, cornerSmoothing: 1),
                                  bottomRight: SmoothRadius(
                                      cornerRadius: 20,
                                      cornerSmoothing: 1
                                  ))),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [ Text("${document!.senderName}",
                              style: AppCss.manropeBold12
                                  .textColor(appCtrl.appTheme.primary)),
                            const VSpace(Sizes.s6),
                            Text(decryptMessage(document!.content),
                                style: AppCss.manropeMedium14
                                    .textColor(appCtrl.appTheme.darkText)
                                    .letterSpace(.2)
                                    .textHeight(1.2)).alignment(Alignment.centerLeft).backgroundColor(isSearch ? appCtrl.appTheme.yellow.withOpacity(.5) : appCtrl.appTheme.trans),
                          ],
                        )) : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Insets.i12, vertical: Insets.i10),
                        decoration: ShapeDecoration(
                          color: appCtrl.appTheme.primaryLight,
                          shape: const SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.only(
                                  topLeft:
                                  SmoothRadius(cornerRadius: 18, cornerSmoothing: 1),
                                  topRight: SmoothRadius(
                                      cornerRadius: 18, cornerSmoothing: 1),
                                  bottomRight: SmoothRadius(
                                      cornerRadius: 18,
                                      cornerSmoothing: 1
                                  ))),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [ Text("${document!.senderName}",
                              style: AppCss.manropeSemiBold12
                                  .textColor(appCtrl.appTheme.primary)),
                            const VSpace(Sizes.s6),
                            Text(decryptMessage(document!.content),
                                style: AppCss.manropeMedium14
                                    .textColor(appCtrl.appTheme.darkText)
                                    .letterSpace(.2)
                                    .textHeight(1.2)).alignment(Alignment.centerLeft),
                          ],
                        )),
                    if (document!.emoji != null)
                      EmojiLayout(emoji: document!.emoji)
                  ],
                ),
                 VSpace(document!.emoji != null ?Sizes.s18 : Sizes.s5),
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
              ],
            ).marginSymmetric(vertical: Insets.i5, horizontal: Insets.i10),
          );
        });
  }
}
