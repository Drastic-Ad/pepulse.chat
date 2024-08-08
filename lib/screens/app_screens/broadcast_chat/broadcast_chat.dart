import '../../../config.dart';
import '../../../widgets/common_loader.dart';
import '../../bottom_screens/dashboard/layouts/agora_token.dart';
import 'layouts/broadcast_app_bar.dart';
import 'layouts/broadcast_body.dart';


class BroadcastChat extends StatefulWidget {
  const BroadcastChat({super.key});

  @override
  State<BroadcastChat> createState() => _BroadcastChatState();
}

class _BroadcastChatState extends State<BroadcastChat>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final chatCtrl = Get.put(BroadcastChatController());
  dynamic receiverData;

  @override
  void initState() {
    // TODO: implement initState
    receiverData = Get.arguments;
    WidgetsBinding.instance.addObserver(this);
    setState(() {});
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      firebaseCtrl.setIsActive();
    } else {
      firebaseCtrl.setLastSeen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: GetBuilder<BroadcastChatController>(builder: (_) {
        return DirectionalityRtl(
          child: AgoraToken(
                  scaffold:  PopScope(
                      canPop: false,
                      onPopInvoked: (didPop) {
                        if (didPop) return;
                        chatCtrl.onBackPress();
                        Get.back();
                      },

                      child: Scaffold(
                          extendBodyBehindAppBar: true,
                          appBar: BroadCastAppBar(
                              name: chatCtrl.pName != "" ? chatCtrl.pName :   chatCtrl.pData.isNotEmpty
                                  ? "${chatCtrl.pData.length} recipients"
                                  : "0",
                              nameList: chatCtrl.nameList),
                          backgroundColor: appCtrl.appTheme.white,
                          body: Stack(children: <Widget>[
                            const BroadcastBody().chatBgExtension(chatCtrl.selectedWallpaper),

                            // Loading
                            if (chatCtrl.isLoading!)
                              const CommonLoader()
                          ])))),
        );
      }),
    );
  }
}
