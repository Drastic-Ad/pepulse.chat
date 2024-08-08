import 'dart:developer';
import 'dart:io';

import 'package:dartx/dartx_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:video_compress/video_compress.dart';

import '../../config.dart';
import '../../screens/app_screens/chat_message/layouts/image_picker.dart';
import '../../utils/snack_and_dialogs_utils.dart';
import 'package:light_compressor/light_compressor.dart' as light;

class PickerController extends GetxController {
  XFile? imageFile;
  XFile? videoFile;
  File? image;
  File? video;
  String? imageUrl;
  String? audioUrl;
  List<File> selectedImages = [];

// GET IMAGE FROM GALLERY
  Future getImage(source) async {
    final ImagePicker picker = ImagePicker();
    imageFile = (await picker.pickImage(source: source, imageQuality: 30))!;
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
      if (croppedFile != null) {
        File compressedFile = await FlutterNativeImage.compressImage(
            croppedFile.path,

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
    }
  }

// GET IMAGE FROM GALLERY
  Future getMultipleImage({isImage = true}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'png', 'jpeg',],
    );

    log("resultresult: $result");
    if (result != null) {
      for (var i = 0; i < result.files.length; i++) {
        selectedImages.add(File(result.files[i].path!));
      }
      return selectedImages;
    } else {
      // If no image is selected it will show a
      // snackbar saying nothing is selected
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

/*// GET VIDEO FROM GALLERY
  Future getVideo(source) async {
    appCtrl.isLoading = true;
    update();
    final light.LightCompressor lightCompressor = light.LightCompressor();
    final ImagePicker picker = ImagePicker();
    videoFile = (await picker.pickVideo(
      source: source,
    ))!;
    if (videoFile != null) {
      log("videoFile!.path : ${videoFile!.path}");
      final dynamic response = await lightCompressor.compressVideo(
        path: videoFile!.path,
        videoQuality: light.VideoQuality.very_low,
        isMinBitrateCheckEnabled: false,
        video: light.Video(videoName: videoFile!.name),
        android: light.AndroidConfig(
            isSharedStorage: true, saveAt: light.SaveAt.Movies),
        ios: light.IOSConfig(saveInGallery: false),
      );

      video = File(videoFile!.path);
      if (response is light.OnSuccess) {
        log("videoFile!.path 1: ${getVideoSize(file: File(response.destinationPath))}}");
        video = File(response.destinationPath);
      }
      appCtrl.isLoading = false;
      appCtrl.update();
      update();
    }
    Get.forceAppUpdate();
  }*/

// GET VIDEO FROM GALLERY
  Future getMultipleVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['mp4'],
    );

