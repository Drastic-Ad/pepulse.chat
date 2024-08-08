import '../../config.dart';

class ButtonCommon extends StatelessWidget {
  final String title;
  final double? padding, margin, radius, height, fontSize, width;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final Color? color, fontColor, borderColor;
  final Widget? icon;
  final FontWeight? fontWeight;
  final List<BoxShadow>? boxShadow;

  const ButtonCommon(
      {super.key,
      required this.title,
      this.padding,
      this.margin = 0,
      this.radius = AppRadius.r9,
      this.height = 46,
      this.fontSize = FontSizes.f30,
      this.onTap,
      this.style,
      this.color,
      this.fontColor,
      this.icon,
      this.borderColor,
      this.width,
      this.fontWeight = FontWeight.w700, this.boxShadow})
     ;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: margin!),
        decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? appCtrl.appTheme.trans),
            color:color?? appCtrl.appTheme.primary,
            boxShadow: boxShadow,
            borderRadius: BorderRadius.circular(radius!)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null)
            Row(children: [icon ?? const HSpace(0), const HSpace(Sizes.s10)]),
          Text(title.tr,
              textAlign: TextAlign.center,
              style: style ??
                  AppCss.manropeBold15.textColor(appCtrl.appTheme.sameWhite))
        ])).inkWell(onTap: onTap);
  }
}
