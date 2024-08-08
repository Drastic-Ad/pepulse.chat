import 'package:chatzy/screens/app_screens/broadcast_chat/layouts/broadcast_profile/broadcast_profile.dart';

import '../../../../config.dart';

class BroadCastAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? name, nameList;

  const BroadCastAppBar({super.key, this.name, this.nameList});

  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
      return AppBar(
          backgroundColor: appCtrl.appTheme.primary,
          shadowColor: const Color.fromRGBO(255, 255, 255, 0.08),
          bottomOpacity: 0.0,
          elevation: 18,
          shape: const SmoothRectangleBorder(
              borderRadius:
                  SmoothBorderRadius.vertical(bottom: SmoothRadius(cornerRadius: 20, cornerSmoothing: 1))),
          automaticallyImplyLeading: false,
          leadingWidth: Sizes.s70,
          toolbarHeight: Sizes.s90,
          titleSpacing: 0,
          leading:SvgPicture.asset(
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
            chatCtrl.onBackPress();
            Get.back();
          }),
          actions: [
            PopupMenuButton(

                color: appCtrl
                    .appTheme.white,
                padding:
                EdgeInsets.zero,
                iconSize: Sizes.s20,
                onSelected:
                    (result) async {
                  if (result == 0) {
                     Get.to(()=> const BroadcastProfile());
                  } else if (result == 1) {
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
                                      Get.forceAppUpdate();
                                    });
                  } else if (result ==
                      2) {

                    chatCtrl
                        .buildPopupDialog();
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
                      appFonts.viewInfo,
                      eSvgAssets.viewInfo,
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
                    : 0)
          ],
          title: Row(
            children: [
              Container(
                height: Sizes.s40,
                width: Sizes.s40,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                    color: appCtrl.appTheme.primaryLight1,
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 12, cornerSmoothing: 1)
                    ),
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage('${chatCtrl.pName}'))),
                child: Text(
                  name!.length > 2
                      ? name!.replaceAll(" ", "").substring(0, 2).toUpperCase()
                      : name![0],
                  style:
                      AppCss.manropeblack16.textColor(appCtrl.appTheme.sameWhite)
                )
              ),
              const HSpace(Sizes.s10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  name ?? "",
                  textAlign: TextAlign.center,
                  style: AppCss.manropeSemiBold16
                      .textColor(appCtrl.appTheme.sameWhite),
                ),
                const VSpace(Sizes.s5),
                Text(
                  nameList!,overflow: TextOverflow.ellipsis,
                  style: AppCss.manropeMedium14
                      .textColor(appCtrl.appTheme.sameWhite)
                ).width(Sizes.s170)
              ]),
            ],
          ).inkWell(onTap: ()=> Get.toNamed(routeName.broadcastProfile)),

      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(Sizes.s85);

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
