import '../config.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.index,
    required this.image,
  });

  final VoidCallback? onPressed;
  final int index;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          eSvgAssets.round,
          height: Sizes.s50,
          width: Sizes.s50,
          fit: BoxFit.fill,
        ),
        SvgPicture.asset(
          image,
          colorFilter: ColorFilter.mode(
              appCtrl.appTheme.primary, BlendMode.srcIn),
        ).paddingOnly(bottom: Insets.i5)
      ],
    ).paddingOnly(right: index == 0 ? 10 : 0).inkWell(onTap: onPressed);
  }
}
