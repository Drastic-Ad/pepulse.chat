import 'dart:developer';
import 'dart:ui';
import '../../../config.dart';
import '../../../widgets/common_loader.dart';
import 'layouts/chat_message_app_bar.dart';
import 'layouts/input_box.dart';
import 'layouts/message_box.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final chatCtrl = Get.put(ChatController());
  dynamic receiverData;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatCtrl.setTyping();
    });
    receiverData = Get.arguments;

    setState(() {});
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      firebaseCtrl.setIsActive();
      chatCtrl.setTyping();
    } else {
      firebaseCtrl.setLastSeen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (_) {
      return DirectionalityRtl(
        child: PickupLayout(
          scaffold: PopScope(
            canPop: false,
                onPopInvoked: (didPop) {
                  if (didPop) return;
                  log("DD :$didPop");
                  chatCtrl.onBackPress();
                  Get.back();
                },
                child:Scaffold(
                  extendBodyBehindAppBar: true,
                        appBar: ChatMessageAppBar(
                            userId: chatCtrl.pId,
                            name: chatCtrl.pName,
                            callTap: () async {
                              await chatCtrl.permissionHandelCtrl
                                  .getCameraMicrophonePermissions()
                                  .then((value) {
                                if (value == true) {
                                  //chatCtrl.audioVideoCallTap(false);
                                }
                              });
                            },
                            videoTap: () async {
                              await chatCtrl.permissionHandelCtrl
                                  .getCameraMicrophonePermissions()
                                  .then((value) {
                                log("value : $value");
                                if (value == true) {
                                  log("message");
                                  //chatCtrl.audioVideoCallTap(true);
                                }
                              });
                            }),
                        backgroundColor: appCtrl.appTheme.screenBG,
                        body: Stack(children: <Widget>[
                                Stack(
                                      children: [
                                        Column(children: <Widget>[
                                            // List of messages
                                            const MessageBox(),
                                            // Sticker
                                            Container(),
                                            // Input content
                                            const InputBox(),
                                            if (chatCtrl.isShowSticker)
                                              chatCtrl.showBottomSheet()
                                          ]).chatBgExtension(chatCtrl.selectedWallpaper)
                                            .inkWell(onTap: () {
                                            chatCtrl.enableReactionPopup = false;
                                            chatCtrl.showPopUp = false;
                                            chatCtrl.isShowSticker = false;
                                            chatCtrl.update();
                                            log("chatCtrl.enableReactionPopup : ${chatCtrl.enableReactionPopup}");
                                          }),
                                        if(chatCtrl.isFilter)
                                          BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                              child: Container(
                                                  color: const Color(0xff042549).withOpacity(0.3)))

                                      ],
                                    ),
                                // Loading
                                if (chatCtrl.isLoading || appCtrl.isLoading)
                                  const CommonLoader(),

                              ])
                )
                   ),
        ),
      );

    });
  }
}
