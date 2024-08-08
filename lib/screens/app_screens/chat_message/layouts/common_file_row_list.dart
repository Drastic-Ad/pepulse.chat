import '../../../../../../config.dart';
import 'icon_creation.dart';

class CommonFileRowList extends StatelessWidget {

  const CommonFileRowList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
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
              color: appCtrl.appTheme.primary,
              text: appFonts.video.tr,
              onTap: () {
                chatCtrl.pickerCtrl.videoPickerOption(context,isSingleChat: true);
              }),
          const HSpace(Sizes.s40),
          IconCreation(
              onTap: () {
               Get.back();
               chatCtrl.pickerCtrl.imagePickerOption(Get.context!,isSingleChat: true);
              },
              icons: eImageAssets.photos,
              color: appCtrl.appTheme.primary,
              text: appFonts.gallery.tr)
        ]),
        const VSpace(Sizes.s30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconCreation(
              onTap: () {
                chatCtrl.documentShare();
              },
              icons: eImageAssets.audio,
              color: appCtrl.appTheme.primary,
              text: appFonts.audio.tr),
          const HSpace(Sizes.s40),
          IconCreation(
              onTap: () => chatCtrl.locationShare(),
              icons: eImageAssets.location,
              color: appCtrl.appTheme.primary,
              text: appFonts.location.tr),
          const HSpace(Sizes.s40),
          IconCreation(
              icons: eImageAssets.contact,
              color: appCtrl.appTheme.primary,
              text: appFonts.contact.tr,
              onTap: () {
                chatCtrl.pickerCtrl.dismissKeyboard();

                chatCtrl.saveContactInChat();
              })
        ])
      ]);
    });
  }
}
