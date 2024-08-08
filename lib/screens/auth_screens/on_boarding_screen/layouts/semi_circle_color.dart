import '../../../../config.dart';

class SemiCircleIconColor extends StatelessWidget {
  const SemiCircleIconColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: Sizes.s12,
              width: Sizes.s12
          ).decorated(color: appCtrl.appTheme.primary,shape: BoxShape.circle).paddingAll(Insets.i5).decorated(color: appCtrl.appTheme.white,gradient: RadialGradient(colors: [
            appCtrl.appTheme.greyText.withOpacity(0.5),
            appCtrl.appTheme.screenBG
          ],center:Alignment.topLeft,radius:1),shape: BoxShape.circle,boxShadow: [
            BoxShadow(color: appCtrl.appTheme.greyText.withOpacity(0.1),spreadRadius: 3,blurRadius: 3)
          ])
        ]
    );
  }
}
