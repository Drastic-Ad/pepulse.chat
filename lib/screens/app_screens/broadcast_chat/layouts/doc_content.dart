
import '../../../../config.dart';

class DocContent extends StatelessWidget {
  final MessageModel? document;
  final bool isReceiver, isGroup, isBroadcast,isDoc;
  final String? currentUserId;
  const DocContent({super.key, this.document,
    this.isReceiver = false,
    this.isGroup = false,
    this.currentUserId,

    this.isBroadcast = false,this.isDoc = true});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isGroup)
            if (isReceiver)
              if (document!.sender != currentUserId)
                Align(
                    alignment: Alignment.topLeft,
                    child: Column(children: [
                      Text(document!.senderName.toString(),
                          style: AppCss.manropeMedium12
                              .textColor(appCtrl.appTheme.primary)),
                      const VSpace(Sizes.s8)
                    ])),
          Row(children: [
            isDoc ?SvgPicture.asset(eSvgAssets.docx, height: Sizes.s20)  .paddingSymmetric(
                horizontal: Insets.i10, vertical: Insets.i8)
                .decorated(
                color: appCtrl.appTheme.white,
                borderRadius:
                BorderRadius.circular(AppRadius.r8)) :
            Image.asset(eImageAssets.xlsx, height: Sizes.s20),
            const HSpace(Sizes.s10),
            Expanded(
                child: Text(
                    decryptMessage(document!.content)
                        .split("-BREAK-")[0],
                    textAlign: TextAlign.start,
                    style: AppCss.manropeMedium12.textColor(isReceiver
                        ? appCtrl.appTheme.greyText
                        : appCtrl.appTheme.white)))
          ])
              .width(Sizes.s200)
              .paddingSymmetric(
              horizontal: Insets.i10, vertical: Insets.i15)
              .decorated(
              color: isReceiver
                  ? appCtrl.appTheme.greyText
                  : appCtrl.appTheme.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.r8))
        ]
    );
  }
}
