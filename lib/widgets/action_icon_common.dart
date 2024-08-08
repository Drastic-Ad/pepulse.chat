import '../config.dart';

class ActionIconsCommon extends StatelessWidget {
  final String? icon;
  final GestureTapCallback? onTap;
  final double? vPadding,hPadding;
  final Color? color;
  const ActionIconsCommon({super.key,this.onTap,this.icon,this.vPadding,this.hPadding,this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: SvgPicture.asset(icon!,height: Sizes.s20,colorFilter: ColorFilter.mode(appCtrl.appTheme.darkText, BlendMode.srcIn))
            .paddingAll(Insets.i10)
            .decorated(
            color: color?? appCtrl.appTheme.borderColor,
            border: Border.all(
                color: appCtrl.appTheme.borderColor, width: 1),
            borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.r8)),
            boxShadow: [
              BoxShadow(
                  color: appCtrl.appTheme.borderColor.withOpacity(0.08),
                  spreadRadius: 2,
                  blurRadius: 2)
            ])).paddingSymmetric(vertical: vPadding ?? Insets.i13,horizontal: hPadding ?? 0).inkWell(onTap: onTap);
  }
}
