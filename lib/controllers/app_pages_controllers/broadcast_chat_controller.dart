import 'dart:async';
import 'dart:developer';
import 'dart:io';


import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:dartx/dartx_io.dart';
import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';


import '../../config.dart';
import '../../screens/app_screens/broadcast_chat/layouts/broadcast_delete_alert.dart';
import '../../screens/app_screens/broadcast_chat/layouts/broadcast_file_list.dart';
import '../../screens/app_screens/broadcast_chat/layouts/broadcast_sender.dart';
import '../../screens/app_screens/chat_message/chat_message_api.dart';
import '../../screens/app_screens/chat_message/layouts/audio_recording_plugin.dart';
import '../../screens/app_screens/select_contact_screen/fetch_contacts.dart';
import '../../widgets/reaction_pop_up/emoji_picker_widget.dart';
import '../bottom_controllers/picker_controller.dart';
import '../common_controllers/all_permission_handler.dart';

class BroadcastChatController extends GetxController {
  String? pId,
      id,
      chatId,
      pName,
      groupId,
      imageUrl,
      peerNo,
      status,
      statusLastSeen,
      videoUrl,
      blockBy;
  dynamic message, userData, broadData;
  List<File> selectedImages = [];
  dynamic selectedWallpaper;

  List pData = [];
  List selectedIndexId = [];
  List newpData = [], userList = [], searchUserList = [];
  bool positionStreamStarted = false;
  bool isUserAvailable = true;
  bool isTextBox = false, isThere = false;
  bool isShowSticker = false;
  XFile? imageFile;
  XFile? videoFile;
  File? image;
  int totalUser = 0;
  String nameList = "";
  Offset tapPosition = Offset.zero;
  File? video;
  bool? isLoading = true;
  bool typing = false, isBlock = false;
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());
  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textNameController = TextEditingController();
  TextEditingController textSearchController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  late encrypt.Encrypter cryptor;
  final iv = encrypt.IV.fromLength(8);
  List newContact = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allMessages = [];
  StreamSubscription? messageSub;
  List<DateTimeChip> localMessage = [];
  bool enableReactionPopup = false,showPopUp = false;
  List broadcastOptionsList = [];

  List mediaList = [
    appFonts.mediaFile.tr,
    appFonts.documentFile.tr,
    appFonts.linkFile.tr
  ];

  //delete chat layout
  buildPopupDialog() async {
    await showDialog(
        context: Get.context!, builder: (_) => const BroadCastDeleteAlert());
  }

  @override
  void onReady() {
    // TODO: implement onReady
    selectedWallpaper =
        appCtrl.storage.read("backgroundImage") ?? eImageAssets.bg2;
    broadcastOptionsList = appArray.broadcastOptionList;
    groupId = '';
    isLoading = false;
    imageUrl = '';
    userData = appCtrl.storage.read(session.user);
    var data = Get.arguments;

    broadData = data["data"];
    pId = data["broadcastId"];
    pData = broadData["receiverId"];
    newContact = data["newContact"] ?? [];
    pName = broadData["name"] ?? "";
    textNameController.text = pName!;
    log("newContact : ${newContact.length}");
    totalUser = pData.length;

    textEditingController.addListener(() {
      update();
    });

    for (var i = 0; i < pData.length; i++) {
      if (nameList != "") {
        nameList = "$nameList, ${pData[i]["name"]}";
      } else {
        nameList = pData[i]["name"];
      }
    }
    update();

    getBroadcastData();

    super.onReady();
  }

  showBottomSheet() => EmojiPickerWidget(
      controller: textEditingController,
      onSelected: (emoji) {
        textEditingController.text + emoji;
      });

  Future<void> checkPermission( String type, int index) async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }else{

      audioRecording(type, index);
    }
  }

  //pick up contact and share
  saveContactInChat() async {
    log("PREF ${appCtrl.pref}");
    PermissionStatus permissionStatus =
    await permissionHandelCtrl.getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      isLoading = true;
      update();
      Get.to(()=>  FetchContact(prefs: appCtrl.pref), arguments: true)!
          .then((value) async {
        if (value != null) {
          var contact = value;
          log("ccc : $contact");
          isLoading = false;
          update();
          onSendMessage(
              '${contact["name"]}-BREAK-${contact["number"]}-BREAK-${contact["photo"]}',
              MessageType.contact);
        }
      });
    } else {
      isLoading = false;
      update();
      permissionHandelCtrl.handleInvalidPermissions(permissionStatus);
    }
    update();
  }

  //get broad cast data
  getBroadcastData() async {

    messageSub =  FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.broadcastMessage)
        .doc(pId)
        .collection(collectionName.chat)
        .snapshots()
        .listen((event) async {
      allMessages = event.docs;
      update();
      ChatMessageApi().getLocalBroadcastMessage();

      isLoading = false;
      update();
    });
    if (newContact.isNotEmpty) {

      Encrypted encrypteded = encryptFun("You created this broadcast");
      String encrypted = encrypteded.base64;
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .collection(collectionName.broadcastMessage)
          .doc(pId)
          .collection(collectionName.chat)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'sender': appCtrl.user["id"],
        'senderName': appCtrl.user["name"],
        'receiver': newContact,
        'content': encrypted,
        "broadcastId": pId,
        'type': MessageType.messageType.name,
        'messageType': "sender",
        "status": "",
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.broadcastMessage)
        .doc(chatId)
        .collection(collectionName.chat)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        allMessages = value.docs;
        update();
        log("allMessages ::: $allMessages");
        ChatMessageApi().getLocalBroadcastMessage();
        update();
        isLoading = false;
        update();
      }
    });
    await FirebaseFirestore.instance
        .collection(collectionName.broadcast)
        .doc(pId)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data().toString().contains('backgroundImage')) {
          broadData["backgroundImage"] = value.data()!["backgroundImage"] ?? "";
        } else {
          broadData["backgroundImage"] = "";
        }
      } else {
        broadData["backgroundImage"] = "";
      }
      broadData["users"] = value.data()!["users"] ?? [];
    });

    update();
  }

  //update typing status
  setTyping() async {
    firebaseCtrl.setIsActive();
  }

  //share document
  documentShare() async {
    pickerCtrl.dismissKeyboard();
    Get.back();

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    log("RESULT $result");
    if (result != null) {
      isLoading = true;
      update();
      File file = File(result.files.single.path.toString());
      String fileName =
          "${file.name}-${DateTime.now().millisecondsSinceEpoch.toString()}";
      imageUrl = await pickerCtrl.uploadImage(file, fileNameText: fileName);
      onSendMessage(
          "${result.files.single.name}-BREAK-$imageUrl",
          result.files.single.path.toString().contains(".mp4")
              ? MessageType.video
              : result.files.single.path.toString().contains(".mp3")
                  ? MessageType.audio
                  : MessageType.doc);
    }
  }

  //location share
  locationShare() async {
    pickerCtrl.dismissKeyboard();
    Get.back();
    isLoading = true;
    update();
    await permissionHandelCtrl.getCurrentPosition().then((value) async {
      var locationString =
          'https://www.google.com/maps/search/?api=1&query=${value!.latitude},${value.longitude}';
      onSendMessage(locationString, MessageType.location);
      isLoading = false;
      update();
      return null;
    });
  }

  //share media
  shareMedia(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: appCtrl.appTheme.trans,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.r25))),
        builder: (BuildContext context) {
          // return your layout
          return  SizedBox(
            height: Sizes.s295,
            width: MediaQuery.of(Get.context!).size.width,
            child: Card(
              color: appCtrl.appTheme.white,
              margin: const EdgeInsets.only(left: Insets.i12,right: Insets.i12,bottom: Insets.i60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child:const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: BroadcastFileRowList(),
              ),
            ),
          );
        });
  }

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    var file = File(imageFile!.path);
    UploadTask uploadTask = reference.putFile(file);
    uploadTask.then((res) {
      isLoading = true;
      update();
      res.ref.getDownloadURL().then((downloadUrl) {
        imageUrl = downloadUrl;
        isLoading = false;
        onSendMessage(imageUrl!, MessageType.image);
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
  }

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadMultipleFile(File imageFile, MessageType messageType) async {
    imageFile = imageFile;
    update();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    var file = File(imageFile.path);
    UploadTask uploadTask = reference.putFile(file);
    uploadTask.then((res) {
      isLoading = true;
      update();
      res.ref.getDownloadURL().then((downloadUrl) async {
        imageUrl = downloadUrl;
        isLoading = false;
        onSendMessage(imageUrl!, messageType);
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
  }

  //send video after recording or pick from media
  videoSend() async {
    videoFile = pickerCtrl.videoFile;
    isLoading = true;
    update();
    const Duration(seconds: 2);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    var file = File(videoFile!.path);
    UploadTask uploadTask = reference.putFile(file);

    uploadTask.then((res) {
      isLoading = false;
      update();
      res.ref.getDownloadURL().then((downloadUrl) {
        videoUrl = downloadUrl;
        isLoading = false;
        onSendMessage(videoUrl!, MessageType.video);
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
  }


  //audio recording
  void audioRecording( String type, int index) {

    showModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      backgroundColor: appCtrl.appTheme.trans,
      builder: (BuildContext bc) {
        return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: appCtrl.appTheme.white,
                borderRadius: BorderRadius.circular(10)),
            child: AudioRecordingPlugin(type: type, index: index));
      },
    ).then((value) async {
      if (value != null) {

        File file = File(value);
        log("file : $file");
        isLoading = true;
        update();
        String fileName =
            "${file.name}-${DateTime.now().millisecondsSinceEpoch.toString()}";
        Reference reference = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = reference.putFile(file);
        TaskSnapshot snap = await uploadTask;
        String downloadUrl = await snap.ref.getDownloadURL();
        log("audioFile : $downloadUrl");
        isLoading = false;
        update();
        onSendMessage(downloadUrl, MessageType.audio);
        log("audioFile : $downloadUrl");
      }
    });
  }

  // SEND MESSAGE CLICK
  void onSendMessage(String content, MessageType type) async {
    if (content.trim() != '') {
      log("HOLLLLAA");
      Encrypted encrypteded = encryptFun(content);
      String encrypted = encrypteded.base64;


      textEditingController.clear();
      await saveMessageInLoop(encrypted, type);
      await Future.delayed(DurationsClass.s4);
      String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
      MessageModel messageModel = MessageModel(
          blockBy:"",
          blockUserId: "",
          broadcastId: chatId,
          chatId: chatId,
          content: encrypted,
          docId: dateTime,
          isBlock: false,
          isBroadcast: false,
          isFavourite: false,
          isSeen: false,
          messageType: "sender",
          receiverList: pData,
          sender: appCtrl.user["id"],
          timestamp: dateTime,
          type: type.name);
      bool isEmpty =
          localMessage.where((element) => element.time == "Today").isEmpty;
      if (isEmpty) {
        List<MessageModel>? message = [];
        if (message.isNotEmpty) {
          message.add(messageModel);
          message[0].docId = dateTime;
        } else {
          message = [messageModel];
          message[0].docId = dateTime;
        }
        DateTimeChip dateTimeChip =
        DateTimeChip(time: getDate(dateTime), message: message);
        localMessage.add(dateTimeChip);
      } else {
        log("CHECKKKK");

        int index =
        localMessage.indexWhere((element) => element.time == "Today");

        if (!localMessage[index].message!.contains(messageModel)) {
          localMessage[index].message!.add(messageModel);
        }
      }
      log("CONYE : $localMessage");
      update();
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userData["id"])
          .collection(collectionName.chats)
          .where("broadcastId", isEqualTo: pId)
          .get()
          .then((snap) {
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userData["id"])
            .collection(collectionName.chats)
            .doc(snap.docs[0].id)
            .update({
          "receiverId": pData,
          "updateStamp": dateTime,
          "lastMessage": encrypted
        });
      });

      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userData["id"])
          .collection(collectionName.broadcastMessage)
          .doc(pId)
          .collection(collectionName.chat)
          .doc(dateTime)
          .set({
        'sender': userData["id"],
        'senderName': userData["name"],
        'receiver': pData,
        'content': encrypted,
        "broadcastId": pId,
        'type': type.name,
        'messageType': "sender",
        "status": "",
        'timestamp': dateTime,
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userData["id"])
            .collection(collectionName.chats)
            .where("broadcastId", isEqualTo: pId)
            .get();
      });

      Get.forceAppUpdate();
    }
  }

  saveMessageInLoop(content, MessageType type) async {
    pData.asMap().entries.forEach((element) async {
      if (element.value["id"] != appCtrl.user["id"]) {
        log("CHATID : ${element.value["chatId"]}");
        if (element.value["chatId"] != null) {
          newpData.add(element.value);
          update();
          await ChatMessageApi()
              .saveMessage(
              element.value["chatId"],
              pId,
              content,
              type,
              DateTime.now().millisecondsSinceEpoch.toString(),
              userData["id"],
              isBroadcast: true)
              .then((value) async {
            await ChatMessageApi().saveMessageInUserCollection(
              element.value["id"],
              element.value["id"],
              element.value["chatId"],
              content,

              userData["id"],
              userData["name"],type, isBroadcast: true,);
          });
        } else {
          final now = DateTime.now();
          String? newChatId = now.microsecondsSinceEpoch.toString();
          update();
          element.value["chatId"] = newChatId;
          await ChatMessageApi()
              .saveMessage(
              element.value["chatId"],
              pId,
              content,
              type,
              DateTime.now().millisecondsSinceEpoch.toString(),
              userData["id"],
              isBroadcast: true)
              .then((value) async {
            newpData.add(element.value);
            update();
            await ChatMessageApi().saveMessageInUserCollection(
              element.value["id"],
              element.value["id"],
              element.value["chatId"],
              content,

              userData["id"],
              userData["name"],type, isBroadcast: true,);
          });
        }
      }
    });
  }



  Widget timeLayout(DateTimeChip document) {
    List<MessageModel> newMessageList = document.message!.reversed.toList();
    return Column(
      children: [
        Text(
                document.time!.contains("-other")
                    ? document.time!.split("-other")[0]
                    : document.time!,
                style:
                    AppCss.manropeMedium14.textColor(appCtrl.appTheme.greyText))
            .paddingOnly(bottom: Insets.i10),
        ...newMessageList.asMap().entries.map((e) {
          return buildItem( e.key,
              e.value,
              e.value.docId,
              document.time!.contains("-other")
                  ? document.time!.split("-other")[0]
                  : document.time!);
        })
      ],
    );
  }

// BUILD ITEM MESSAGE BOX FOR RECEIVER AND SENDER BOX DESIGN
  Widget buildItem(int index, MessageModel document, documentId, title) {

    if (document.sender == userData["id"]) {
      return BroadcastSenderMessage(
        document: document,
        index: index,
        docId: documentId,
        title: title,
      );
    } else {
      // RECEIVER MESSAGE
      return Container();
    }
  }

  // ON BACK PRESS
  onBackPress() {
    FirebaseFirestore.instance
        .collection(
            'users') // Your collection name will be whatever you have given in firestore database
        .doc(userData["id"])
        .update({'status': "Online"});
    Get.back();
  }

  //ON LONG PRESS
  onLongPressFunction(docId) {
    showPopUp = true;
    enableReactionPopup = true;

    if (!selectedIndexId.contains(docId)) {
      if (showPopUp == false) {
        selectedIndexId.add(docId);
      } else {
        selectedIndexId = [];
        selectedIndexId.add(docId);
      }
      update();
    }
    update();
  }

  deleteBroadCast() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.broadcastMessage)
        .doc(pId)
        .delete()
        .then((value) async {
      await FirebaseFirestore.instance
          .collection(collectionName.broadcast)
          .doc(pId)
          .delete()
          .then((value) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(appCtrl.user["id"])
            .collection(collectionName.chats)
            .where("broadcastId", isEqualTo: pId)
            .limit(1)
            .get()
            .then((broadcastVal)async {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(appCtrl.user["id"])
              .collection(collectionName.chats)
              .doc(broadcastVal.docs[0].id)
              .delete();
        });
        Get.back();
        Get.back();
      });
    });
  }

  //check contact in firebase and if not exists
  saveContact(userData, {message}) async {

    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userData.uid)
        .collection("chats")
        .where("isOneToOne", isEqualTo: true)
        .get()
        .then((value) {
          log("UID!!! ${userData.uid}");
      bool isEmpty = value.docs
          .where((element) =>
              element.data()["senderId"] == userData.uid ||
              element.data()["receiverId"] == userData.uid)
          .isNotEmpty;
      if (!isEmpty) {
        var data = {"chatId": "0", "data": userData, "message": message};

        Get.back();
        Get.toNamed(routeName.chatLayout, arguments: data);
        final chatCtrl = Get.isRegistered<ChatController>()
            ? Get.find<ChatController>()
            : Get.put(ChatController());
        chatCtrl.onReady();
        chatCtrl.update();
      } else {
        value.docs.asMap().entries.forEach((element) {
          if (element.value.data()["senderId"] == userData.uid ||
              element.value.data()["receiverId"] == userData.uid) {
            var data = {
              "chatId": element.value.data()["chatId"],
              "data": userData,
              "message": message
            };
            Get.back();
            Get.toNamed(routeName.chatLayout, arguments: data);
            final chatCtrl = Get.isRegistered<ChatController>()
                ? Get.find<ChatController>()
                : Get.put(ChatController());
                chatCtrl.onReady();
                chatCtrl.update();
          }
        });
      }
    });
  }

  getTapPosition(TapDownDetails tapDownDetails) {
    RenderBox renderBox = Get.context!.findRenderObject() as RenderBox;
    update();
    tapPosition = renderBox.globalToLocal(tapDownDetails.globalPosition);
  }

  showContextMenu(context, value, snapshot) async {
    RenderObject? overlay = Overlay.of(context).context.findRenderObject();
    final result = await showMenu(
        color: appCtrl.appTheme.white,
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 10, 10),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height),
        ),
        items: [
          _buildPopupMenuItem("Chat $pName", 0),
          _buildPopupMenuItem("Remove $pName", 1),
        ]);
    if (result == 0) {
      var data = {
        "uid": value["id"],
        "username": value["name"],
        "phoneNumber": value["phone"],
        "image": snapshot.data!.data()!["image"],
        "description": snapshot.data!.data()!["statusDesc"],
        "isRegister": true,
      };
      UserContactModel userContactModel = UserContactModel.fromJson(data);
      saveContact(userContactModel);
    } else {
      removeUserFromGroup(value, snapshot);
    }
  }

  removeUserFromGroup(value, snapshot) async {
    await FirebaseFirestore.instance
        .collection(collectionName.broadcast)
        .doc(pId)
        .get()
        .then((group) {
      if (group.exists) {
        List user = group.data()!["users"];
        user.removeWhere((element) => element["phone"] == value["phone"]);
        update();
        FirebaseFirestore.instance
            .collection(collectionName.broadcast)
            .doc(pId)
            .update({"users": user}).then((value) {
          getBroadcastData();
        });
      }
    });
  }

  PopupMenuItem _buildPopupMenuItem(String title, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(children: [
        Text(title,
            style:
                AppCss.manropeMedium14.textColor(appCtrl.appTheme.darkText))
      ]),
    );
  }


  onEmojiTap(emoji) {
    onSendMessage(emoji, MessageType.text);
  }
}
