import '../../../../../../config.dart';

class IconCreation extends StatelessWidget {
  final String? icons;
  final Color? color;
  final String? text;
  final GestureTapCallback? onTap;
  const IconCreation({super.key,this.text,this.color,this.icons,this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: AppRadius.r30,
            backgroundColor: color,
            child: Image.asset(icons!)
          ),
          const VSpace(Sizes.s8),
          Text(
            text!,
            style: AppCss.manropeblack14.textColor(appCtrl.appTheme.darkText),
          )
        ],
      ),
    );
  }
}
