import '../config.dart';

class GradiantButtonCommon extends StatelessWidget {
  final String? icon;
  final GestureTapCallback? onTap;
  const GradiantButtonCommon({super.key,this.icon,this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: SvgPicture.asset(icon!,height: Sizes.s20,)
            .paddingAll(Insets.i10)
            .decorated(
            color: appCtrl.appTheme.sameWhite,
            border: Border.all(
                color: appCtrl.isTheme ?appCtrl.appTheme.sameWhite : appCtrl.appTheme.borderColor, width: 1),
            borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.r8)),
            boxShadow: [
              BoxShadow(
                  color: appCtrl.appTheme.borderColor.withOpacity(0.08),
                  spreadRadius: 2,
                  blurRadius: 2)
            ]))
            .paddingSymmetric(vertical: Insets.i20).inkWell(onTap: onTap);
  }
}
