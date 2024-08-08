import 'dart:developer';
import 'package:dio/dio.dart';

import '../../../config.dart';
import '../../../widgets/common_photo_view.dart';

class OnTapFunctionCall {
  //contentTap
  contentTap(ChatController chatCtrl, docId) {
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
  imageTap(ChatController chatCtrl, docId, document) async {
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
      Get.to(CommonPhotoView(
        image: decryptMessage(document.content).contains("-BREAK-")
            ? decryptMessage(document.content).split("-BREAK-")[1]
            : decryptMessage(document.content),));
      /*  log("CONDITION ${chatCtrl.selectedIndexId.isNotEmpty || chatCtrl.enableReactionPopup}");
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
      log("result : $openResult");
      log("result : $response");
    }*/
    }
  }

  //location tap
  locationTap(ChatController chatCtrl, docId, document) {
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
      log("DECR MSG ${decryptMessage(document!.content)}");

      if(decryptMessage(document!.content).contains("query=")) {
        log("Splited MSG ${decryptMessage(document!.content).split("query=")}");
        List<String> input = decryptMessage(document!.content).split("query=");
        log(input[1].split(",").toString());
        List<String> input1 = input[1].split(",");
        log(input1[0].toString());
        launchUrl(Uri.parse(decryptMessage(document!.content)),mode: LaunchMode.externalApplication);
        //chatCtrl.openMapsSheet(Get.context!,input1[0].toString().toDouble(),input1[1].toString().toDouble());
      } else {
        launchUrl(Uri.parse(decryptMessage(document!.content)));
      }
    }
  }

  //pdf tap
  pdfTap(ChatController chatCtrl, docId, document) async {
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
      appCtrl.isLoading = true;
      appCtrl.update();
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path +
          decryptMessage(document!.content).split("-BREAK-")[0];
      log("FILE PATH $filePath");
      final response = await dio.download(
          decryptMessage(document!.content).split("-BREAK-")[1], filePath);
      appCtrl.isLoading = false;
      appCtrl.update();
      final result = await OpenFilex.open(filePath);
      log("Result ${result.message}");
      log("Result1 ${result.type}");
      appCtrl.isLoading = false;
      appCtrl.update();
      OpenFilex.open(filePath);
      log("result : $response");
    }
  }

  //doc tap
  docTap(ChatController chatCtrl, docId, document) async {
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
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path +
          decryptMessage(document!.content).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!.content).split("-BREAK-")[1], filePath);
      log("DOC PATH $filePath");
      final result = await OpenFilex.open(filePath);

      openResult = result.message;

      if(openResult == "No APP found to open this file。"){
        flutterAlertMessage(msg: "No App Found To Open File");
      }
      log("DOC RESULT $openResult} ");
      log("result : $response");
      OpenFilex.open(filePath);
    }
  }

  //excel tap
  excelTap(ChatController chatCtrl, docId, document) async {
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
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path +
          decryptMessage(document!.content).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!.content).split("-BREAK-")[1], filePath);
      log("EXCEL PATH $filePath");
      final result = await OpenFilex.open(filePath);

      openResult = "type=${result.type}  message=${result.message}";

      log("result : $response");
      log("result : $openResult");
      OpenFilex.open(filePath);
    }
  }

  //doc image tap
  docImageTap(ChatController chatCtrl, docId, document) async {
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
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path +
          decryptMessage(document!.content).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!.content).split("-BREAK-")[1], filePath);
      log("DOC IMAGE PATH $filePath");
      final result = await OpenFilex.open(filePath);

      log("result : $response");
      log("result : $openResult");
      openResult = "type=${result.type}  message=${result.message}";
      OpenFilex.open(filePath);
    }
  }

  //on emoji select
  onEmojiSelect(ChatController chatCtrl, docId, emoji, title) async {
    chatCtrl.selectedIndexId = [];
    chatCtrl.showPopUp = false;
    chatCtrl.enableReactionPopup = false;

    int index = chatCtrl.localMessage.indexWhere((element) {
      log("sss:$docId //${element.time} ");
      return element.time!.contains("-")
          ? element.time!.split("-")[0] == title
          : element.time == title;
    });
    log("indexindex:$index");
    int messageIndex = chatCtrl.localMessage[index].message!
        .indexWhere((element) => element.docId == docId);
    log("indexindex:$messageIndex");
    chatCtrl.localMessage[index].message![messageIndex].emoji = emoji;
    chatCtrl.update();
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.messages)
        .doc(chatCtrl.chatId)
        .collection(collectionName.chat)
        .doc(docId)
        .update({"emoji": emoji});
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(chatCtrl.pId)
        .collection(collectionName.messages)
        .doc(chatCtrl.chatId)
        .collection(collectionName.chat)
        .doc(docId)
        .update({"emoji": emoji});
  }

  onTapLink(chatCtrl, docId, document) async{
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
      launchUrl(Uri.parse(decryptMessage(document!.content).contains("-BREAK-")
          ? decryptMessage(document!.content).split("-BREAK-")[0]
          : (decryptMessage(document!.content))),mode: LaunchMode.externalApplication);
    }
  }

  onEmojiSelectBroadcast(
      BroadcastChatController chatCtrl, docId, emoji, title) async {
    log("ddff");
    chatCtrl.selectedIndexId = [];
    chatCtrl.showPopUp = false;
    chatCtrl.enableReactionPopup = false;
    chatCtrl.update();

    int index =
    chatCtrl.localMessage.indexWhere((element) => element.time == title);

    int messageIndex = chatCtrl.localMessage[index].message!
        .indexWhere((element) => element.docId == docId);
    chatCtrl.localMessage[index].message![messageIndex].emoji = emoji;
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.broadcastMessage)
        .doc(chatCtrl.pId)
        .collection(collectionName.chat)
        .doc(docId)
        .update({"emoji": emoji});
    List receiver = chatCtrl.pData;

    receiver.asMap().entries.forEach((element) async{
      if(element.value["id"] != appCtrl.user['id']){
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(element.value["id"])
            .collection(collectionName.groupMessage)
            .doc(chatCtrl.pId)
            .collection(collectionName.chat)
            .doc(docId)
            .update({"emoji": emoji});
      }
    });
    chatCtrl.update();
    log("LLLLL : ${chatCtrl.localMessage[index].message![messageIndex].emoji}");
  }

}
