import '../../../../config.dart';

class SemiCircleIcon extends StatelessWidget {
  const SemiCircleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Sizes.s8,
            width: Sizes.s8
        ).decorated(color: appCtrl.appTheme.greyText,shape: BoxShape.circle).paddingAll(Insets.i4).decorated(color: appCtrl.appTheme.white,shape: BoxShape.circle,boxShadow: [
          BoxShadow(color: appCtrl.appTheme.greyText.withOpacity(0.1),spreadRadius: 3,blurRadius: 3)
        ])
      ]
    );
  }
}
