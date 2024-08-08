
import '../../../../config.dart';


class UnRegisterUser extends StatelessWidget {
  final String? image,name;
  final GestureTapCallback? onTap;

  const UnRegisterUser({super.key, this.name, this.image,this.onTap});

  @override
  Widget build(BuildContext context) {
    return InvitePeopleListLayout(
        name: name!,
        widget:   CircleAvatar(
          backgroundColor: appCtrl.appTheme.primary,
            radius: Sizes.s20,
            child: Text(
              image!,style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.sameWhite)
            )),
        onTap: onTap);
  }
}
