
import '../../../../../config.dart';
import '../../../../widgets/gradiant_button_common.dart';
import 'chat_user_profile_title.dart';

class ChatUserProfileAppBar extends StatelessWidget {

  final bool isSliverAppBarExpanded,isBroadcast;
  final String? image, name;
  const ChatUserProfileAppBar({super.key,this.isSliverAppBarExpanded =false,this.isBroadcast =false,this.name,this.image});

  @override
  Widget build(BuildContext context) {
    return   SliverAppBar(
      expandedHeight: Sizes.s180,
      elevation: 0,
      floating: true,
      pinned: true,
      stretch: true,
      snap: false,
      automaticallyImplyLeading: false,
      leadingWidth: Sizes.s80,
      titleSpacing: 0,
      toolbarHeight: Sizes.s80,
      backgroundColor: appCtrl.appTheme.primary,
      leading: GradiantButtonCommon(icon: eSvgAssets.arrowLeft).paddingSymmetric(horizontal: Insets.i20),

      title: ChatUserProfileTitle(
          image: image,
          isBroadcast: isBroadcast,
          isSliverAppBarExpanded: isSliverAppBarExpanded,
          name: name),
      centerTitle: !isSliverAppBarExpanded ? true : false,
    );
  }
}
