import 'dart:developer';

import 'package:chatzy/config.dart';
import 'package:dio/dio.dart';

class MediaShareController extends GetxController {

  int selectedIndex = 0;
  List shardMediaList = [];
  List shardDocList = [];
  List sharedLink = [];
  bool isLoading = false;

  List mediaList = [
       appFonts.mediaFile,
       appFonts.document,
       appFonts.linkFile
  ];

  onTapTab(value) {
    selectedIndex = value;
    update();
  }

  onTapDocs(value) async{
    isLoading = true;
    update();
    var openResult = 'Unknown';
    var dio = Dio();
    var tempDir = await getExternalStorageDirectory();

    var filePath = tempDir!.path +
        (decryptMessage(value['content']).contains("-BREAK-") ?
    decryptMessage(value!['content']).split("-BREAK-")[0] : decryptMessage(value['content']));
    final response = await dio.download(
        decryptMessage(value['content']).contains("-BREAK-") ?
        decryptMessage(value!['content']).split("-BREAK-")[1] : decryptMessage(value['content']) , filePath);
    log("DOC PATH $filePath");
    final result = await OpenFilex.open(filePath);

    openResult = result.message;

    if(openResult == "No APP found to open this file。"){
      isLoading = false;
      update();
      flutterAlertMessage(msg: "No App Found To Open File");
    }
    log("DOC RESULT $openResult} ");
    log("response $response} ");
    isLoading = false;
    update();
    OpenFilex.open(filePath);
  }

  onTapLinks(value){
    launchUrl(Uri.parse(decryptMessage(value['content']).contains("-BREAK-") ?
    decryptMessage(value!['content']).split("-BREAK-")[0] : decryptMessage(value['content'])),mode: LaunchMode.externalApplication);
  }

  @override
  void onReady() {
    log("ARGGGGGS ${Get.arguments}");
    shardMediaList = Get.arguments["message"] ?? [];
    shardDocList = Get.arguments["docs"] ?? [];
    sharedLink = Get.arguments["links"] ?? [];
    update();
    // TODO: implement onReady
    super.onReady();
  }

}