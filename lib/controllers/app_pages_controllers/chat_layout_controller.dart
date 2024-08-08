import 'package:chatzy/config.dart';

class ChatLayoutController extends GetxController {
  List chatLayoutMenuLists = [];
  List<ChatModel> chatList = [];
  List callLists = [];
  String? data;
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List mediaList = [
       appFonts.mediaFile,
       appFonts.documentFile,
       appFonts.linkFile
  ];

  onTapCall()=> alertDialog(
      title: appFonts.selectCall,
      list: callLists,
      onTap: (int index) {
        update();
      }
  );

  @override
  void onReady() {
    var dataFetch = appCtrl.storage.read(session.user);
    data = dataFetch["id"];
    debugPrint("DATA $data");
    debugPrint("LOGGG");
    chatLayoutMenuLists = appArray.chatLayoutMenuList;
    callLists = appArray.callList;
    chatList = appArray.chatList.map((e) => ChatModel.fromJson(e)).toList();
    update();
    // TODO: implement onReady
    super.onReady();
  }

  //send message
  setMessage() {
    if (controller.text.isNotEmpty) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      ChatModel messageModel =
          ChatModel(type: "source", message: controller.text);
      chatList.add(messageModel);
      controller.text = "";
      update();
    }
  }
}
