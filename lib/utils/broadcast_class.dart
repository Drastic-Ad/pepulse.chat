import 'package:intl/intl.dart';

import '../../../../config.dart';

class BroadcastClass {
  //decoration
  ShapeDecoration broadcastDecoration(isReceiver) => ShapeDecoration(
      color: isReceiver
          ? appCtrl.appTheme.primary
          : appCtrl.appTheme.primary,
      shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.only(
              topLeft: const SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
              topRight:
                  const SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
              bottomLeft: SmoothRadius(
                  cornerRadius: isReceiver ? 0 : 20, cornerSmoothing: 1),
              bottomRight: SmoothRadius(
                  cornerRadius: isReceiver ? 20 : 0, cornerSmoothing: 1))));

  //time and favourite layout
  Widget timeFavouriteLayout(isFav, time,isGroup,isReceiver,isBroadcast,isSeen,favouriteId) => IntrinsicHeight(
    child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isGroup)
            if (!isReceiver && !isBroadcast)
              Icon(Icons.done_all_outlined,
                  size: Sizes.s15,
                  color: isSeen == true
                      ? appCtrl.appTheme.sameWhite
                      : appCtrl.appTheme.tick),
          const HSpace(Sizes.s5),
          IntrinsicHeight(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isFav == true)
                      if(appCtrl.user["id"].toString() == favouriteId)
                      Icon(Icons.star,
                          color: appCtrl.appTheme.greyText,
                          size: Sizes.s10),
                    const HSpace(Sizes.s3),
                    Text(
                        DateFormat('hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(time))),
                        style: AppCss.manropeMedium12
                            .textColor(appCtrl.appTheme.sameWhite))
                  ]))
        ]).marginSymmetric(
        vertical: Insets.i3, horizontal: Insets.i10),
  );
}
