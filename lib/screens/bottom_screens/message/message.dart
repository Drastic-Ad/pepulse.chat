import '../../../config.dart';
import 'layout/chat_card.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final messageCtrl = Get.put(ChatDashController());

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    messageCtrl.getMessage();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      firebaseCtrl.setIsActive();
    } else {
      firebaseCtrl.setLastSeen();
    }
   // firebaseCtrl.statusDeleteAfter24Hours();
  //  firebaseCtrl.deleteForAllUsers();
    messageCtrl.getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatDashController>(builder: (_) {
      return GetBuilder<AppController>(builder: (appCtrl) {
        return Stack(children: [
          NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: Scaffold(
                  key: messageCtrl.scaffoldKey,
                  backgroundColor: appCtrl.appTheme.screenBG,
                  body:const ChatCard())),
        ]);
      });
    });
  }
}
