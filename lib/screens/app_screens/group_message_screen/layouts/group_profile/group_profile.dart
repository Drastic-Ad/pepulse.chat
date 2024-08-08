import '../../../../../config.dart';
import '../../../../../widgets/gradiant_button_common.dart';
import '../../../chat_message/chat_user_profile/center_position_image.dart';
import 'group_profile_body.dart';

class GroupProfile extends StatefulWidget {
  const GroupProfile({super.key});

  @override
  State<GroupProfile> createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
  var scrollController = ScrollController();
  int topAlign = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
  }

  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (130 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return DirectionalityRtl(
      child: Scaffold(
        backgroundColor: appCtrl.appTheme.screenBG,
        body: GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
          return SingleChildScrollView(
            child: Column( children: [
              Stack(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CenterPositionImage(
                          isGroup: true,
                          image: chatCtrl.groupImage,
                          name: chatCtrl.pName,
                          topAlign: topAlign,onTap:  ()=> chatCtrl.imagePickerOption(context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(chatCtrl.pName!,
                                  style: AppCss.manropeSemiBold18
                                      .textColor(
                                      appCtrl.appTheme.sameWhite)),
                              const VSpace(Sizes.s8),
                              Text("${chatCtrl.userList.length.toString()} ${appFonts.people.tr}",
                                  style: AppCss.manropeSemiBold18
                                      .textColor(appCtrl.appTheme.sameWhite))
                            ]
                          ),
                         // SvgPicture.asset(eSvgAssets.edit,colorFilter: ColorFilter.mode(appCtrl.appTheme.sameWhite, BlendMode.srcIn)).inkWell(onTap: ()=> Get.toNamed(routeName.editGroupDetailScreen))
                        ]
                      ).paddingAll(Insets.i20)
                    ]
                  ),
                  GradiantButtonCommon(
                      icon:  appCtrl.isRTL || appCtrl.languageVal == "ar"
                          ? eSvgAssets.arrowRight
                          : eSvgAssets.arrowLeft,
                      onTap: () => chatCtrl.onBackPress()).paddingAll(Insets.i20)
                ]
              ),
              const GroupProfileBody()
            ])
          );
        })
      )
    );
  }
}
