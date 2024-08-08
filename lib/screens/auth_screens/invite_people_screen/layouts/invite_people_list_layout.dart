import '../../../../config.dart';

class InvitePeopleListLayout extends StatelessWidget {
  final String? name;
 final Widget? widget;
 final GestureTapCallback? onTap;

  const InvitePeopleListLayout({super.key,this.name,this.widget,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: appCtrl.isRTL || appCtrl.languageVal == "ar" ? Alignment.centerLeft : Alignment.centerRight, children: [
      SizedBox(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
            Row(children: [
              widget!,
              const HSpace(Sizes.s15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(name!,overflow: TextOverflow.fade,
                    style: AppCss.manropeMedium14
                        .textColor(appCtrl.appTheme.darkText)).width(MediaQuery.of(context).size.width / 2.8)
              )
            ]),
            const SizedBox(height: Sizes.s36, width: Sizes.s5).decorated(
                color: appCtrl.appTheme.primary,
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppRadius.r4)))
          ]).paddingAll(Insets.i15))
          .boxDecoration()
          .paddingOnly(right: appCtrl.isRTL || appCtrl.languageVal == "ar" ? 0 : Insets.i95 ,left: appCtrl.isRTL || appCtrl.languageVal == "ar" ? Insets.i95 : 0 ),
      Row(mainAxisSize: MainAxisSize.min, children: [
        const Column(children: [
          DottedLinesWithRound(),
          VSpace(Sizes.s17),
          DottedLinesWithRound()
        ]),
        SizedBox(
                child: Text(appFonts.invite,
                    style: AppCss.manropeSemiBold14
                        .textColor(appCtrl.appTheme.primary)))
            .paddingSymmetric(vertical: Insets.i12, horizontal: Insets.i25)
            .decorated(
                color: appCtrl.appTheme.primary.withOpacity(0.2),
                border: Border.all(
                    color: appCtrl.appTheme.primary.withOpacity(0.3)),
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppRadius.r8))).inkWell(onTap: onTap)
      ])
    ]).paddingOnly(bottom: Insets.i20);
  }
}
