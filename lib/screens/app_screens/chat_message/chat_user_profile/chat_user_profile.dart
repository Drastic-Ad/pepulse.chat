import 'dart:developer';
import 'package:chatzy/widgets/gradiant_button_common.dart';
import '../../../../../config.dart';
import '../../../../widgets/common_photo_view.dart';
import 'chat_user_images.dart';

class ChatUserProfile extends StatefulWidget {
  const ChatUserProfile({super.key});

  @override
  State<ChatUserProfile> createState() => _ChatUserProfileState();
}

class _ChatUserProfileState extends State<ChatUserProfile> {
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
    if (isSliverAppBarExpanded) {
      topAlign = topAlign + 1;
    } else {
      topAlign = 5;
    }
    return DirectionalityRtl(
      child: Scaffold(
        backgroundColor: appCtrl.appTheme.screenBG,
        body: GetBuilder<ChatController>(builder: (chatCtrl) {
          log("CHAT IDD ${chatCtrl.chatId}");
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              Stack(alignment: Alignment.bottomLeft, children: [
                chatCtrl.pData != null && chatCtrl.pData["image"] != null
                    ? CachedNetworkImage(
                        imageUrl: chatCtrl.pData["image"],
                        imageBuilder: (context, imageProvider) => Container(
                                height: Sizes.s240,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            chatCtrl.pData["image"]))))
                            .inkWell(
                                onTap: () => Get.to(CommonPhotoView(
                                    image: chatCtrl.pData["image"]))),
                        placeholder: (context, url) => Container(
                                height: Sizes.s240,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: Insets.i10),
                                child: SizedBox(
                                    child: Text(
                                            chatCtrl.pData["name"] != null
                                                ? chatCtrl.pData["name"].length >
                                                        2
                                                    ? chatCtrl.pData["name"]
                                                        .replaceAll(" ", "")
                                                        .substring(0, 2)
                                                        .toUpperCase()
                                                    : chatCtrl.pData["name"][0]
                                                : "C",
                                            style: AppCss.manropeExtraBold30.textColor(appCtrl.appTheme.primary))
                                        .paddingAll(Insets.i20)
                                        .decorated(color: appCtrl.appTheme.sameWhite, shape: BoxShape.circle)))
                            .decorated(color: appCtrl.appTheme.primary),
                        errorWidget: (context, url, error) => Container(
                                height: Sizes.s240,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: Insets.i8),
                                child: SizedBox(
                                    child: Text(
                                            chatCtrl.pData["name"] != null
                                                ? chatCtrl.pData["name"].length > 2
                                                    ? chatCtrl.pData["name"].replaceAll(" ", "").substring(0, 2).toUpperCase()
                                                    : chatCtrl.pData["name"][0]
                                                : "C",
                                            style: AppCss.manropeExtraBold30.textColor(appCtrl.appTheme.primary))
                                        .paddingAll(Insets.i25)
                                        .decorated(color: appCtrl.appTheme.sameWhite, shape: BoxShape.circle)))
                            .decorated(color: appCtrl.appTheme.primary))
                    : const CircularProgressIndicator(),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(chatCtrl.pName != null ? chatCtrl.pName! : "",
                      style: AppCss.manropeBold20
                          .textColor(appCtrl.appTheme.sameWhite)),
                  const VSpace(Sizes.s10),
                  chatCtrl.pData != null && chatCtrl.pData["image"] != null
                      ? Text(chatCtrl.pData["phone"],
                          style: AppCss.manropeSemiBold14
                              .textColor(appCtrl.appTheme.sameWhite))
                      : Container()
                ]).paddingAll(Insets.i20)
              ]),
              GradiantButtonCommon(
                  icon: appCtrl.isRTL || appCtrl.languageVal == "ar" ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
                  onTap: () => chatCtrl.onBackPress()).paddingAll(Insets.i20)
            ]),
            const VSpace(Sizes.s20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(appFonts.status.tr,
                  style: AppCss.manropeSemiBold14
                      .textColor(appCtrl.appTheme.greyText)),
              const VSpace(Sizes.s8),
              Text(chatCtrl.userData["statusDesc"],
                  style:
                      AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)),
              Divider(
                      height: 1,
                      color: appCtrl.appTheme.borderColor,
                      thickness: 1)
                  .paddingSymmetric(vertical: Insets.i20),
              ChatUserImagesVideos(chatId: chatCtrl.chatId)
            ]).paddingSymmetric(horizontal: Insets.i20)
          ]);
        }),
      ),
    );
  }
}
