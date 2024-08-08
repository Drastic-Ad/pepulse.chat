import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:async/async.dart';
import 'package:chatzy/controllers/bottom_controllers/picker_controller.dart';
import 'package:dartx/dartx_io.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:light_compressor/light_compressor.dart' as light;
import 'package:localstorage/localstorage.dart';
import 'package:video_compress/video_compress.dart';
import '../../config.dart';
import '../../models/status_model.dart';
import '../../screens/app_screens/chat_message/layouts/image_picker.dart';
import '../../screens/bottom_screens/chat_screen/layouts/status_firebase_api.dart';
import '../../screens/bottom_screens/chat_screen/layouts/text_status.dart';
import '../../utils/snack_and_dialogs_utils.dart';
import '../common_controllers/all_permission_handler.dart';

class StatusController extends GetxController {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  List<Status> status = [];
  List statusSelectList = [];
  String? groupId, currentUserId, imageUrl;
  Image? contactPhoto;
  dynamic user;
  File? imageFile;
  XFile? imageFiles;
  List<Status> statusList = [];
  File? image;
  List<Status> allViewStatusList = [];
  bool isLoading = false, isData = false;
  List selectedContact = [];
  Stream<QuerySnapshot>? stream;
  List<Status> statusListData = [];
  Status? currentUserStatus,sponsorStatus;
  List<Status> statusData = [];

  // BannerAd? bannerAd;
  bool bannerAdIsLoaded = false;
  Widget currentAd = const SizedBox(
    width: 0.0,
    height: 0.0,
  );
  Reference? reference;
  DateTime date = DateTime.now();
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());

  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());

  onTapStatus() {
    alertDialog(
        title: appFonts.addStory,
        list: statusSelectList,
        onTap: (int index) async {
          log("INDEX: $index");
          if (index == 0) {
            Get.back();
            dismissKeyboard();

            await getImage().then((value) async {
              log("VALUE : $value");
              String fileName =
                  DateTime.now().millisecondsSinceEpoch.toString();

              reference = FirebaseStorage.instance.ref().child(fileName);
              update();
              try {
                await addStatus(image!, StatusType.image);
              } catch (e) {
                appCtrl.isLoading = false;
                appCtrl.update();
              }
            });
          } else if (index == 2) {
            Get.back();
            Get.to(() => const TextStatus());
          } else if (index == 1) {
            Get.back();
            await getImage(source: ImageSource.camera).then((value) async {
              if (value != null) {
                log("VALUE : $value");
                String fileName =
                    DateTime.now().millisecondsSinceEpoch.toString();

                reference = FirebaseStorage.instance.ref().child(fileName);
                update();
                try {
                  await addStatus(image!, StatusType.image);
                } catch (e) {
                  appCtrl.isLoading = false;
                  appCtrl.update();
                }
              }
            });
          }
          update();
        });
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    statusSelectList = appArray.addStatusList;
    final data = appCtrl.storage.read(session.user) ?? "";
    if (data != "") {
      currentUserId = data["id"];
      user = data;
    }
    update();
    await VideoCompress.setLogLevel(0);
    update();
    super.onReady();
  }

// Dismiss KEYBOARD
  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  //add status
  /*addStatus(File file, StatusType statusType) async {
    appCtrl.isLoading = true;
    appCtrl.update();
    imageUrl = await pickerCtrl.uploadImage(file);
    if (imageUrl != "") {
      update();
      debugPrint("imageUrl : $imageUrl");
      await StatusFirebaseApi().addStatus(imageUrl, statusType.name);
    } else {
      flutterAlertMessage(msg: "Error while Uploading Image");
    }
    appCtrl.isLoading = false;
    appCtrl.update();
  }*/

  addStatus(File file, StatusType statusType) async {
  //  appCtrl.isLoading = true;
    appCtrl.update();

    try {
      imageUrl = await pickerCtrl.uploadImage(file);
      if (imageUrl != "") {
        update();
        debugPrint("imageUrl : $imageUrl");
        await StatusFirebaseApi().addStatus(imageUrl, statusType.name);
      } else {
        flutterAlertMessage(msg: "Error while Uploading Image");
      }
    } catch (e) {
      log("Error uploading image: $e");
      flutterAlertMessage(msg: "Error while Uploading Image");
    } finally {
    //  appCtrl.isLoading = false;
      appCtrl.update();
      log("appCtrl updated to not loading");
    }
  }

  //status list

  List statusListWidget(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List statusList = [];
    log("snapshot.data!.docs: ${snapshot.data!.docs.length}");
    for (int a = 0; a < snapshot.data!.docs.length; a++) {
      statusList.add(snapshot.data!.docs[a].data());
    }
    return statusList;
  }

