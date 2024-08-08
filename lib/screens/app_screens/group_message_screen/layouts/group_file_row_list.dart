
import '../../../../../../config.dart';
import '../../chat_message/layouts/icon_creation.dart';

class GroupFileRowList extends StatelessWidget {
  const GroupFileRowList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconCreation(
              icons: eImageAssets.doc,
              color: appCtrl.appTheme.primary,
              text: appFonts.document.tr,
              onTap: () => chatCtrl.documentShare()),
          const HSpace(Sizes.s40),
          IconCreation(
              icons: eImageAssets.video,
              color: appCtrl.appTheme.tick,
              text: appFonts.video.tr,
              onTap: ()  {
                Get.back();
                chatCtrl.pickerCtrl.videoPickerOption(context,isGroup: true);
              }),
          const HSpace(Sizes.s40),
          IconCreation(
              onTap: () {
                Get.back();
                chatCtrl.pickerCtrl.imagePickerOption(Get.context!,isGroup: true);
              },
              icons: eImageAssets.photos,
              color: appCtrl.appTheme.redColor,
              text: appFonts.gallery.tr)
        ]),
        const VSpace(Sizes.s30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconCreation(
              onTap: () {
                Get.back();
                chatCtrl.documentShare();
              },
              icons: eImageAssets.audio,
              color: appCtrl.appTheme.online,
              text: appFonts.audio.tr),
          const HSpace(Sizes.s40),
          IconCreation(
              onTap: () => chatCtrl.locationShare(),
              icons: eImageAssets.location,
              color: appCtrl.appTheme.error,
              text: appFonts.location.tr),
          const HSpace(Sizes.s40),
          IconCreation(
              icons: eImageAssets.contact,
              color: appCtrl.appTheme.yellow,
              text: appFonts.contact.tr,
              onTap: () {
                chatCtrl.pickerCtrl.dismissKeyboard();
                Get.back();
                chatCtrl.saveContactInChat();
              })
        ])
      ]);
    });
  }
}
