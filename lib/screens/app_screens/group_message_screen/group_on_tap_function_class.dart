
import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../config.dart';
import '../../../widgets/common_photo_view.dart';

class GroupOnTapFunctionCall {
  //contentTap
  contentTap(GroupChatMessageController chatCtrl, docId) {

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
  }

  //image tap
  imageTap(GroupChatMessageController chatCtrl, docId, document) async {
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
      /* if (chatCtrl.selectedIndexId.isNotEmpty || chatCtrl.enableReactionPopup) {
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
      log("result : $response");
      log("result : $result");


    }*/
    }
  }

  //location tap
  locationTap(GroupChatMessageController chatCtrl, docId, document) {
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
      launchUrl(Uri.parse(decryptMessage(document!.content)));
    }
  }

  //pdf tap
  pdfTap(GroupChatMessageController chatCtrl, docId, document) async {
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
  docTap(GroupChatMessageController chatCtrl, docId, document) async {
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
  excelTap(GroupChatMessageController chatCtrl, docId, document) async {
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
  docImageTap(GroupChatMessageController chatCtrl, docId, document) async {
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

  //on emoji select
  onEmojiSelect(GroupChatMessageController chatCtrl,docId,emoji,title) async {
    chatCtrl.selectedIndexId = [];
    chatCtrl.showPopUp = false;
    chatCtrl.enableReactionPopup = false;
    chatCtrl.update();
    int index = chatCtrl.localMessage.indexWhere((element) =>( element.time!.contains("-other") ? element.time!.replaceAll("-other", "") :element.time) == title);


    int messageIndex =   chatCtrl.localMessage[index].message!.indexWhere((element) => element.docId == docId);
    chatCtrl.localMessage[index].message![messageIndex].emoji = emoji;
    chatCtrl.update();

    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.groupMessage)
        .doc(chatCtrl.pId)
        .collection(collectionName.chat)
        .doc(docId)
        .update({"emoji": emoji});


    List receiver = chatCtrl.pData["groupData"]["users"];

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
  }
}
