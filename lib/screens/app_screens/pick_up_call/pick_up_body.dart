import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:chatzy/controllers/recent_chat_controller.dart';
import 'package:chatzy/models/call_model.dart';
import '../../../config.dart';
import '../../../controllers/app_pages_controllers/video_call_controller.dart';
import '../../../controllers/common_controllers/all_permission_handler.dart';
import '../../../widgets/expandable_fab.dart';

class PickupBody extends StatelessWidget {
  final Call? call;
  final CameraController? cameraController;
  final String? imageUrl;

  const PickupBody({super.key, this.call, this.imageUrl, this.cameraController})
     ;

  @override
  Widget build(BuildContext context) {
log("FFF : ${call!.callerName}");
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ExpandableFab(
        distance: 110,
        children: [
          Container(
            height: Insets.i64,
            width: Insets.i64,
            margin: const EdgeInsets.symmetric(horizontal: Insets.i15),
            padding: const EdgeInsets.symmetric(horizontal: Insets.i14),
            decoration: const BoxDecoration(
                color: Color(0XFFEE595C), shape: BoxShape.circle),
            child: SvgPicture.asset(eSvgAssets.callEnd),
          ).inkWell(onTap: () async {
            final videoCtrl = Get.isRegistered<VideoCallController>()
                ? Get.find<VideoCallController>()
                : Get.put(VideoCallController());
            await videoCtrl.endCall(call: call!);
            FirebaseFirestore.instance
                .collection(collectionName.calls)
                .doc(call!.callerId)
                .collection(collectionName.collectionCallHistory)
                .doc(call!.timestamp.toString())
                .set({
              'type': 'outGoing',
              'isVideoCall': call!.isVideoCall,
              'id': call!.receiverId,
              'timestamp': call!.timestamp,
              'dp': call!.receiverPic,
              'isMuted': false,
              'receiverId': call!.receiverId,
              'isJoin': false,
              'started': null,
              'callerName': call!.receiverName,
              'status': 'rejected',
              'ended': DateTime.now(),
            }, SetOptions(merge: true));
            FirebaseFirestore.instance
                .collection(collectionName.calls)
                .doc(call!.receiverId)
                .collection(collectionName.collectionCallHistory)
                .doc(call!.timestamp.toString())
                .set({
              'type': 'INCOMING',
              'isVideoCall': call!.isVideoCall,
              'id': call!.callerId,
              'timestamp': call!.timestamp,
              'dp': call!.callerPic,
              'isMuted': false,
              'receiverId': call!.receiverId,
              'isJoin': true,
              'started': null,
              'callerName': appCtrl.user["name"],
              'status': 'rejected',
              'ended': DateTime.now(),
            }, SetOptions(merge: true));
          }),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                eImageAssets.button2,
                height: Sizes.s80,
                width: Sizes.s80,
                fit: BoxFit.fill,
              ),
              SvgPicture.asset(eSvgAssets.chatOut)
                  .paddingOnly(bottom: Insets.i3)
            ],
          ).inkWell(onTap: () async {
            final videoCtrl = Get.isRegistered<VideoCallController>()
                ? Get.find<VideoCallController>()
                : Get.put(VideoCallController());
            await videoCtrl.endCall(call: call!);
            FirebaseFirestore.instance
                .collection(collectionName.calls)
                .doc(call!.callerId)
                .collection(collectionName.collectionCallHistory)
                .doc(call!.timestamp.toString())
                .set({
              'type': 'outGoing',
              'isVideoCall': call!.isVideoCall,
              'id': call!.receiverId,
              'timestamp': call!.timestamp,
              'dp': call!.receiverPic,
              'isMuted': false,
              'receiverId': call!.receiverId,
              'isJoin': false,
              'started': null,
              'callerName': call!.receiverName,
              'status': 'rejected',
              'ended': DateTime.now(),
            }, SetOptions(merge: true));
            FirebaseFirestore.instance
                .collection(collectionName.calls)
                .doc(call!.receiverId)
                .collection(collectionName.collectionCallHistory)
                .doc(call!.timestamp.toString())
                .set({
              'type': 'INCOMING',
              'isVideoCall': call!.isVideoCall,
              'id': call!.callerId,
              'timestamp': call!.timestamp,
              'dp': call!.callerPic,
              'isMuted': false,
              'receiverId': call!.receiverId,
              'isJoin': true,
              'started': null,
              'callerName': appCtrl.user["name"],
              'status': 'rejected',
              'ended': DateTime.now(),
            }, SetOptions(merge: true));
            final RecentChatController recentChatController =
                Provider.of<RecentChatController>(Get.context!, listen: false);

            bool isEmpty = recentChatController.userData.where((element) {
              return element["receiverId"] == appCtrl.user["id"] &&
                      element["senderId"] == call!.receiverId ||
                  element["senderId"] == appCtrl.user["id"] &&
                      element["receiverId"] == call!.receiverId;
            }).isEmpty;

            if (!isEmpty) {
              int index = recentChatController.userData.indexWhere((element) =>
                  element["receiverId"] == appCtrl.user["id"] &&
                      element["senderId"] == call!.receiverId ||
                  element["senderId"] == appCtrl.user["id"] &&
                      element["receiverId"] == call!.receiverId);
              UserContactModel userContact = UserContactModel(
                  username: call!.receiverName,
                  uid: call!.receiverId,
                  phoneNumber:
                      recentChatController.userData[index].data()["phone"],
                  image: recentChatController.userData[index].data()["image"],
                  isRegister: true);
              var data = {
                "chatId": recentChatController.userData[index]["chatId"],
                "data": userContact,
                "message": "Call you later",
                "isCallEnd": true
              };

              Get.back();
              Get.toNamed(routeName.chatLayout, arguments: data);
            } else {
              UserContactModel userContact = UserContactModel(
                  username: call!.receiverName,
                  uid: call!.receiverId,
                  phoneNumber: "",
                  image: call!.receiverPic,
                  isRegister: true);
              var data = {
                "chatId": "0",
                "data": userContact,
                "message": "Call you later",
                "isCallEnd": true
              };
              Get.back();
              Get.toNamed(routeName.chatLayout, arguments: data);
              //
            }
          }),
          Container(
            height: Insets.i64,
            width: Insets.i64,
            padding: const EdgeInsets.symmetric(horizontal: Insets.i14),
            decoration: BoxDecoration(
                color: appCtrl.appTheme.online, shape: BoxShape.circle),
            child: SvgPicture.asset(
              eSvgAssets.call,
              colorFilter:
                  ColorFilter.mode(appCtrl.appTheme.sameWhite, BlendMode.srcIn),
            ),
          ).inkWell(onTap: ()async {
            final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
                ? Get.find<PermissionHandlerController>()
                : Get.put(PermissionHandlerController());
            await permissionHandelCtrl
                .getCameraMicrophonePermissions()
                .then((value) {
              if (call!.isVideoCall!) {
                var data = {
                  "channelName": call!.channelId,
                  "call": call,
                  "token": call!.agoraToken
                };
                Get.toNamed(routeName.videoCall, arguments: data);
              } else {
                var data = {
                  "channelName": call!.channelId,
                  "call": call,
                  "token": call!.agoraToken
                };

                Get.toNamed(routeName.audioCall, arguments: data);
              }
            });
          }),
        ],
      ),
      body: Stack(
        children: [
          call!.isVideoCall == true
              ? CameraPreview(cameraController!)
                  .height(MediaQuery.of(context).size.height)
              : Container(
                  color: appCtrl.appTheme.white,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
          call!.isVideoCall == true
              ? Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [


                            Text(
                                call!.isGroup == true
                                    ? call!.groupName!
                                    : call!.callerId == appCtrl.user["id"]?call!.receiverName! : call!.callerName!,
                                style: AppCss.manropeblack20
                                    .textColor(appCtrl.appTheme.darkText)),
                            const VSpace(Sizes.s10),
                            Text(
                              "Ringing...",
                              style: AppCss.manropeblack14
                                  .textColor(appCtrl.appTheme.primary),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ).marginOnly(
                            left: Insets.i45,
                            top: MediaQuery.of(context).size.height / 2,
                            right: Insets.i45),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Image.asset( eImageAssets.halfEllipse),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        eSvgAssets.arrowUp,
                                        height: 22,
                                      ),
                                      RotationTransition(
                                          turns: const AlwaysStoppedAnimation(
                                              180 / 360),
                                          child: Image.asset(
                                            eGifAssets.arrowUp,
                                            height: 31,
                                          )),
                                    ],
                                  ).marginSymmetric(vertical: Insets.i20)
                                ],
                              )
                            ],
                          ).paddingSymmetric(horizontal: Insets.i50),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(eSvgAssets.back).inkWell(
                            onTap: () async {
                          final videoCtrl =
                              Get.isRegistered<VideoCallController>()
                                  ? Get.find<VideoCallController>()
                                  : Get.put(VideoCallController());
                          await videoCtrl.endCall(call: call!);
                          FirebaseFirestore.instance
                              .collection(collectionName.calls)
                              .doc(call!.callerId)
                              .collection(collectionName.collectionCallHistory)
                              .doc(call!.timestamp.toString())
                              .set({
                            'type': 'outGoing',
                            'isVideoCall': call!.isVideoCall,
                            'id': call!.receiverId,
                            'timestamp': call!.timestamp,
                            'dp': call!.receiverPic,
                            'isMuted': false,
                            'receiverId': call!.receiverId,
                            'isJoin': false,
                            'started': null,
                            'callerName': call!.receiverName,
                            'status': 'rejected',
                            'ended': DateTime.now(),
                          }, SetOptions(merge: true));
                          FirebaseFirestore.instance
                              .collection(collectionName.calls)
                              .doc(call!.receiverId)
                              .collection(collectionName.collectionCallHistory)
                              .doc(call!.timestamp.toString())
                              .set({
                            'type': 'INCOMING',
                            'isVideoCall': call!.isVideoCall,
                            'id': call!.callerId,
                            'timestamp': call!.timestamp,
                            'dp': call!.callerPic,
                            'isMuted': false,
                            'receiverId': call!.receiverId,
                            'isJoin': true,
                            'started': null,
                            'callerName': appCtrl.user["name"],
                            'status': 'rejected',
                            'ended': DateTime.now(),
                          }, SetOptions(merge: true));
                        }),
                      ],
                    ).paddingOnly(
                        top: Insets.i55, right: Insets.i20, left: Insets.i20)
                  ],
                )
              : Stack(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(collectionName.users)
                            .doc(call!.callerId == appCtrl.user['id']
                                ? call!.receiverId
                                : call!.callerId)
                            .snapshots(),
                        builder: (context, snapShot) {
                          log("DDD :${snapShot.data}");
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  DottedBorder(
                                    color: appCtrl.appTheme.primary
                                        .withOpacity(.16),
                                    strokeWidth: 1.4,
                                    dashPattern: const [5, 5],
                                    borderType: BorderType.Circle,
                                    child: SizedBox(
                                        child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(eImageAssets.customEllipse),
                                        Container(
                                          height: Sizes.s96,
                                          width: Sizes.s96,
                                          padding:
                                              const EdgeInsets.all(Insets.i5),
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              bottom: Insets.i10,
                                              right: Insets.i5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color:
                                                      appCtrl.appTheme.primary),
                                              image: snapShot.data != null &&
                                                      snapShot.data!.data() !=
                                                          null
                                                  ? DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          snapShot.data!.data()![
                                                              'image']))
                                                  : DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          eImageAssets
                                                              .anonymous))),
                                        )
                                      ],
                                    ).paddingAll(Insets.i30)),
                                  ),
                                  const VSpace(Sizes.s40),
                                  Text("${call!.receiverName} Audio Call",
                                      style: AppCss.manropeblack20
                                          .textColor(appCtrl.appTheme.black)),
                                  const VSpace(Sizes.s10),
                                  Text(
                                    "Ringing...",
                                    style: AppCss.manropeblack14
                                        .textColor(appCtrl.appTheme.primary),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ).marginOnly(
                                  left: Insets.i45,
                                  top: MediaQuery.of(context).size.height / 7,
                                  right: Insets.i45),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Image.asset(eImageAssets.halfEllipse),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              eSvgAssets.arrowUp,
                                              height: 22,
                                            ),
                                            RotationTransition(
                                                turns:
                                                    const AlwaysStoppedAnimation(
                                                        180 / 360),
                                                child: Image.asset(
                                                  eGifAssets.arrowUp,
                                                  height: 31,
                                                )),
                                          ],
                                        ).marginSymmetric(vertical: Insets.i20)
                                      ],
                                    )
                                  ],
                                ).paddingSymmetric(horizontal: Insets.i50),
                              ),
                            ],
                          );
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionIconsCommon(
                          onTap: () => Get.back(),
                          icon: appCtrl.isRTL || appCtrl.languageVal == "ar"
                              ? eSvgAssets.arrowRight
                              : eSvgAssets.arrowLeft,
                          vPadding: Insets.i15,
                          color: appCtrl.appTheme.white,
                          hPadding: 15,
                        ),
                      ],
                    ).paddingOnly(top: Insets.i55)
                  ],
                )
        ],
      ),
    );
  }
}
