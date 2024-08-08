import 'dart:developer';
import 'dart:io';
import '../../config.dart';
import '../bottom_controllers/picker_controller.dart';
import '../common_controllers/all_permission_handler.dart';
import '../recent_chat_controller.dart';

class AddParticipantsController extends GetxController {
  List selectedContact = [];
  List existsUser = [];
  dynamic selectedData;
  List newContact = [];
  List contactList = [];
  final formKey = GlobalKey<FormState>();
  File? image;
  XFile? imageFile;
  bool isLoading = false, isGroup = true;
  dynamic user;
  int counter = 0;
  String imageUrl = "", groupId = "";
  TextEditingController txtGroupName = TextEditingController();
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());
  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());

  //refresh and get contact
  Future<void> refreshContacts() async {
    isLoading = true;
    update();
    user = appCtrl.storage.read(session.user) ?? "";
    update();

  }



// Dismiss KEYBOARD
  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  //add group bottom sheet
  addGroupBottomSheet() async {

    existsUser = [];
    log("ADD PARTICIPANTS1 $isGroup");
    if (isGroup) {
      await FirebaseFirestore.instance
          .collection(collectionName.groups)
          .doc(groupId)
          .get()
          .then((value) async {
        if (value.exists) {
          selectedContact.asMap().entries.forEach((data) {
            existsUser.add(data.value);
          });
          log("AFTER ADD : $existsUser");
          update();
          await FirebaseFirestore.instance
              .collection(collectionName.groups)
              .doc(groupId)
              .update({"users": existsUser}).then((value)async {
            Get.back();
            final chatCtrl = Get.isRegistered<GroupChatMessageController>()
                ? Get.find<GroupChatMessageController>()
                : Get.put(GroupChatMessageController());
            chatCtrl.getPeerStatus();
            chatCtrl.userList = existsUser;
            chatCtrl.update();
            for (var i = 0; i < existsUser.length; i++) {
              if (chatCtrl.nameList != "") {
                chatCtrl.nameList = "${chatCtrl.nameList}, ${chatCtrl.pData[i]["name"]}";
              } else {
                chatCtrl.nameList = chatCtrl.pData[i]["name"];
              }
            }

            await FirebaseFirestore.instance
                .collection(
                collectionName.users).doc(
                appCtrl.user["id"])
                .collection(
                collectionName.chats)
                .where("groupId",
                isEqualTo: chatCtrl.pId).limit(
                1).get().then((
                chatBroadcast) async {
              if (chatBroadcast.docs
                  .isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection(
                    collectionName.users).doc(
                    appCtrl.user["id"])
                    .collection(
                    collectionName.chats)
                    .doc(
                    chatBroadcast.docs[0].id)
                    .update(
                    {"receiverId": existsUser});
              }
            });



            chatCtrl.update();
            selectedContact = [];
            update();

            final RecentChatController recentChatController =
            Provider.of<RecentChatController>(Get.context!,
                listen: false);
            log("INIT PAGE");

            recentChatController.getModel(appCtrl.user);
          });
        }
      });
    } else {
      await FirebaseFirestore.instance
          .collection(collectionName.broadcast)
          .doc(groupId)
          .get()
          .then((value) async{
        if (value.exists) {
          selectedContact.asMap().entries.forEach((data) {
            existsUser.add(data.value);
          });
          log("AFTER ADD : $existsUser");
          update();
          await  FirebaseFirestore.instance
              .collection(collectionName.broadcast)
              .doc(groupId).update({"users": existsUser}).then((value)async {
            Get.back();
            final chatCtrl = Get.isRegistered<BroadcastChatController>()
                ? Get.find<BroadcastChatController>()
                : Get.put(BroadcastChatController());
            chatCtrl.getBroadcastData();
            existsUser = existsUser;
            for (var i = 0; i < chatCtrl.pData.length; i++) {
              if (chatCtrl.nameList != "") {
                chatCtrl.nameList = "${chatCtrl.nameList}, ${chatCtrl.pData[i]["name"]}";
              } else {
                chatCtrl.nameList = chatCtrl.pData[i]["name"];
              }
            }

            Get.back();
            Get.back();

            await FirebaseFirestore.instance
                .collection(
                collectionName.users).doc(
                appCtrl.user["id"])
                .collection(
                collectionName.chats)
                .where("broadcastId",
                isEqualTo: chatCtrl.pId).limit(
                1).get().then((
                chatBroadcast) async {
              if (chatBroadcast.docs
                  .isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection(
                    collectionName.users).doc(
                    appCtrl.user["id"])
                    .collection(
                    collectionName.chats)
                    .doc(
                    chatBroadcast.docs[0].id)
                    .update(
                    {"receiverId": existsUser});
              }
            });

          });
        }
      });
    }
  }

  //check chat available with contacts
  Future<List> checkChatAvailable() async {
    final user = appCtrl.storage.read(session.user);
    selectedContact.asMap().entries.forEach((e) async {
      log("e.value : ${e.value["chatId"]}");
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .collection(collectionName.chats)
          .where("isOneToOne", isEqualTo: true)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.asMap().entries.forEach((element) {
         if (element.value.data()["senderId"] == user["id"] &&
                    element.value.data()["receiverId"] == e.value["id"] ||
                element.value.data()["senderId"] == e.value["id"] &&
                    element.value.data()["receiverId"] == user["id"]) {
              e.value["chatId"] = element.value.data()["chatId"];
              update();
              if (!newContact.contains(e.value)) {
                newContact.add(e.value);
              }
            } else {
              e.value["chatId"] = null;
              if (!newContact.contains(e.value)) {
                newContact.add(e.value);
              }
            }
          });
        } else {
          e.value["chatId"] = null;
          if (!newContact.contains(e.value)) {
            newContact.add(e.value);
          }
        }
        update();
      });
    });

    return newContact;
  }

  //select user function
  selectUserTap( value) {
    var data = {
      "id": value.id,
      "name": value.name,
      "phone": value.phone,
      "image": value.image
    };
    bool exists = selectedContact.any((file) => file["phone"] == data["phone"]);
    log("exists : $exists");
    if (exists) {
      selectedContact.removeWhere(
        (element) => element["phone"] == data["phone"],
      );
    } else {
      /* if(selectedContact.length < appCtrl.usageControlsVal!.groupMembersLimit!) {

      }else{
        snackBarMessengers(message: "You can added only ${isGroup ? appCtrl.usageControlsVal!.groupMembersLimit! :appCtrl.usageControlsVal!.broadCastMembersLimit!} Members in the group");
      }*/
      selectedContact.add(data);
    }

    update();
  }

  //select user function
  alreadyExist( value) {
log("PHONE : $value");
    var data = {
      "id": value["id"],
      "name": value["name"],
      "phone": value["phone"],
      "image": value["image"]
    };
    bool exists = selectedContact.any((file) => file["phone"] == data["phone"]);
    log("exists : $exists");
    if (exists) {
      selectedContact.removeWhere(
            (element) => element["phone"] == data["phone"],
      );
    } else {
      /* if(selectedContact.length < appCtrl.usageControlsVal!.groupMembersLimit!) {

      }else{
        snackBarMessengers(message: "You can added only ${isGroup ? appCtrl.usageControlsVal!.groupMembersLimit! :appCtrl.usageControlsVal!.broadCastMembersLimit!} Members in the group");
      }*/
      selectedContact.add(data);
    }

    update();
  }


  @override
  void onReady() {
// TODO: implement onReady
    var data = Get.arguments ?? "";
    existsUser = data["exitsUser"];
    groupId = data["groupId"];
    isGroup = data["isGroup"] ?? true;
    //refreshContacts();
    log("ADD PARTICIPANTS $data");

    selectedContact =[];
    existsUser.asMap().forEach((key, value) {
      log("data : ${value["phone"] }");
      alreadyExist(value);
    });
    update();
    super.onReady();
  }
}
