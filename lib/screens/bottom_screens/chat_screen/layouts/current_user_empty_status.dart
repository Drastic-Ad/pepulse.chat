

import '../../../../config.dart';


class CurrentUserEmptyStatus extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String? currentUserId;

  const CurrentUserEmptyStatus({super.key, this.onTap, this.currentUserId})
     ;

  @override
  Widget build(BuildContext context) {

    return   MyStatusLayout(image: appCtrl.user["image"],name: appCtrl.user["name"],).inkWell(onTap: onTap);
  }
}
