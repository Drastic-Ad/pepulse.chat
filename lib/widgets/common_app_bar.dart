import '../config.dart';
import 'back_icon.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? text;
  final bool isBack;
  const CommonAppBar({super.key,this.text,this.isBack =true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appCtrl.appTheme.screenBG,
      automaticallyImplyLeading: false,
      leadingWidth: Sizes.s80,
      titleSpacing: 0,
      toolbarHeight: Sizes.s80,
      elevation: 0,
      leading: isBack?const BackIcon(): Container(),
      title: Text(text!,
          style: AppCss.manropeSemiBold16
              .textColor(appCtrl.appTheme.darkText)
              .letterSpace(.2)),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(Sizes.s80);
}
