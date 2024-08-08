import '../../../../config.dart';

class ChatCardLayout extends StatelessWidget {
  final String? image, name, lastMessage, time, messagesCount;
  final GestureTapCallback? onTap;

  const ChatCardLayout(
      {super.key,
      this.image,
      this.name,
      this.time,
      this.lastMessage,
      this.messagesCount,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Column(children: [
            Stack(children: [
              ClipRRect(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppRadius.r10)),
                  child: Image.asset(image!, height: Sizes.s50)),
              const SizedBox(height: Sizes.s8, width: Sizes.s8)
                  .decorated(
                      color: appCtrl.appTheme.online,
                      borderRadius: BorderRadius.circular(AppRadius.r20),
                      border: Border.all(
                          color: appCtrl.appTheme.sameWhite, width: 1))
                  .paddingOnly(top: Insets.i2, left: Insets.i5)
            ])
          ]),
          const HSpace(Sizes.s10),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name!,
                    style: AppCss.manropeBold14
                        .textColor(appCtrl.appTheme.darkText)),
                const VSpace(Sizes.s8),
                Text(lastMessage!,
                    style: AppCss.manropeMedium14
                        .textColor(appCtrl.appTheme.greyText))
              ])
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(time!,
              style:
                  AppCss.manropeMedium12.textColor(appCtrl.appTheme.primary)),
          const VSpace(Sizes.s3),
          SizedBox(
                  child: Text(messagesCount!,
                          style: AppCss.manropeSemiBold10
                              .textColor(appCtrl.appTheme.sameWhite))
                      .paddingAll(Insets.i8))
              .decorated(
                  shape: BoxShape.circle, color: appCtrl.appTheme.primary)
        ]).paddingOnly(top: Insets.i5)
      ]),
      const VSpace(Sizes.s20),
      Divider(height: 1, thickness: 1, color: appCtrl.appTheme.borderColor)
    ]).inkWell(onTap: onTap);
  }
}
