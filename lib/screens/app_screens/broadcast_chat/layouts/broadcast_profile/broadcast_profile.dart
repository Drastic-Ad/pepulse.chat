import '../../../../../config.dart';
import '../../../../../widgets/gradiant_button_common.dart';
import '../../../chat_message/chat_user_profile/center_position_image.dart';
import 'broadcast_profile_body.dart';

class BroadcastProfile extends StatefulWidget {
  const BroadcastProfile({super.key});

  @override
  State<BroadcastProfile> createState() => _BroadcastProfileState();
}

class _BroadcastProfileState extends State<BroadcastProfile> {
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

//----------
  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (130 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return DirectionalityRtl(
      child: Scaffold(
        backgroundColor: appCtrl.appTheme.white,
        body: GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Stack(alignment: Alignment.bottomCenter, children: [
                      const CenterPositionImage(isBroadcast: true),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(chatCtrl.pName!,
                                      style: AppCss.manropeSemiBold18
                                          .textColor(appCtrl.appTheme.darkText)),
                                  const VSpace(Sizes.s8),
                                  Text(
                                      "${chatCtrl.pData.length.toString()} ${appFonts.people.tr}",
                                      style: AppCss.manropeMedium14
                                          .textColor(appCtrl.appTheme.greyText))
                                ]),
                            SvgPicture.asset(eSvgAssets.edit,
                                    colorFilter: ColorFilter.mode(
                                        appCtrl.appTheme.darkText,
                                        BlendMode.srcIn))
                                .inkWell(
                                    onTap: () {
                                      showDialog(
                                          context: Get.context!,
                                          builder: (context) {
                                            return  AlertDialog(
                                                contentPadding: EdgeInsets.zero,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(AppRadius.r8))),
                                                backgroundColor: appCtrl.appTheme.white,
                                                titlePadding: const EdgeInsets.all(Insets.i20),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Stack(
                                                        alignment: Alignment.bottomCenter,
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.r8)),
                                                              child: Image.asset(eImageAssets.titleHalfCircle)).paddingOnly(bottom: Insets.i40),
                                                          SizedBox(
                                                            child: SvgPicture.asset(eSvgAssets.broadCast,height: Sizes.s40,width: Sizes.s40,colorFilter: ColorFilter.mode(appCtrl.appTheme.primary, BlendMode.srcIn)).paddingAll(Insets.i20),
                                                          ).decorated(color: appCtrl.appTheme.white,shape: BoxShape.circle,border: Border.all(color: appCtrl.appTheme.primary)).paddingAll(Insets.i4).decorated(color: appCtrl.appTheme.white,shape: BoxShape.circle),

                                                        ]
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(appFonts.title.tr,style: AppCss.manropeSemiBold15.textColor(appCtrl.appTheme.darkText)),
                                                const VSpace(Sizes.s10),
                                                TextFieldCommon(hintText: appFonts.typeHere,controller: chatCtrl.textNameController),
                                                        const VSpace(Sizes.s30),
                                                        ButtonCommon(title: appFonts.update,onTap: () async{
                                                          chatCtrl.update();
                                                          if (chatCtrl.textNameController.text !=
                                                              chatCtrl.pName) {
                                                            await FirebaseFirestore.instance
                                                                .collection(collectionName.broadcast)
                                                                .doc(chatCtrl.pId)
                                                                .update({
                                                              "name": chatCtrl.textNameController.text
                                                            }).then((value) async{
                                                              chatCtrl.pName =
                                                                  chatCtrl.textNameController.text;
                                                              chatCtrl.update();
                                                              await FirebaseFirestore.instance.collection(collectionName.users).doc(appCtrl.user["id"])
                                                                  .collection(collectionName.chats)
                                                                  .where("broadcastId",isEqualTo: chatCtrl.pId).limit(1).get().then((chatBroadcast)async{
                                                                if(chatBroadcast.docs.isNotEmpty){
                                                                  await FirebaseFirestore.instance.collection(collectionName.users).doc(appCtrl.user["id"])
                                                                      .collection(collectionName.chats).doc(chatBroadcast.docs[0].id).update(
                                                                      {"name":chatCtrl.pName});
                                                                }
                                                              });
                                                            });
                                                          }
                                                          Get.back();
                                                        })
                                                      ]
                                                    ).paddingAll(Insets.i20)
                                                  ]
                                                ));
                                          }
                                      );
                                    })
                          ]).paddingAll(Insets.i20)
                    ]),
                    GradiantButtonCommon(
                        icon: appCtrl.isRTL || appCtrl.languageVal == "ar"
                            ? eSvgAssets.arrowRight
                            : eSvgAssets.arrowLeft,
                        onTap: () => chatCtrl.onBackPress()).paddingAll(Insets.i20)
                  ]
                ),
                const BroadcastProfileBody()
              ]
            )
          );
        }),
      ),
    );
  }
}
