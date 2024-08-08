import '../config.dart';

class SharedMediaLayout extends StatelessWidget {
  final String? icon;
  final dynamic value;
  final GestureTapCallback? onTap;

  const SharedMediaLayout({super.key, this.icon, this.onTap, this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(children: [
        SvgPicture.asset(icon!,
                height: Sizes.s30, width: Sizes.s30, fit: BoxFit.scaleDown)
            .paddingSymmetric(vertical: Insets.i10, horizontal: Insets.i10)
            .decorated(
                color: appCtrl.appTheme.white,
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppRadius.r8)),
                border:
                    Border.all(color: appCtrl.appTheme.borderColor, width: 1))
            .width(Sizes.s50)
            .height(Sizes.s50),
        const HSpace(Sizes.s12),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
          decryptMessage(value["content"]).split("-BREAK-")[0],
          overflow: TextOverflow.ellipsis,
                  style: AppCss.manropeSemiBold14.textColor(appCtrl.appTheme.darkText)
        ),
          const VSpace(Sizes.s5),
          Text(decryptMessage(value["content"])
              .contains(".xlsx") ? "xlsx File" : decryptMessage(value["content"])
              .contains(".pdf") ? "PDF File" : decryptMessage(value["content"])
              .contains(".xls") ? "xls File" : decryptMessage(value["content"])
              .contains(".doc") ? "Document File" : decryptMessage(value["content"])
              .contains("youtube") || decryptMessage(value["content"])
              .contains("youtu.be") ? "Youtube.com" :
              decryptMessage(value["content"])
                  .contains("instagram.com") ? "Instagram.com" :
              decryptMessage(value["content"])
                  .contains("fb.watch") ? "Facebook.com" : "Image File" ,
          overflow: TextOverflow.ellipsis,
              style: AppCss.manropeMedium12.textColor(appCtrl.appTheme.greyText)
        )
              ]
            ).paddingAll(Insets.i14).decorated(
                color: appCtrl.appTheme.white,
                borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.r8)),
                border:
                Border.all(color: appCtrl.appTheme.borderColor, width: 1)),)
      ]).paddingOnly(bottom: Insets.i20).inkWell(onTap: onTap),
      SvgPicture.asset(eSvgAssets.join)
          .padding(horizontal: appCtrl.isRTL || appCtrl.languageVal == "ar" ? MediaQuery.of(context).size.width / 7.9 : MediaQuery.of(context).size.width / 7.4,top: MediaQuery.of(context).size.width / 20)
    ]);
  }
}
