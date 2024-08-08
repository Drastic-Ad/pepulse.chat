import 'package:chatzy/widgets/common_loader.dart';
import 'package:chatzy/widgets/shared_media_layout.dart';
import '../config.dart';
import '../screens/app_screens/chat_message/chat_user_profile/chat_video.dart';
import 'common_photo_view.dart';

class CommonMediaShareScreen extends StatelessWidget {
  final mediaCtrl = Get.put(MediaShareController());

  CommonMediaShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MediaShareController>(builder: (_) {
      return DirectionalityRtl(
        child: Scaffold(
            body: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                        child: Column(children: [
          Row(children: [
            ActionIconsCommon(
                    icon: appCtrl.isRTL || appCtrl.languageVal == "ar"
                    ? eSvgAssets.arrowRight
                    : eSvgAssets.arrowLeft, onTap: () => Get.back()),
            const HSpace(Sizes.s13),
            Text(appFonts.mediaFile.tr,
                    style: AppCss.manropeBold16.textColor(appCtrl.appTheme.darkText))
          ]),
          const VSpace(Sizes.s20),
          Divider(height: 1, thickness: 1, color: appCtrl.appTheme.borderColor),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: mediaCtrl.mediaList
                      .asMap()
                      .entries
                      .map((e) => Text(e.value.toString().tr,
                              style: mediaCtrl.selectedIndex == e.key
                                  ? AppCss.manropeBold14
                                      .textColor(appCtrl.appTheme.primary)
                                  : AppCss.manropeMedium14
                                      .textColor(appCtrl.appTheme.greyText))
                          .paddingSymmetric(
                              vertical: Insets.i18, horizontal: Insets.i20)
                          .decorated(
                              color: mediaCtrl.selectedIndex == e.key
                                  ? appCtrl.appTheme.primary.withOpacity(0.2)
                                  : appCtrl.appTheme.trans,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 3,
                                      color: mediaCtrl.selectedIndex == e.key
                                          ? appCtrl.appTheme.primary
                                          : appCtrl.appTheme.trans)))
                          .inkWell(onTap: () => mediaCtrl.onTapTab(e.key)))
                      .toList()),
          Divider(height: 1, thickness: 1, color: appCtrl.appTheme.borderColor),
          const VSpace(Sizes.s20),
          mediaCtrl.selectedIndex == 0 ? mediaCtrl.shardMediaList.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          itemCount: mediaCtrl.shardMediaList.length,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  mainAxisExtent: 120),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(AppRadius.r8)),
                              child: mediaCtrl.shardMediaList[index]["type"] ==
                                      MessageType.image.name
                                  ? Image.network(
                                      decryptMessage(
                                          mediaCtrl.shardMediaList[index]["content"]),
                                      height: Sizes.s130,
                                      width: Sizes.s100,
                                      fit: BoxFit.fill).inkWell(onTap:()=> Get.to(()=> CommonPhotoView(image: decryptMessage(
                                  mediaCtrl.shardMediaList[index]["content"]))) )
                                  : ChatVideo(
                                      snapshot: decryptMessage(mediaCtrl
                                          .shardMediaList[index]["content"]))
                            );
                          }) : Column(children: [
            Image.asset(eImageAssets.itemNotFound, width: Sizes.s240),
            const VSpace(Sizes.s10),
            Text("No Item Found",
                style: AppCss.manropeBold16
                    .textColor(appCtrl.appTheme.darkText))
          ]).paddingOnly(top: Insets.i160)
                      : mediaCtrl.selectedIndex == 1 ? mediaCtrl.shardDocList.isNotEmpty ?  Column(
                          children: mediaCtrl.shardDocList
                              .asMap()
                              .entries
                              .map((e) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (e.value["type"] == MessageType.doc.name)
                                        decryptMessage(e.value["content"])
                                                .contains(".pdf")
                                            ?  SharedMediaLayout(icon: eSvgAssets.pdf,value: e.value,onTap: ()=> mediaCtrl.onTapDocs(e.value))
                                        :(decryptMessage(e.value["content"])
                                            .contains(".xlsx") ||
                                            decryptMessage(e.value["content"])
                                                .contains(".xls")) ? SharedMediaLayout(icon: eSvgAssets.excel,value: e.value,onTap: ()=> mediaCtrl.onTapDocs(e.value)) : (decryptMessage(e.value["content"])
                              .contains(".doc") ? SharedMediaLayout(icon: eSvgAssets.docx,value: e.value,onTap: ()=> mediaCtrl.onTapDocs(e.value))
                                            : SharedMediaLayout(icon: eSvgAssets.jpg,value: e.value,onTap: ()=> mediaCtrl.onTapDocs(e.value))

                                        )
                                    ]
                                  ))
                              .toList()
                        ) :  Column(children: [
            Image.asset(eImageAssets.itemNotFound, width: Sizes.s240),
            const VSpace(Sizes.s10),
            Text("No Item Found",
                style: AppCss.manropeBold16
                    .textColor(appCtrl.appTheme.darkText))
          ]).paddingOnly(top: Insets.i160) : mediaCtrl.sharedLink.isNotEmpty ? Column(
              children: mediaCtrl.sharedLink
                  .asMap()
                  .entries
                  .map((e) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SharedMediaLayout(icon: eSvgAssets.link,value: e.value,onTap: ()=> mediaCtrl.onTapLinks(e.value)).paddingOnly(bottom: Insets.i10)


                  ]
              ))
                  .toList()
          ) : Column(children: [
            Image.asset(eImageAssets.itemNotFound, width: Sizes.s240),
            const VSpace(Sizes.s10),
            Text("No Item Found",
                style: AppCss.manropeBold16
                    .textColor(appCtrl.appTheme.darkText))
          ]).paddingOnly(top: Insets.i160)

        ]).paddingSymmetric(horizontal: Insets.i20)),
                      if(mediaCtrl.isLoading)
                      const CommonLoader()
                  ],
                ))),
      );
    });
  }
}
