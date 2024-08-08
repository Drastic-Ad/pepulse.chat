import 'dart:developer';

import 'package:giphy_get/giphy_get.dart';

import '../../../../config.dart';

class BroadcastInputBox extends StatelessWidget {
  const BroadcastInputBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
      return Row(children: [
        Expanded(
            child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                height: Sizes.s55,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xff2c2c14).withOpacity(0.08),
                          blurRadius: 4,
                          spreadRadius: 1)
                    ],
                    border: Border.all(
                        color: const Color.fromRGBO(49, 100, 189, 0.1),
                        width: 1),
                    color: appCtrl.appTheme.white),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(eSvgAssets.emojis, height: Sizes.s22)
                          .inkWell(onTap: () {
                        chatCtrl.pickerCtrl.dismissKeyboard();
                        chatCtrl.isShowSticker = !chatCtrl.isShowSticker;
                        log("SHOW ${chatCtrl.isShowSticker}");
                        chatCtrl.update();
                      }).paddingSymmetric(horizontal: Insets.i10),
                      Flexible(
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 5,
                            style: TextStyle(
                                color: appCtrl.appTheme.darkText, fontSize: 15.0),
                            controller: chatCtrl.textEditingController,
                            decoration: InputDecoration.collapsed(
                                hintText: appFonts.writeHere.tr,
                                hintStyle:
                                TextStyle(color: appCtrl.appTheme.greyText)),
                            enableInteractiveSelection: false,
                            keyboardType: TextInputType.text,
                            onTap: () {
                              chatCtrl.isShowSticker = false;
                              chatCtrl.update();
                            },
                            onChanged: (val) {
                              chatCtrl.isShowSticker = false;
                              if (chatCtrl.textEditingController.text.isNotEmpty) {
                                if (val.contains(".gif")) {
                                  chatCtrl.onSendMessage(val, MessageType.gif);
                                  chatCtrl.textEditingController.clear();
                                }
                                chatCtrl.setTyping();
                              }
                            },
                          ).inkWell(onTap: () => chatCtrl.isShowSticker = false)),
                      if (chatCtrl.textEditingController.text.isEmpty)
                        Row(children: [
                          SvgPicture.asset(eSvgAssets.clip).inkWell(
                              onTap: () => chatCtrl.shareMedia(context)),
                          const HSpace(Sizes.s10),
                          InkWell(
                              child: SvgPicture.asset(eSvgAssets.gif),
                              onTap: () async {
                                if (chatCtrl.isShowSticker = true) {
                                  chatCtrl.isShowSticker = false;
                                  chatCtrl.update();
                                }
                                GiphyGif? gif = await GiphyGet.getGif(
                                    tabColor: appCtrl.appTheme.primary,
                                    context: context,
                                    apiKey: appCtrl.userAppSettingsVal!.gifAPI!,
                                    lang: GiphyLanguage.english);
                                if (gif != null) {
                                  chatCtrl.onSendMessage(
                                      gif.images!.original!.url,
                                      MessageType.gif);
                                }
                              })
                        ]),
                      GestureDetector(
                        onTap: () =>  chatCtrl.onSendMessage(
                            chatCtrl.textEditingController.text,
                            chatCtrl.textEditingController.text.contains("https://") ||
                                chatCtrl.textEditingController.text.contains("http://")
                                ? MessageType.link
                                : MessageType.text),
                        onLongPress: (){
                          if(chatCtrl.textEditingController.text.isEmpty) {
                            chatCtrl.checkPermission("audio", 0);
                          }
                        },
                        child: Container(
                            height: Sizes.s50,
                            padding: const EdgeInsets.symmetric(
                              vertical: Insets.i10,
                            ),
                            decoration: ShapeDecoration(
                                gradient: RadialGradient(colors: [
                                  appCtrl.isTheme
                                      ? appCtrl.appTheme.primary
                                      : appCtrl.appTheme.primary,
                                  appCtrl.appTheme.primary
                                ]),
                                shape: SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius(
                                        cornerRadius: 12,
                                        cornerSmoothing: 1))),
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: SvgPicture.asset(
                                    chatCtrl.textEditingController.text.isNotEmpty
                                        ? eSvgAssets.send
                                        : eSvgAssets.microphone,
                                    colorFilter: ColorFilter.mode(
                                        appCtrl.appTheme.sameWhite,
                                        BlendMode.srcIn))))
                            .paddingSymmetric(vertical: Insets.i5)
                            .paddingSymmetric(horizontal: Insets.i10),
                      )
                    ])))
      ]);
    });
  }
}
