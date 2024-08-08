

import '../../../../config.dart';
import '../../../../utils/broadcast_class.dart';
import 'doc_content.dart';

class ExcelLayout extends StatelessWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final bool isReceiver, isGroup, isBroadcast;
  final String? currentUserId;

  const ExcelLayout(
      {super.key,
      this.document,
      this.onLongPress,
      this.isReceiver = false,
      this.isGroup = false,
      this.currentUserId,
      this.onTap,
      this.isBroadcast = false})
     ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
               DocContent(isReceiver: isReceiver,isBroadcast: isBroadcast,document: document,currentUserId: currentUserId,isGroup: isGroup),
                const VSpace(Sizes.s2),
                BroadcastClass().timeFavouriteLayout(
                    document!.isFavourite ??false,
                    document!.timestamp,
                    isGroup,
                    isReceiver,
                    isBroadcast,
                    document!.isSeen != null? document!.isSeen! : false,document!.favouriteId.toString())
              ],
            )
                .paddingAll(Insets.i8)
                .decorated(
                    color: isReceiver
                        ? appCtrl.appTheme.borderColor
                        : appCtrl.appTheme.primary,
                    borderRadius: BorderRadius.circular(AppRadius.r8))
                .marginSymmetric(horizontal: Insets.i10, vertical: Insets.i5),
            if (document!.emoji != null)
              EmojiLayout(emoji: document!.emoji),
          ],
        ));
  }
}
