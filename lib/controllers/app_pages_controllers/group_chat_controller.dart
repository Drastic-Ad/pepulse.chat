import 'dart:async';
import 'dart:developer' as log;
import 'dart:io';
import 'package:chatzy/models/call_model.dart';
import 'package:chatzy/screens/app_screens/group_message_screen/layouts/group_clear_chat.dart';
import 'package:dartx/dartx_io.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import '../../config.dart';
import '../../screens/app_screens/chat_message/chat_message_api.dart';
import '../../screens/app_screens/chat_message/layouts/audio_recording_plugin.dart';
import '../../screens/app_screens/chat_message/layouts/image_picker.dart';
import '../../screens/app_screens/group_message_screen/group_message_api.dart';
import '../../screens/app_screens/group_message_screen/layouts/group_delete_alert.dart';
import '../../screens/app_screens/group_message_screen/layouts/group_file_bottom_sheet.dart';
import '../../screens/app_screens/group_message_screen/layouts/group_profile/exit_group_alert.dart';
import '../../screens/app_screens/group_message_screen/layouts/group_receiver/group_receiver_message.dart';
import '../../screens/app_screens/group_message_screen/layouts/group_sender/sender_message.dart';
import '../../screens/app_screens/select_contact_screen/fetch_contacts.dart';
import '../../widgets/common_note_encrypt.dart';
import '../../widgets/reaction_pop_up/emoji_picker_widget.dart';
import '../bottom_controllers/picker_controller.dart';
import '../common_controllers/all_permission_handler.dart';

class GroupChatMessageController extends GetxController {
  String? pId,
      id,
      documentId,
      pName,
      groupImage,
      groupId,
      imageUrl,
      status,
      statusLastSeen,
      nameList,
      videoUrl,
      chatId,
      backgroundImage;
  dynamic pData, allData;
  dynamic selectedWallpaper;
  List message = [];
  bool positionStreamStarted = false;
  bool isFilter = false;
  bool isCallFilter = false;
  int pageSize = 20;
  String? wallPaperType;
  XFile? imageFile, videoFile;
  List userList = [];
  List searchUserList = [];
  List selectedIndexId = [];
  List searchChatId = [];
  List<File> selectedImages = [];
  File? image;
  bool isLoading = true,
      isTextBox = false,
      isDescTextBox = false,
      isThere = false,
      typing = false,
      isChatSearch = false;
  dynamic user;
  bool isShowSticker = false;
  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textNameController = TextEditingController();
  TextEditingController textDescController = TextEditingController();
  TextEditingController textSearchController = TextEditingController();
  TextEditingController txtChatSearch = TextEditingController();
  ScrollController listScrollController =
      ScrollController(initialScrollOffset: 0);
  FocusNode focusNode = FocusNode();
  bool enableReactionPopup = false;
  bool showPopUp = false;
  int? count;
  StreamSubscription? messageSub;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allMessages = [];
  List<DateTimeChip> localMessage = [];
  late encrypt.Encrypter cryptor;
  Offset tapPosition = Offset.zero;
  final iv = encrypt.IV.fromLength(8);
  List groupOptionLists = [];

  List mediaList = [
    appFonts.mediaFile,
    appFonts.documentFile,
    appFonts.linkFile
  ];

  @override
  void onReady() {
    // TODO: implement onReady
    groupOptionLists = appArray.groupOptionList;
    user = appCtrl.storage.read(session.user);
    id = user["id"];
    isLoading = false;
    imageUrl = '';
    listScrollController = ScrollController(initialScrollOffset: 0);

    var data = Get.arguments;
    pData = data;
    if (pData != null) {
      pId = pData["message"]["groupId"];
      pName = pData["groupData"]["name"];
      groupImage = pData["groupData"]["image"];
      userList = pData["message"]["receiverId"];
    }
    textNameController.text = pName!;
    update();
    getPeerStatus();

    update();

    super.onReady();
  }

  showBottomSheet() => EmojiPickerWidget(
      controller: textEditingController,
      onSelected: (emoji) {
        textEditingController.text + emoji;
      });