    log("resultresult: $result");
    if (result != null) {
      for (var i = 0; i < result.files.length; i++) {
        selectedImages.add(File(result.files[i].path!));
      }
      return selectedImages;
    } else {
      // If no image is selected it will show a
      // snackbar saying nothing is selected
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

// FOR Dismiss KEYBOARD
  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  //image picker option
  imagePickerOption(BuildContext context,
      {isGroup = false, isSingleChat = false, isCreateGroup = false}) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.r25)),
        ),
        builder: (BuildContext context) {
          // return your layout
          return ImagePickerLayout(cameraTap: () async {
            dismissKeyboard();
            await getImage(ImageSource.camera).then((value) {
              log("VALUE : $value");
              if (isGroup) {
                final chatCtrl = Get.find<GroupChatMessageController>();
                chatCtrl.uploadFile();
              } else if (isSingleChat) {
                final singleChatCtrl = Get.find<ChatController>();
                singleChatCtrl.uploadFile();
              } else if (isCreateGroup) {
                final singleChatCtrl = Get.find<GroupMessageController>();
                singleChatCtrl.uploadFile();
              } else {
                final broadcastCtrl = Get.find<BroadcastChatController>();
                broadcastCtrl.uploadFile();
              }
            });
            Get.back();
          }, galleryTap: () async {
            if (isCreateGroup) {
              getImage(ImageSource.gallery).then((value) {
                final singleChatCtrl = Get.find<GroupMessageController>();
                singleChatCtrl.uploadFile();
              });
            } else {
              await getMultipleImage().then((value) {
                if (value != null) {
                  if (isGroup) {
                    final chatCtrl = Get.find<GroupChatMessageController>();
                    chatCtrl.selectedImages = value;
                   chatCtrl.isLoading = true;
                   chatCtrl.update();
                   chatCtrl.selectedImages.asMap().entries.forEach((element) async {
                     File? videoFile =  element.value;
                     File? video;
                     if (element.value.name.contains("mp4")) {
                       final light.LightCompressor lightCompressor =
                       light.LightCompressor();
                       final dynamic response =
                       await lightCompressor.compressVideo(
                         path: videoFile.path,
                         videoQuality: light.VideoQuality.very_low,
                         isMinBitrateCheckEnabled: false,
                         video: light.Video(videoName: element.value.name),
                         android: light.AndroidConfig(
                             isSharedStorage: true, saveAt: light.SaveAt.Movies),
                         ios: light.IOSConfig(saveInGallery: false),
                       );

                       video = File(videoFile.path);
                       if (response is light.OnSuccess) {
                         log("videoFile!.path 1: ${getVideoSize(
                             file: File(response.destinationPath))}}");
                         video = File(response.destinationPath);
                       }
                     } else {
                       File compressedFile =
                       await FlutterNativeImage.compressImage(videoFile.path,

                           percentage: 20);

                       log("image : ${compressedFile.lengthSync()}");

                       video = File(compressedFile.path);
                       if (video.lengthSync() / 1000000 > appCtrl.usageControlsVal!.maxFileSize!) {
                         video = null;
                         snackBar(
                             "Image Should be less than ${video!.lengthSync() /
                                 1000000 > appCtrl.usageControlsVal!.maxFileSize!}");
                       }
                     }

                     chatCtrl.uploadMultipleFile(videoFile,element.value.name.contains("mp4") ? MessageType.video : MessageType.image);
                   });
                   selectedImages =[];
                   update();
                  } else if (isSingleChat) {
                    final singleChatCtrl = Get.find<ChatController>();
                      singleChatCtrl.selectedImages = value;
                    singleChatCtrl.selectedImages
                        .asMap()
                        .entries
                        .forEach((element) async {
                      File? videoFile =  element.value;
                      appCtrl.isLoading = true;
                      appCtrl.update();
                      File compressedFile =
                          await FlutterNativeImage.compressImage(
                              videoFile.path,
                              percentage: 20);

                      log("image : ${compressedFile.lengthSync()}");
                      log("MAX SIZE IMAGE ${appCtrl.usageControlsVal!.maxFileSize!}");

                      video = File(compressedFile.path);
                      if (video!.lengthSync() / 1000000 >
                          appCtrl.usageControlsVal!.maxFileSize!) {
                        video = null;
                        appCtrl.isLoading = false;
                        appCtrl.update();
                        snackBar(
                            "Image Should be less than ${video!.lengthSync() / 1000000 > appCtrl.usageControlsVal!.maxFileSize!}");
                      }

                      singleChatCtrl.uploadMultipleFile(
                          video!,
                          element.value.name.contains("mp4")
                              ? MessageType.video
                              : MessageType.image);
                    });selectedImages =[];
                    update();
                  } else {
                     final broadcastCtrl = Get.find<BroadcastChatController>();
                   broadcastCtrl.selectedImages = value;
                   broadcastCtrl.selectedImages.asMap().entries.forEach((
                       element) async {
                     File? videoFile =  element.value;
                     File? video;
                     if (element.value.name.contains("mp4")) {
                       final light.LightCompressor lightCompressor =
                       light.LightCompressor();
                       final dynamic response =
                       await lightCompressor.compressVideo(
                         path: videoFile.path,
                         videoQuality: light.VideoQuality.very_low,
                         isMinBitrateCheckEnabled: false,
                         video: light.Video(videoName: element.value.name),
                         android: light.AndroidConfig(
                             isSharedStorage: true, saveAt: light.SaveAt.Movies),
                         ios: light.IOSConfig(saveInGallery: false),
                       );

                       video = File(videoFile.path);
                       if (response is light.OnSuccess) {
                         log("videoFile!.path 1: ${getVideoSize(
                             file: File(response.destinationPath))}}");
                         video = File(response.destinationPath);
                       }
                     } else {
                       File compressedFile =
                       await FlutterNativeImage.compressImage(videoFile.path,

                           percentage: 20);

                       log("image : ${compressedFile.lengthSync()}");

                       video = File(compressedFile.path);
                       if (video.lengthSync() / 1000000 > appCtrl.usageControlsVal!.maxFileSize!) {
                         video = null;
                         snackBar(
                             "Image Should be less than ${video!.lengthSync() /
                                 1000000 > appCtrl.usageControlsVal!.maxFileSize!}");
                       }
                     }

                     broadcastCtrl.uploadMultipleFile(video,element.value.name.contains("mp4") ? MessageType.video : MessageType.image);
                   });
                     selectedImages =[];
                     update();
                  }
                }
              });
            }
            Get.back();
          });
        });
  }

  onTapGroupProfile(BuildContext context,
      {isGroup = false, isSingleChat = false, isCreateGroup = false}) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppRadius.r8))),
              backgroundColor: appCtrl.appTheme.white,
              titlePadding: const EdgeInsets.all(Insets.i20),
              title: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(appFonts.addPhoto.tr,
                          style: AppCss.manropeBold16
                              .textColor(appCtrl.appTheme.darkText)),
                      Icon(CupertinoIcons.multiply,
                              color: appCtrl.appTheme.darkText)
                          .inkWell(onTap: () => Get.back())
                    ]),
                const VSpace(Sizes.s15),
                Divider(
                    color: appCtrl.appTheme.darkText.withOpacity(0.1),
                    height: 1,
                    thickness: 1)
              ]),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  Image.asset(eImageAssets.gallery, height: Sizes.s44),
                  const HSpace(Sizes.s15),
                  Text(appFonts.selectFromGallery.tr,
                      style: AppCss.manropeBold14
                          .textColor(appCtrl.appTheme.darkText))
                ]).inkWell(onTap: () async {
                  if (isCreateGroup) {
                    getImage(ImageSource.gallery).then((value) {
                      final singleChatCtrl = Get.find<GroupMessageController>();
                      singleChatCtrl.uploadFile();
                    });
                  } else {
                    await getMultipleImage().then((value) {
                      if (value != null) {
                        if (isGroup) {
                          final chatCtrl =
                              Get.find<GroupChatMessageController>();
                          chatCtrl.selectedImages = value;
                          chatCtrl.isLoading = true;
                          chatCtrl.update();
                          chatCtrl.selectedImages
                              .asMap()
                              .entries
                              .forEach((element) async {
                            File? videoFile = element.value;
                            File? video;
                            if (element.value.name.contains("mp4")) {
                              final light.LightCompressor lightCompressor =
                                  light.LightCompressor();
                              final dynamic response =
                                  await lightCompressor.compressVideo(
                                path: videoFile.path,
                                videoQuality: light.VideoQuality.very_low,
                                isMinBitrateCheckEnabled: false,
                                video:
                                    light.Video(videoName: element.value.name),
                                android: light.AndroidConfig(
                                    isSharedStorage: true,
                                    saveAt: light.SaveAt.Movies),
                                ios: light.IOSConfig(saveInGallery: false),
                              );

                              video = File(videoFile.path);
                              if (response is light.OnSuccess) {
                                log("videoFile!.path 1: ${getVideoSize(file: File(response.destinationPath))}}");
                                video = File(response.destinationPath);
                              }
                            } else {
                              File compressedFile =
                                  await FlutterNativeImage.compressImage(
                                      videoFile.path,

                                      percentage: 20);

                              log("image : ${compressedFile.lengthSync()}");

                              video = File(compressedFile.path);
                              if (video.lengthSync() / 1000000 >
                                  appCtrl.usageControlsVal!.maxFileSize!) {
                                video = null;
                                snackBar(
                                    "Image Should be less than ${video!.lengthSync() / 1000000 > appCtrl.usageControlsVal!.maxFileSize!}");
                              }
                            }

                            chatCtrl.uploadMultipleFile(
                                videoFile,
                                element.value.name.contains("mp4")
                                    ? MessageType.video
                                    : MessageType.image);
                          });
                        } else if (isSingleChat) {
                          final singleChatCtrl = Get.find<ChatController>();
                          singleChatCtrl.selectedImages = value;
                          singleChatCtrl.selectedImages
                              .asMap()
                              .entries
                              .forEach((element) async {
                            File? videoFile = element.value;
                            appCtrl.isLoading = true;
                            appCtrl.update();
                            File compressedFile =
                                await FlutterNativeImage.compressImage(
                                    videoFile.path,

                                    percentage: 20);

                            log("image : ${compressedFile.lengthSync()}");
                            log("MAX SIZE IMAGE ${appCtrl.usageControlsVal!.maxFileSize!}");

                            video = File(compressedFile.path);
                            if (video!.lengthSync() / 1000000 >
                                appCtrl.usageControlsVal!.maxFileSize!) {
                              video = null;
                              appCtrl.isLoading = false;
                              appCtrl.update();
                              snackBar(
                                  "Image Should be less than ${video!.lengthSync() / 1000000 > appCtrl.usageControlsVal!.maxFileSize!}");
                            }

                            singleChatCtrl.uploadMultipleFile(
                                video!,
                                element.value.name.contains("mp4")
                                    ? MessageType.video
                                    : MessageType.image);
                          });
                        } else {
                          final broadcastCtrl =
                              Get.find<BroadcastChatController>();
                          broadcastCtrl.selectedImages = value;
                          broadcastCtrl.selectedImages
                              .asMap()
                              .entries
                              .forEach((element) async {
                            File? videoFile = element.value;
                            File? video;
                            if (element.value.name.contains("mp4")) {
                              final light.LightCompressor lightCompressor =
                                  light.LightCompressor();
                              final dynamic response =
                                  await lightCompressor.compressVideo(
                                path: videoFile.path,
                                videoQuality: light.VideoQuality.very_low,
                                isMinBitrateCheckEnabled: false,
                                video:
                                    light.Video(videoName: element.value.name),
                                android: light.AndroidConfig(
                                    isSharedStorage: true,
                                    saveAt: light.SaveAt.Movies),
                                ios: light.IOSConfig(saveInGallery: false),
                              );

                              video = File(videoFile.path);
                              if (response is light.OnSuccess) {
                                log("videoFile!.path 1: ${getVideoSize(file: File(response.destinationPath))}}");
                                video = File(response.destinationPath);
                              }
                            } else {
                              File compressedFile =
                                  await FlutterNativeImage.compressImage(
                                      videoFile.path,
                                      percentage: 20);

                              log("image : ${compressedFile.lengthSync()}");

                              video = File(compressedFile.path);
                              if (video.lengthSync() / 1000000 >
                                  appCtrl.usageControlsVal!.maxFileSize!) {
                                video = null;
                                snackBar(
                                    "Image Should be less than ${video!.lengthSync() / 1000000 > appCtrl.usageControlsVal!.maxFileSize!}");
                              }
                            }

                            broadcastCtrl.uploadMultipleFile(
                                video,
                                element.value.name.contains("mp4")
                                    ? MessageType.video
                                    : MessageType.image);
                          });
                        }
                      }
                    });
                  }

                  Get.back();
                }).paddingOnly(bottom: Insets.i30),
                Row(children: [
                  Image.asset(eImageAssets.camera, height: Sizes.s44),
                  const HSpace(Sizes.s15),
                  Text(appFonts.openCamera.tr,
                      style: AppCss.manropeBold14
                          .textColor(appCtrl.appTheme.darkText))
                ]).inkWell(onTap: () async {
                  dismissKeyboard();
                  await getImage(ImageSource.camera).then((value) {
                    log("VALUE : $value");
                    if (isGroup) {
                      /*  final chatCtrl = Get.find<GroupChatMessageController>();
                chatCtrl.uploadFile();*/
                    } else if (isSingleChat) {
                      final singleChatCtrl = Get.find<ChatController>();
                      singleChatCtrl.uploadFile();
                    } else if (isCreateGroup) {
                      final singleChatCtrl = Get.find<GroupMessageController>();
                      singleChatCtrl.uploadFile();
                    } else {
                      /*final broadcastCtrl = Get.find<BroadcastChatController>();
                broadcastCtrl.uploadFile();*/
                    }
                  });
                  Get.back();
                }).paddingOnly(bottom: Insets.i30),
                /* if(profileCtrl != '')
                      Row(
                          children: [
                            Image.asset(eImageAssets.anonymous,height: Sizes.s44),
                            const HSpace(Sizes.s15),
                            Text(appFonts.removePhoto,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText))
                          ]
                      ).inkWell(onTap:(){
                        Get.back();

                        update();
                      })*/
              ]).padding(horizontal: Sizes.s20, bottom: Insets.i20));
        });
  }

  //video picker option
  videoPickerOption(BuildContext context,
      {isGroup = false, isSingleChat = false}) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.r25))),
        builder: (BuildContext context) {
          // return your layout
          return ImagePickerLayout(cameraTap: () async {
            dismissKeyboard();
            await getVideo(ImageSource.camera).then((value) {
              if (isGroup) {
                final chatCtrl = Get.find<GroupChatMessageController>();
                chatCtrl.videoSend();
              } else if (isSingleChat) {
                final singleChatCtrl = Get.find<ChatController>();
                singleChatCtrl.videoSend();
                Get.back();
              } else {
                final broadcastCtrl = Get.find<BroadcastChatController>();
                broadcastCtrl.videoSend();
              }
            });
            Get.back();
          }, galleryTap: () async {
            await getMultipleVideo().then((value) {
              if (isGroup) {
                 final chatCtrl = Get.find<GroupChatMessageController>();
                chatCtrl.selectedImages = value;
                chatCtrl.selectedImages.asMap().entries.forEach((
                    element) async {
                  File? videoFile =  element.value;
                  File? video;
                  log("VIDEO FILE $videoFile");
                  if (element.value.name.contains("mp4")) {
                    final info = await VideoCompress.compressVideo(
                      videoFile.path,
                      quality: VideoQuality.MediumQuality,
                      deleteOrigin: false,
                      includeAudio: true,
                    );
                    video = File(info!.path!);
                  }
                  chatCtrl.uploadMultipleFile(video!, MessageType.video);
                });
                 selectedImages =[];
                 update();
              } else if (isSingleChat) {
                final singleChatCtrl = Get.find<ChatController>();
                singleChatCtrl.selectedImages = value;
                singleChatCtrl.selectedImages
                    .asMap()
                    .entries
                    .forEach((element) async {
                  File? videoFile =  element.value;

                  appCtrl.isLoading = true;
                  appCtrl.update();


                  if (element.value.name.contains("mp4")) {
                    final info = await VideoCompress.compressVideo(
                      videoFile.path,
                      quality: VideoQuality.MediumQuality,
                      deleteOrigin: false,
                      includeAudio: true,
                    );
                    video = File(info!.path!);
                  }
                  appCtrl.isLoading = false;
                  appCtrl.update();
                  singleChatCtrl.uploadMultipleFile(
                      videoFile, MessageType.video);
                });
                selectedImages =[];
                update();
                Get.back();
              } else {
                final broadcastCtrl = Get.find<BroadcastChatController>();
                broadcastCtrl.selectedImages = value;
                broadcastCtrl.selectedImages.asMap().entries.forEach((
                    element) async {
                  File? videoFile = element.value;
                  if (element.value.name.contains("mp4")) {
                    final info = await VideoCompress.compressVideo(
                      videoFile.path,
                      quality: VideoQuality.MediumQuality,
                      deleteOrigin: false,
                      includeAudio: true,
                    );
                    video = File(info!.path!);
                  }
                  broadcastCtrl.uploadMultipleFile(videoFile, MessageType.video);
                });
                selectedImages =[];
                update();
              }
            });
            Get.back();
          });
        });
  }

  Future<String> uploadImage(File file, {String? fileNameText}) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
          FirebaseStorage.instance.ref().child(fileNameText ?? fileName);
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      imageUrl = downloadUrl;
      return imageUrl!;
    } on FirebaseException catch (e) {
      log("FIREBASE : ${e.message}");
      return "";
    }
  }

  // GET VIDEO FROM GALLERY
  Future getVideo(source) async {
    //  final light.LightCompressor lightCompressor = light.LightCompressor();
    // log("COMPRESSOR $lightCompressor}");
    final ImagePicker picker = ImagePicker();
    videoFile = (await picker.pickVideo(
      source: source,
    ));
    log("VideoFILEEEE $videoFile ");
    if (videoFile != null) {
      log("videoFile!.path : ${videoFile!.path}");
      appCtrl.isLoading = true;
      appCtrl.update();
      final info = await VideoCompress.compressVideo(
        videoFile!.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      /*final dynamic response = await lightCompressor.compressVideo(
        path: videoFile!.path,
        videoQuality: light.VideoQuality.very_low,
        isMinBitrateCheckEnabled: false,
        video: light.Video(videoName: videoFile!.name),
        android: light.AndroidConfig(
            isSharedStorage: true, saveAt: light.SaveAt.Movies),
        ios: light.IOSConfig(saveInGallery: false),
      )*/

      video = File(videoFile!.path);

      video = File(info!.path!);

      appCtrl.isLoading = false;
      appCtrl.update();
      update();
    }
    Get.forceAppUpdate();
  }
}
