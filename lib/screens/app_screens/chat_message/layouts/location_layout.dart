import 'package:intl/intl.dart';
import '../../../../config.dart';


class LocationLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  final VoidCallback? onLongPress;
  final MessageModel? document;
  final bool isReceiver, isBroadcast;

  const LocationLayout(
      {super.key,
      this.onLongPress,
      this.onTap,
      this.document,
      this.isReceiver = false,
      this.isBroadcast = false})
     ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: Insets.i8),
                  decoration: ShapeDecoration(
                      color: appCtrl.appTheme.primary,
                      shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.only(
                              topLeft: const SmoothRadius(
                                  cornerRadius: 20, cornerSmoothing: 1),
                              topRight: const SmoothRadius(
                                  cornerRadius: 20, cornerSmoothing: 1),
                              bottomLeft: SmoothRadius(
                                  cornerRadius: isReceiver ? 0 : 20,
                                  cornerSmoothing: 1),
                              bottomRight: const SmoothRadius(
                                  cornerRadius: 20, cornerSmoothing: 1)))),
                  child:
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    ClipRRect(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 15, cornerSmoothing: 1),
                        child: Image.asset(eImageAssets.map, height: Sizes.s150)),
                        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          if (document!.isFavourite != null)
                            if (document!.isFavourite == true)
                              if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                              Icon(Icons.star,
                                  color: appCtrl.appTheme.sameWhite, size: Sizes.s10),
                          const HSpace(Sizes.s3),
                          if (!isBroadcast && !isReceiver)
                            Icon(Icons.done_all_outlined,
                                size: Sizes.s15,
                                color: document!.isSeen== true
                                    ? appCtrl.appTheme.sameWhite
                                    : appCtrl.appTheme.tick),
                          const HSpace(Sizes.s5),
                          Text(
                              DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(document!.timestamp!))),
                              style:
                              AppCss.manropeBold12.textColor(appCtrl.appTheme.sameWhite))
                        ]).paddingAll(Insets.i6)
                  ]).paddingAll(Insets.i5)),

            ]).paddingOnly(bottom: Insets.i10)),
        if (document!.emoji != null)
          EmojiLayout(emoji: document!.emoji)
      ],
    );
  }
}
