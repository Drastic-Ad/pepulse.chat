import 'dart:developer';
import 'dart:ui';
import '../../../../config.dart';
import '../../../../widgets/common_image_layout.dart';
import 'group_user_status.dart';

class GroupChatMessageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? name, image;
  final VoidCallback? callTap, moreTap, videoTap;

  const GroupChatMessageAppBar(
      {super.key,
      this.name,
      this.callTap,
      this.image,
      this.videoTap,
      this.moreTap})
     ;

  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration:const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(49, 100, 189, 0.08),
                blurRadius: 15,
                spreadRadius: 2
            )
          ]),
          child: AppBar(
              backgroundColor: appCtrl.appTheme.primary,

              shadowColor: const Color.fromRGBO(255, 255, 255, 0.08),
              bottomOpacity: 0.0,
              elevation: 25,
              shape: const SmoothRectangleBorder(
                  borderRadius:
                  SmoothBorderRadius.vertical(bottom: SmoothRadius(cornerRadius: 20, cornerSmoothing: 1))),
              automaticallyImplyLeading: false,
              leadingWidth: Sizes.s70,
              toolbarHeight: Sizes.s90,
              titleSpacing: 0,
              leading: SvgPicture.asset(
                  appCtrl.isRTL || appCtrl.languageVal == "ar"
                      ? eSvgAssets.arrowRight
                      : eSvgAssets.arrowLeft,
                  colorFilter: ColorFilter.mode(appCtrl.appTheme.sameWhite, BlendMode.srcIn),
                  height: Sizes.s18)
                  .paddingAll(Insets.i10)
                  .newBoxDecoration()
                  .marginOnly(
                  right: Insets.i10,
                  top: Insets.i22,
                  bottom: Insets.i22,
                  left: Insets.i20)
                  .inkWell(onTap: () {
                Get.back();
              }),
              actions: [
                chatCtrl.isChatSearch == true
                    ? Row(
                  children: [
                    SvgPicture.asset(eSvgAssets.search).inkWell(
                        onTap: () async {

                          FocusScope.of(context).unfocus();
                          if (chatCtrl.txtChatSearch.text.isEmpty) {
                            chatCtrl.isChatSearch = false;
                            chatCtrl.update();
                          } else {
                            chatCtrl.count = chatCtrl.count ?? 0;

                            chatCtrl.update();
                            if (chatCtrl.count! >= chatCtrl.searchChatId.length) {
                              chatCtrl.count = 0;
                            }

                            final contentSize = chatCtrl.listScrollController
                                .position.viewportDimension +
                                chatCtrl.listScrollController.position
                                    .maxScrollExtent;

                            final target = contentSize *
                                chatCtrl.searchChatId[chatCtrl.count!] /
                                chatCtrl.localMessage.length;

                            log("DOCID L ${chatCtrl.searchChatId[chatCtrl.count!]}");
                            if (!chatCtrl.selectedIndexId.contains(
                                chatCtrl.searchChatId[chatCtrl.count!])) {
                              chatCtrl.localMessage.asMap().entries.forEach((element) {
                                element.value.message!.asMap().entries.forEach((e) {
                                  if(e.key ==chatCtrl.searchChatId[chatCtrl.count!] ) {
                                    chatCtrl.selectedIndexId.add(e.value.docId);
                                  }
                                });
                              });

                            }
                            // Scroll to that position.
                            chatCtrl.listScrollController.position.animateTo(
                              target,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut,
                            );

                            if (chatCtrl.count! >= chatCtrl.searchChatId.length) {
                              chatCtrl.count = 0;
                            } else {
                              chatCtrl.count = chatCtrl.count! + 1;
                            }
                            await Future.delayed(DurationsClass.s1).then((value) {
                              chatCtrl.selectedIndexId = [];
                              chatCtrl.update();
                            });
                            chatCtrl.update();
                            chatCtrl.getPeerStatus();

                          }
                        }),
                    const HSpace(Sizes.s10)
                  ],
                )
                    : chatCtrl.selectedIndexId.isNotEmpty
                    ? Row(children: [
                  chatCtrl.selectedIndexId.length > 1
                      ? Container()
                      :
                  SvgPicture.asset(
                      eSvgAssets.star,
                      colorFilter: ColorFilter.mode(appCtrl.appTheme.sameWhite, BlendMode.srcIn),
                      height: Sizes.s18)
                      .paddingAll(Insets.i10)
                      .newBoxDecoration()
                      .marginOnly(
                      top: Insets.i20,
                      bottom: Insets.i20,
                      right: Insets.i20).inkWell(onTap: () {
                    chatCtrl.showPopUp = false;
                    chatCtrl.enableReactionPopup = false;
                    chatCtrl.selectedIndexId
                        .asMap()
                        .entries
                        .forEach((element) async {
                      await FirebaseFirestore.instance
                          .collection(collectionName.users)
                          .doc(appCtrl.user["id"])
                          .collection(collectionName.groupMessage)
                          .doc(chatCtrl.pId)
                          .collection(collectionName.chat)
                          .doc(element.value)
                          .update({"isFavourite": true,"favouriteId":chatCtrl.user["id"]});
                    });
                    chatCtrl.selectedIndexId = [];
                    chatCtrl.update();
                  }),

                  SvgPicture.asset(
                      eSvgAssets.trash,
                      colorFilter: ColorFilter.mode(appCtrl.appTheme.sameWhite, BlendMode.srcIn),
                      height: Sizes.s18)
                      .paddingAll(Insets.i10)
                      .newBoxDecoration()
                      .marginOnly(
                      top: Insets.i20,
                      bottom: Insets.i20,
                      right: Insets.i20).inkWell(onTap: () => chatCtrl.buildPopupDialog())

                ])
                    : GetBuilder<GroupChatMessageController>(
                    builder: (context) {
                      return Row(
                        children: [
                          if(appCtrl.usageControlsVal!.callsAllowed!)
                          SvgPicture.asset(eSvgAssets.callAdd,
                              height: Sizes.s20,
                              colorFilter:
                              ColorFilter.mode(
                                  appCtrl
                                      .appTheme.sameWhite,
                                  BlendMode.srcIn))
                              .paddingAll(Insets.i10)
                              .newBoxDecoration()
                              .marginSymmetric(
                              vertical: Insets.i20)
                              .inkWell(
                              onTap: () =>
                                  chatCtrl.onTapStatus()),
                          const HSpace(Sizes.s15),
                          BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: chatCtrl.isFilter
                                      ? 3
                                      : 0,
                                  sigmaY: chatCtrl.isFilter
                                      ? 3
                                      : 0),
                              child: PopupMenuButton(
                                  onCanceled: () {
                                    chatCtrl.isFilter =
                                    false;
                                    chatCtrl.update();
                                  },
                                  onOpened: () => chatCtrl
                                      .onTapDots(),
                                  color: appCtrl
                                      .appTheme.white,
                                  padding:
                                  EdgeInsets.zero,
                                  iconSize: Sizes.s20,
                                  onSelected:
                                      (result) async {
                                    log("CAA : $result");

                                    if (result == 0) {
                                      chatCtrl.isFilter =
                                      false;
                                      chatCtrl.isChatSearch =
                                      true;
                                      chatCtrl.update();
                                    } else if (result ==
                                        1) {
                                      chatCtrl.isFilter =
                                      false;
                                       Get.toNamed(routeName.backgroundList,
                                        arguments: {
                                          "chatId": chatCtrl.chatId
                                        })!
                                        .then((value) {
                                      chatCtrl.selectedWallpaper = value;
                                      appCtrl.storage
                                          .write("backgroundImage", value);
                                      chatCtrl.update();
                                      log("chatCtrl.selectedImage : ${chatCtrl.selectedWallpaper}");
                                      Get.forceAppUpdate();
                                    });
                                    } else if (result ==
                                        2) {
                                      chatCtrl.isFilter =
                                      false;
                                      chatCtrl
                                          .clearChatConfirmation();
                                      chatCtrl.update();
                                    }
                                  },
                                  offset: Offset(
                                      0.0, appBarHeight),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.r8)),
                                  itemBuilder:
                                      (ctx) =>
                                  [
                                    _buildPopupMenuItem(
                                        appFonts.search,
                                        eSvgAssets.search,
                                        0),
                                    _buildPopupMenuItem(
                                        appFonts.wallpaper,
                                        eSvgAssets.wallpaper,
                                        1),
                                    _buildPopupMenuItem(
                                        appFonts
                                            .clearChat,
                                        eSvgAssets
                                            .trash,
                                        2,
                                        isDivider:
                                        false),
                                  ],
                                  child: SvgPicture.asset(eSvgAssets.more, height: Sizes.s22, colorFilter: ColorFilter.mode(appCtrl.appTheme.sameWhite, BlendMode.srcIn))
                                      .paddingAll(
                                      Insets.i10))
                                  .newBoxDecoration()
                                  .marginSymmetric(
                                  vertical: Insets.i20)
                                  .marginOnly(
                                  right: appCtrl.isRTL ||
                                      appCtrl.languageVal ==
                                          "ar"
                                      ? 0
                                      : Insets.i20,
                                  left: appCtrl.isRTL || appCtrl.languageVal == "ar"
                                      ? Insets.i20
                                      : 0)),
                        ],
                      );
                    })
              ],
              title:chatCtrl.selectedIndexId.isNotEmpty
                  ? Text(
                chatCtrl.selectedIndexId.length.toString(),
                style: AppCss.manropeMedium16
                    .textColor(appCtrl.appTheme.sameWhite),
              ).marginSymmetric(horizontal: Insets.i2)
                  : chatCtrl.isChatSearch
                  ? chatCtrl.searchTextField()
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonImage(
                      image: image,
                      name: name,
                      height: Sizes.s40,
                      width: Sizes.s40),
                  const HSpace(Sizes.s8),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name ?? "",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppCss.manropeSemiBold14
                                .textColor(appCtrl.appTheme.sameWhite)
                          ),
                          const VSpace(Sizes.s6),
                          const GroupUserLastSeen()
                        ]).marginSymmetric(vertical: Insets.i2)
                  )
                ]
              ).inkWell(onTap: () async {
                await chatCtrl.getPeerStatus();
               Get.toNamed(routeName.groupProfile);
              }))
        )
      );
    });
  }

  @override
  Size get preferredSize =>  const Size.fromHeight(Sizes.s80);

  PopupMenuItem _buildPopupMenuItem(
      String title, String iconData, int position, {isDivider = true}) {
    return PopupMenuItem(
      value: position,
      child: Column(
        children: [
          Row(children: [
            SvgPicture.asset(iconData,
                height: Sizes.s20,
                colorFilter: ColorFilter.mode(
                    appCtrl.appTheme.darkText, BlendMode.srcIn)),
            const HSpace(Sizes.s5),
            Text(title.tr,
                style: AppCss.manropeMedium14.textColor(
                    title == appFonts.block.tr
                        ? appCtrl.appTheme.redColor
                        : appCtrl.appTheme.darkText))
          ]),
          if (isDivider)
            Divider(
                color: appCtrl.appTheme.borderColor,
                height: 0,
                thickness: 1)
                .marginOnly(top: Insets.i15)
        ],
      ),
    );
  }
}