  //pick up contact and share
  saveContactInChat() async {
    PermissionStatus permissionStatus =
        await permissionHandelCtrl.getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Get.to(() => FetchContact(prefs: appCtrl.pref), arguments: true)!
          .then((value) async {
        if (value != null) {
          var contact = value;
          isLoading = false;
          update();
          onSendMessage(
              '${contact["name"]}-BREAK-${contact["number"]}-BREAK-${contact["photo"]}',
              MessageType.contact);
        }
      });
    } else {
      permissionHandelCtrl.handleInvalidPermissions(permissionStatus);
    }
    update();
  }

//get group data
  getPeerStatus() async {
    nameList = "";
    nameList = null;

    FirebaseFirestore.instance
        .collection(collectionName.groups)
        .doc(pId)
        .get()
        .then((value) async {
      if (value.exists) {
        allData = value.data();
        update();
        backgroundImage = value.data()!['backgroundImage'] ?? "";
        List receiver = pData["groupData"]["users"] ?? [];

        nameList = (receiver.length - 1).toString();
        if (pData["message"]["senderId"] != user["id"]) {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(appCtrl.user["id"])
              .collection(collectionName.groupMessage)
              .doc(pId)
              .collection(collectionName.chat)
              .get()
              .then((value) {
            value.docs.asMap().entries.forEach((element) async {
              if (element.value.exists) {
                if (element.value.data()["sender"] != user["id"]) {
                  List seenMessageList =
                      element.value.data()["seenMessageList"] ?? [];

                  bool isAvailable = seenMessageList
                      .where((availableElement) =>
                          availableElement["userId"] == user["id"])
                      .isNotEmpty;
                  if (!isAvailable) {
                    var data = {
                      "userId": user["id"],
                      "date": DateTime.now().millisecondsSinceEpoch
                    };

                    seenMessageList.add(data);
                  }
                  await FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(appCtrl.user["id"])
                      .collection(collectionName.groupMessage)
                      .doc(pId)
                      .collection(collectionName.chat)
                      .doc(element.value.id)
                      .update({"seenMessageList": seenMessageList});

                  await FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(user["id"])
                      .collection(collectionName.chats)
                      .where("groupId", isEqualTo: pId)
                      .limit(1)
                      .get()
                      .then((userChat) async {
                    if (userChat.docs.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection(collectionName.users)
                          .doc(user["id"])
                          .collection(collectionName.chats)
                          .doc(userChat.docs[0].id)
                          .update({"seenMessageList": seenMessageList});
                    }
                  });
                }
              }
            });
          });
        }
      }
    });

    messageSub = FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.groupMessage)
        .doc(pId)
        .collection(collectionName.chat)
        .snapshots()
        .listen((event) async {
      allMessages = event.docs;
      update();

      ChatMessageApi().getLocalGroupMessage();

      isLoading = false;
      update();
    });
    isLoading = false;
    update();
    user = appCtrl.storage.read(session.user);
    if (backgroundImage != null || backgroundImage != "") {
      FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .get()
          .then((value) {
        if (value.exists) {
          backgroundImage = value.data()!["backgroundImage"] ?? "";
        }
        update();
      });
    }

    FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.groupMessage)
        .doc(pId)
        .collection(collectionName.chat)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        documentId = value.docs[0].id;
      }
    });

    return status;
  }

  onTapStatus() {
    callAlertDialog(
        title: appFonts.selectCallType,
        list: appArray.callList,
        onTap: (int index) async {
          if (index == 0) {
            await permissionHandelCtrl
                .getCameraMicrophonePermissions()
                .then((value) {
              if (value == true) {
                audioAndVideoCall(false);
              }
            });
          } else {
            await permissionHandelCtrl
                .getCameraMicrophonePermissions()
                .then((value) {
              if (value == true) {
                audioAndVideoCall(true);
              }
            });
          }
        });
  }

  //clear dialog
  clearChatConfirmation() async {
    Get.generalDialog(
      pageBuilder: (context, anim1, anim2) {
        return const GroupClearDialog();
      },
    );
  }

  onTapDots() {
    isFilter = !isFilter;
    update();
  }

  onTapCallDots() {
    isCallFilter = !isCallFilter;
    update();
  }

  //group call
  audioAndVideoCall(isVideoCall) async {
    try {
      var userData = appCtrl.storage.read(session.user);
      Map<String, dynamic>? response =
          await firebaseCtrl.getAgoraTokenAndChannelName();

      log.log("FUNCTION ; $response");
      if (response != null) {
        String channelId = response["channelName"];
        String token = response["agoraToken"];
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        List receiver = pData["groupData"]["users"];

        receiver.asMap().entries.forEach((element) {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(element.value["id"])
              .get()
              .then((snap) async {
            Call call = Call(
                timestamp: timestamp,
                callerId: userData["id"],
                callerName: userData["name"],
                callerPic: userData["image"],
                receiverId: snap.data()!["id"],
                receiverName: snap.data()!["name"],
                receiverPic: snap.data()!["image"],
                callerToken: userData["pushToken"],
                receiverToken: snap.data()!["pushToken"],
                channelId: channelId,
                isVideoCall: isVideoCall,
                isGroup: true,
                groupName: pName,
                receiver: receiver,
                agoraToken: token);

            await FirebaseFirestore.instance
                .collection(collectionName.calls)
                .doc(call.callerId)
                .collection(collectionName.calling)
                .add({
              "timestamp": timestamp,
              "callerId": userData["id"],
              "callerName": userData["name"],
              "callerPic": userData["image"],
              "receiverId": snap.data()!["id"],
              "receiverName": snap.data()!["name"],
              "receiverPic": snap.data()!["image"],
              "callerToken": userData["pushToken"],
              "receiverToken": snap.data()!["pushToken"],
              "hasDialled": true,
              "channelId": channelId,
              "agoraToken": token,
              "isVideoCall": isVideoCall,
            }).then((value) async {
              await FirebaseFirestore.instance
                  .collection(collectionName.calls)
                  .doc(call.receiverId)
                  .collection(collectionName.calling)
                  .add({
                "timestamp": timestamp,
                "callerId": userData["id"],
                "callerName": userData["name"],
                "callerPic": userData["image"],
                "receiverId": snap.data()!["id"],
                "receiverName": snap.data()!["name"],
                "receiverPic": snap.data()!["image"],
                "callerToken": userData["pushToken"],
                "receiverToken": snap.data()!["pushToken"],
                "hasDialled": false,
                "channelId": channelId,
                "agoraToken": token,
                "isVideoCall": isVideoCall
              }).then((value) async {
                call.hasDialled = true;
                if (isVideoCall == false) {
                  firebaseCtrl.sendNotification(
                      title: "Incoming Audio Call...",
                      msg: "${call.callerName} audio call",
                      token: call.receiverToken,
                      pName: call.callerName,
                      image: userData["image"],
                      dataTitle: call.callerName);
                  var data = {
                    "channelName": call.channelId,
                    "call": call,
                    "token": response["agoraToken"]
                  };
                  Get.toNamed(routeName.audioCall, arguments: data);
                } else {
                  firebaseCtrl.sendNotification(
                      title: "Incoming Video Call...",
                      msg: "${call.callerName} video call",
                      token: call.receiverToken,
                      pName: call.callerName,
                      image: userData["image"],
                      dataTitle: call.callerName);

                  var data = {
                    "channelName": call.channelId,
                    "call": call,
                    "token": response["agoraToken"]
                  };

                  Get.toNamed(routeName.videoCall, arguments: data);
                }
              });
            });
          });
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to call");
      }
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      log.log("err :$e");
    }
  }

  //document share
  documentShare() async {
    pickerCtrl.dismissKeyboard();
    Get.back();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      isLoading = true;
      update();
      File file = File(result.files.single.path.toString());
      String fileName =
          "${file.name}-${DateTime.now().millisecondsSinceEpoch.toString()}";
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(file);

      uploadTask.then((res) {
        res.ref.getDownloadURL().then((downloadUrl) {
          imageUrl = downloadUrl;
          isLoading = false;
          onSendMessage(
              "${result.files.single.name}-BREAK-$imageUrl",
              result.files.single.path.toString().contains(".mp4")
                  ? MessageType.video
                  : result.files.single.path.toString().contains(".mp3")
                      ? MessageType.audio
                      : MessageType.doc);
          update();
        }, onError: (err) {
          isLoading = false;
          update();
          Fluttertoast.showToast(msg: 'Not Upload');
        });
      });
    }
  }

  //location share
  locationShare() async {
    pickerCtrl.dismissKeyboard();
    Get.back();

    await permissionHandelCtrl.getCurrentPosition().then((value) async {
      var locationString =
          'https://www.google.com/maps/search/?api=1&query=${value!.latitude},${value.longitude}';
      onSendMessage(locationString, MessageType.location);
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
              BorderRadius.vertical(top: Radius.circular(AppRadius.r25)),
        ),
        builder: (BuildContext context) {
          return const GroupBottomSheet();
        });
  }

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadFile({isGroupImage = false, groupImageFile}) async {
    imageFile = pickerCtrl.imageFile;
    update();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    var file = File(!isGroupImage ? imageFile!.path : groupImageFile.path);
    UploadTask uploadTask = reference.putFile(file);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) async {
        imageUrl = downloadUrl;
        isLoading = false;
        if (isGroupImage) {
          await FirebaseFirestore.instance
              .collection(collectionName.groups)
              .doc(pId)
              .update({'image': imageUrl}).then((value) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user["id"])
                .get()
                .then((snap) async {
              groupImage = imageUrl;
              update();
            });
          });
        } else {
          onSendMessage(imageUrl!, MessageType.image);
        }
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

  Future videoSend() async {
    videoFile = pickerCtrl.videoFile;
    update();
    if (videoFile != null) {
      const Duration(seconds: 2);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      var file = File(videoFile!.path);
      UploadTask uploadTask = reference.putFile(file);
      uploadTask.then((res) {
        res.ref.getDownloadURL().then((downloadUrl) {
          videoUrl = downloadUrl;
          isLoading = false;

          pickerCtrl.videoFile = null;

          pickerCtrl.video = null;
          update();
          pickerCtrl.update();
          onSendMessage(videoUrl!, MessageType.video);
          update();
        }, onError: (err) {
          isLoading = false;
          update();
          Fluttertoast.showToast(msg: 'Image is Not Valid');
        });
      }).then((value) {
        videoFile = null;
        pickerCtrl.videoFile = null;

        pickerCtrl.video = null;
        videoUrl = "";
        update();
        pickerCtrl.update();
      });
    }
  }

  //audio recording
  void audioRecording(String type, int index) {
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

        isLoading = true;
        update();
        String fileName =
            "${file.name}-${DateTime.now().millisecondsSinceEpoch.toString()}";
        Reference reference = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = reference.putFile(file);
        TaskSnapshot snap = await uploadTask;
        String downloadUrl = await snap.ref.getDownloadURL();

        isLoading = false;
        update();
        onSendMessage(downloadUrl, MessageType.audio);
      }
    });
  }

  // SEND MESSAGE CLICK
  void onSendMessage(String content, MessageType type, {groupId}) async {
    isLoading = true;
    textEditingController.clear();
    update();
    Encrypted encrypteded = encryptFun(content);
    String encrypted = encrypteded.base64;

    if (content.trim() != '') {
      var user = appCtrl.storage.read(session.user);
      id = user["id"];
      String time = DateTime.now().millisecondsSinceEpoch.toString();
      MessageModel messageModel = MessageModel(
          blockBy: allData != null ? allData["blockBy"] : "",
          blockUserId: allData != null ? allData["blockUserId"] : "",
          chatId: pId,
          content: encrypted,
          docId: time,
          isBlock: false,
          isBroadcast: false,
          isFavourite: false,
          isSeen: false,
          messageType: "sender",
          receiver: pId,
          sender: appCtrl.user["id"],
          timestamp: time,
          type: type.name);
      bool isEmpty =
          localMessage.where((element) => element.time == "Today").isEmpty;
      if (isEmpty) {
        List<MessageModel>? message = [];
        if (message.isNotEmpty) {
          message.add(messageModel);
          message[0].docId = time;
        } else {
          message = [messageModel];
          message[0].docId = time;
        }
        DateTimeChip dateTimeChip =
            DateTimeChip(time: getDate(time), message: message);
        localMessage.add(dateTimeChip);
      } else {
        int index =
            localMessage.indexWhere((element) => element.time == "Today");

        if (!localMessage[index].message!.contains(messageModel)) {
          localMessage[index].message!.add(messageModel);
        }
      }
      await GroupMessageApi().saveGroupMessage(encrypted, type);

      await ChatMessageApi().saveGroupData(id, pId, encrypted, pData, type,groupImage);

      isLoading = false;
      videoFile = null;
      videoUrl = "";
      pickerCtrl.videoFile = null;

      pickerCtrl.video = null;
      update();
      pickerCtrl.update();
      update();
    }
    scrollToBottom();
  }

  void scrollToBottom() {
    if (listScrollController.hasClients) {
      listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  //delete chat layout
  buildPopupDialog() async {
    await showDialog(
        context: Get.context!, builder: (_) => const GroupDeleteAlert());
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
            .paddingOnly(bottom: Insets.i15),
        ...newMessageList.asMap().entries.map((e) {
          return buildItem(
              e.key,
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
  Widget buildItem(int index, MessageModel document, docId, title) {
    return Column(children: [
      document.type == MessageType.note.name
          ? const CommonNoteEncrypt()
          : Container(),
      (document.sender == user["id"])
          ? GroupSenderMessage(
                  document: document,
                  docId: docId,
                  index: index,
                  title: title,
                  currentUserId: user["id"])
              .inkWell(onTap: () {
              enableReactionPopup = false;
              showPopUp = false;
              selectedIndexId = [];
              update();
            })
          : document.sender != user["id"]
              ?
              // RECEIVER MESSAGE
              GroupReceiverMessage(
                  document: document,
                  title: title,
                  index: index,
                  docId: docId,
                ).inkWell(onTap: () {
                  enableReactionPopup = false;
                  showPopUp = false;
                  selectedIndexId = [];
                  update();
                })
              : Container()
    ]);
  }

  // ON BACK PRESS
  onBackPress() {
    appCtrl.isTyping = false;
    appCtrl.update();
    firebaseCtrl.groupTypingStatus(pId, false);
    FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.messages)
        .doc(pId)
        .collection(collectionName.chat)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        if (value.docs.length == 1) {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(appCtrl.user["id"])
              .collection(collectionName.messages)
              .doc(pId)
              .collection(collectionName.chat)
              .doc(value.docs[0].id)
              .delete();
        }
      }
    });
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

  //exit group

  //delete chat layout
  exitGroupDialog() async {
    await showDialog(
        context: Get.context!,
        builder: (_) => ExitGroupAlert(
              name: pName,
            ));
  }

  //delete group
  deleteGroup() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user["id"])
        .collection(collectionName.chats)
        .where("groupId", isEqualTo: pId)
        .limit(1)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(user["id"])
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .delete()
            .then((value) {
          Get.back();
          Get.back();
        });
      }
    });
  }