/*
  GallerySetting gallerySetting = const GallerySetting(
    enableCamera: true,
    maximumCount: 1,
    requestType: RequestType.all,
    cameraSetting: CameraSetting(videoDuration: Duration(seconds: 15)),
  );*/

  imagePickerOption() {
    showModalBottomSheet(
        context: Get.context!,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.r25)),
        ),
        builder: (BuildContext context) {
          // return your layout
          return ImagePickerLayout(
              cameraTap: () async {},
              galleryTap: () async {
                Get.back();
                pickAssets();
              });
        });
  }

  Future getImage({source}) async {
    if (source != null) {
      final ImagePicker picker = ImagePicker();
      imageFiles = (await picker.pickImage(source: source, imageQuality: 30))!;
      if (imageFiles != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFiles!.path,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: appCtrl.appTheme.primary,
                toolbarWidgetColor: appCtrl.appTheme.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ],
        );
        if (croppedFile != null) {
          File compressedFile = await FlutterNativeImage.compressImage(
              croppedFile.path,
              quality: 30,
              targetWidth: 600,
              targetHeight: 300,
              percentage: 20);
          update();

          log("image : ${compressedFile.lengthSync()}");

          image = File(compressedFile.path);
          if (image!.lengthSync() / 1000000 >
              appCtrl.usageControlsVal!.maxFileSize!) {
            image = null;
            snackBar(
                "Image Should be less than ${image!.lengthSync() / 1000000 > appCtrl.usageControlsVal!.maxFileSize!}");
          }
        }
        log("image1 : $image");
        log("image1 : ${image!.lengthSync() / 1000000 > 60}");

        Get.forceAppUpdate();
        return image;
      }
    } else {
      List<File> selectedImages = [];
      dismissKeyboard();
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4'],
      );

      log("resultresult: $result");
      if (result != null) {
        for (var i = 0; i < result.files.length; i++) {
          selectedImages.add(File(result.files[i].path!));
        }
      }
      imageFile = selectedImages[0];
      if (selectedImages[0].name.contains(".mp4")) {
        final light.LightCompressor lightCompressor = light.LightCompressor();
        final dynamic response = await lightCompressor.compressVideo(
          path: imageFile!.path,
          videoQuality: light.VideoQuality.very_low,
          isMinBitrateCheckEnabled: false,
          video: light.Video(videoName: selectedImages[0].name),
          android: light.AndroidConfig(
              isSharedStorage: true, saveAt: light.SaveAt.Movies),
          ios: light.IOSConfig(saveInGallery: false),
        );


        image = File(imageFile!.path);
        if (response is light.OnSuccess) {
          log("videoFile!.path 1: ${getVideoSize(file: File(response.destinationPath))}}");
          image = File(response.destinationPath);
        } else if (response is light.OnFailure) {

          image = File(imageFile!.path);
        } else if (response is light.OnCancelled) {
          image = File(imageFile!.path);
        } else {
          debugPrint("responseresponse 5:$image");
          image = File(imageFile!.path);
        }
      } else {
        if (imageFile != null) {
          final croppedFile = await ImageCropper().cropImage(
            sourcePath: imageFile!.path,
            compressQuality: 100,
            uiSettings: [
              AndroidUiSettings(
                  toolbarTitle: 'Cropper',
                  toolbarColor: appCtrl.appTheme.primary,
                  toolbarWidgetColor: appCtrl.appTheme.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              IOSUiSettings(
                title: 'Cropper',
              ),
            ],
          );

         // appCtrl.isLoading = true;
          appCtrl.update();
          Get.forceAppUpdate();
          if (croppedFile != null) {
            File compressedFile = await FlutterNativeImage.compressImage(
              croppedFile.path,
              quality: 30,
            );
            update();

            log("image : ${compressedFile.lengthSync()}");

            image = File(compressedFile.path);
            if (image!.lengthSync() / 1000000 >
                appCtrl.usageControlsVal!.maxFileSize!) {
              image = null;
              snackBar(
                  "Image Should be less than ${image!.lengthSync() / 1000000 > appCtrl.usageControlsVal!.maxFileSize!}");
            }
          }
          log("image1 : $image");
          Get.forceAppUpdate();
          return image;
        }
      }
    }
  }

  pickAssets() async {
    try {
      /*   log("COUNT : ${appCtrl.usageControlsVal!.maxFilesMultiShare}");
     // GalleryController controller = GalleryController();
      final List<AssetEntity>? entities = await AssetPicker.pickAssets(
        Get.context!,
        pickerConfig: const AssetPickerConfig(),
      );

      if (entities!.isNotEmpty) {
        File? videoFile = await entities[0].file;
        File? video;
        if (entities[0].type == AssetType.video) {
          log("entities :: ${entities[0].type}");
          appCtrl.isLoading = true;
          appCtrl.update();
          final info = await VideoCompress.compressVideo(
            videoFile!.path,
            quality: VideoQuality.MediumQuality,
            deleteOrigin: false,
            includeAudio: true,
            duration: 1,
          );
          print(info!.path);
          debugPrint(
              "videoFile!.path 1: ${getVideoSize(file: File(info.path!))}}");
          video = File(info.path!);
          */ /*  final light.LightCompressor lightCompressor = light.LightCompressor();

          final light.Result response = await lightCompressor.compressVideo(
            path: videoFile!.path,
            videoQuality: light.VideoQuality.very_low,
            isMinBitrateCheckEnabled: false,
            video: light.Video(videoName: entities[0].title!),
            android: light.AndroidConfig(
                isSharedStorage: true, saveAt: light.SaveAt.Movies),
            ios: light.IOSConfig(saveInGallery: false),
          );

     //     video = File(videoFile.path);
          debugPrint("responseresponse :${response.obs}");
          if (response is light.OnSuccess) {
            debugPrint("responseresponse 1:$video");
            debugPrint("videoFile!.path 1: ${getVideoSize(
                file: File(response.destinationPath))}}");
            video = File(response.destinationPath);
          }else if (response is light.OnFailure) {
            print(response.message);
            debugPrint("responseresponse 2 $video");
            video = File(videoFile.path);
          } else if (response is light.OnCancelled) {
            debugPrint("responseresponse 34 $video");
            video = File(videoFile.path);
          }else{
            debugPrint("responseresponse 5:$video");
            video = File(videoFile.path);
          }*/ /*
        } else {
          File compressedFile = await FlutterNativeImage.compressImage(
            videoFile!.path,
            quality: 35,
          );

          log("image : ${compressedFile.lengthSync()}");

          video = File(compressedFile.path);
          if (video.lengthSync() / 1000000 > 60) {
            video = null;
            snackBar(
                "Image Should be less than ${video!.lengthSync() / 1000000 > 60}");
          }
        }

        Get.forceAppUpdate();
        log("CHECK ON ADD");
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        reference = FirebaseStorage.instance.ref().child(fileName);
        update();
        await addStatus(
            video,
            entities[0].type == AssetType.video
                ? StatusType.video
                : StatusType.image);
      }*/
    } catch (e) {
      isLoading = false;
      update();
    }
    Get.forceAppUpdate();
  }

  Future<List<QueryDocumentSnapshot>?> getStatusUsingChunks(chunks) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(chunks)
        .collection(collectionName.status)
        .get();
    if (result.docs.isNotEmpty) {
      return result.docs;
    } else {
      return null;
    }
  }

  getAllStatus({search}) async {
    LocalStorage storage = LocalStorage('statusModel');

    allViewStatusList = [];

    update();
    Get.forceAppUpdate();
    var futureGroup = FutureGroup();
    final FetchContactController registerAvailableContact =
        Provider.of<FetchContactController>(Get.context!, listen: false);

    for (var chunk in registerAvailableContact.registerContactUser) {
      futureGroup.add(getStatusUsingChunks(chunk.id));
    }

    futureGroup.close();
    var p = await futureGroup.future;

    statusList = [];
    storage.ready.then((ready) {
      for (var batch in p) {
        if (batch != null) {
          for (QueryDocumentSnapshot<Map<String, dynamic>> postedStatus
              in batch) {
            if (postedStatus.exists) {
              if (postedStatus.data()['id'] != appCtrl.user['id']) {
                Status status = Status.fromJson(postedStatus.data());

                if (search == null) {
                  bool isEmpty = statusList
                      .where((element) => element.uid == status.uid)
                      .isEmpty;

                  if (isEmpty) {
                    if (!statusList.contains(status)) {
                      statusList.add(status);
                    }
                  }
                  update();
                } else {
                  if (status.username!
                      .replaceAll(" ", "")
                      .toString()
                      .toLowerCase()
                      .contains(search)) {
                    int index = statusList
                        .indexWhere((element) => element.uid == status.uid);

                    if (index < 0) {
                      if (!statusList.contains(status)) {
                        statusList.add(status);
                      }
                    }
                  }
                  update();
                }
              }
            }
            update();
            Get.forceAppUpdate();
          }
        }
      }
    });
    update();
  }

  getCurrentStatus(){
    if(appCtrl.user != null ) {
      FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user['id'])
          .collection(collectionName.status)
          .snapshots().listen((event) {
            if(event.docs.isNotEmpty){
              currentUserStatus = Status.fromJson(event.docs[0].data());
            }
      });
    }
    FirebaseFirestore.instance
        .collection(collectionName.adminStatus)

        .snapshots().listen((event) {
      if(event.docs.isNotEmpty){
        currentUserStatus = Status.fromJson(event.docs[0].data());
      }
    });
  }
}
