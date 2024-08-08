import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../config.dart';
import '../../../widgets/common_photo_view.dart';

class BroadcastOnTapFunctionCall {
  //contentTap
  contentTap(BroadcastChatController chatCtrl, docId) {
    if (chatCtrl.selectedIndexId.isNotEmpty) {
      chatCtrl.enableReactionPopup = false;
      chatCtrl.showPopUp = false;
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    }
  }

  //image tap
  imageTap(BroadcastChatController chatCtrl, docId, document) async {
    log("CONDITION ${chatCtrl.selectedIndexId.isNotEmpty || chatCtrl.enableReactionPopup}");
    if (chatCtrl.selectedIndexId.isNotEmpty || chatCtrl.enableReactionPopup) {
      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      log("docId==>${document.type}");
      log("docId==>${decryptMessage(document.content)}");
      Get.to(CommonPhotoView(image:  decryptMessage(document.content).contains("-BREAK-")
          ? decryptMessage(document.content).split("-BREAK-")[1]
          : decryptMessage(document.content),));}
   /* if (chatCtrl.selectedIndexId.isNotEmpty) {

      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();
      var filePath = tempDir!.path +
          (decryptMessage(document!.content).contains("-BREAK-")
              ? decryptMessage(document!.content).split("-BREAK-")[0]
              : (decryptMessage(document!.content)));
      final response = await dio.download(
          decryptMessage(document!.content).contains("-BREAK-")
              ? decryptMessage(document!.content).split("-BREAK-")[1]
              : decryptMessage(document!.content),
          filePath);
      final result = await OpenFilex.open(filePath);


      openResult = "type=${result.type}  message=${result.message}";
      log("response : $response");
      log("openResult : $openResult");

    }*/
  }

  //location tap
  locationTap(BroadcastChatController chatCtrl, docId, document) {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      launchUrl(Uri.parse(document!.content));
    }
  }

  //pdf tap
  pdfTap(BroadcastChatController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path + decryptMessage(document!.content).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!.content).split("-BREAK-")[1], filePath);

      final result = await OpenFilex.open(filePath);

      openResult = "type=${result.type}  message=${result.message}";
      OpenFilex.open(filePath);
      log("response : $response");
      log("openResult : $openResult");
    }
  }

  //doc tap
  docTap(BroadcastChatController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path + decryptMessage(document!.content).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!.content).split("-BREAK-")[1], filePath);

      final result = await OpenFilex.open(filePath);

      openResult = "type=${result.type}  message=${result.message}";
      OpenFilex.open(filePath);
      log("response : $response");
      log("openResult : $openResult");
    }
  }

  //excel tap
  excelTap(BroadcastChatController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path + decryptMessage(document!.content).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!.content).split("-BREAK-")[1], filePath);

      final result = await OpenFilex.open(filePath);

      openResult = "type=${result.type}  message=${result.message}";

      OpenFilex.open(filePath);
      log("response : $response");
      log("openResult : $openResult");
    }
  }

  //doc image tap
  docImageTap(BroadcastChatController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path + decryptMessage(document!.content).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!.content).split("-BREAK-")[1], filePath);

      final result = await OpenFilex.open(filePath);

      openResult = "type=${result.type}  message=${result.message}";
      OpenFilex.open(filePath);
      log("response : $response");
      log("openResult : $openResult");
    }
  }

}