// GET IMAGE FROM GALLERY
  Future getImage(source) async {
    final ImagePicker picker = ImagePicker();
    imageFile = (await picker.pickImage(source: source))!;

    isLoading = true;
    update();
    if (imageFile != null) {
      update();
      uploadFile(isGroupImage: true, groupImageFile: imageFile);
    }
  }

  //image picker option
  imagePickerOption(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.r25)),
        ),
        builder: (BuildContext context) {
          // return your layout
          return ImagePickerLayout(cameraTap: () {
            getImage(ImageSource.camera);
            Get.back();
          }, galleryTap: () {
            getImage(ImageSource.gallery);
            Get.back();
          });
        });
  }

  Future<void> checkPermission(String typeName, int index) async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    } else {
      audioRecording(typeName, index);
    }
  }

  //check contact in firebase and if not exists
  saveContact(userData, {message}) async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user["id"])
        .collection("chats")
        .where("isOneToOne", isEqualTo: true)
        .get()
        .then((value) {
      bool isEmpty = value.docs
          .where((element) =>
              element.data()["senderId"] == userData["uid"] ||
              element.data()["receiverId"] == userData["uid"])
          .isNotEmpty;
      if (!isEmpty) {
        var data = {"chatId": "0", "data": userData, "message": message};

        Get.back();
        Get.toNamed(routeName.chatLayout, arguments: data);
      } else {
        value.docs.asMap().entries.forEach((element) {
          if (element.value.data()["senderId"] == userData["uid"] ||
              element.value.data()["receiverId"] == userData["uid"]) {
            var data = {
              "chatId": element.value.data()["chatId"],
              "data": userData,
              "message": message
            };
            Get.back();

            Get.toNamed(routeName.chatLayout, arguments: data);
          }
        });

        //
      }
    });
  }

  removeUserFromGroup(value, snapshot) async {
    await FirebaseFirestore.instance
        .collection(collectionName.groups)
        .doc(pId)
        .get()
        .then((group) {
      if (group.exists) {
        List user = group.data()!["users"];
        user.removeWhere((element) => element["phone"] == value["phone"]);
        update();
        FirebaseFirestore.instance
            .collection(collectionName.groups)
            .doc(pId)
            .update({"users": user}).then((value) {
          getPeerStatus();
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

  PopupMenuItem _buildPopupMenuItem(String title, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(children: [
        Text(title.toString().tr,
            style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.darkText))
      ]),
    );
  }

  Widget searchTextField() {
    return TextField(
      controller: txtChatSearch,
      onChanged: (val) async {
        count = null;
        searchChatId = [];
        selectedIndexId = [];
        /* message.asMap().entries.forEach((e) {
          if (decryptMessage(e.value.data()["content"])
              .toLowerCase()
              .contains(val)) {
            if (!searchChatId.contains(e.key)) {
              searchChatId.add(e.key);
            } else {
              searchChatId.remove(e.key);
            }
          }
          update();
        });*/

        localMessage.asMap().entries.forEach((element) {
          element.value.message!.asMap().entries.forEach((e) {
            if (decryptMessage(e.value.content)
                .toString()
                .toLowerCase()
                .contains(txtChatSearch.text)) {
              if (!searchChatId.contains(e.value.docId)) {
                searchChatId.add(e.value.docId);
              } else {
                searchChatId.remove(e.value.docId);
              }
            }
          });
        });
      },

      //Display the keyboard when TextField is displayed
      cursorColor: appCtrl.appTheme.darkText,
      style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.darkText),
      textInputAction: TextInputAction.search,
      //Specify the action button on the keyboard
      decoration: InputDecoration(
        //Style of TextField
        enabledBorder: UnderlineInputBorder(
            //Default TextField border
            borderSide: BorderSide(color: appCtrl.appTheme.darkText)),
        focusedBorder: UnderlineInputBorder(
            //Borders when a TextField is in focus
            borderSide: BorderSide(color: appCtrl.appTheme.darkText)),
        hintText: 'Search', //Text that is displayed when nothing is entered.
      ),
    );
  }

  /*wallPaperConfirmation(image) async {
    Get.generalDialog(
      pageBuilder: (context, anim1, anim2) {
        return GroupChatWallPaper(
          image: image,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
            position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
                .animate(anim1),
            child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }*/

//clear dialog
  /*clearChatConfirmation() async {
    Get.generalDialog(
      pageBuilder: (context, anim1, anim2) {
        return const ClearDialog();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
            position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
                .animate(anim1),
            child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }*/

  onEmojiTap(emoji) {
    onSendMessage(emoji, MessageType.text);
  }
}
