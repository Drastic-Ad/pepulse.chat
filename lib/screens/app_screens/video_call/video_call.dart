import 'dart:math';
import 'package:chatzy/controllers/app_pages_controllers/video_call_controller.dart';
import 'package:chatzy/screens/app_screens/video_call/video_call_class.dart';
import '../../../config.dart';
import '../../../widgets/action_button.dart';
import '../../../widgets/expandable_fab.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall>
    with SingleTickerProviderStateMixin {
  final videoCallCtrl = Get.put(VideoCallController());
  late final AnimationController _controller;
  late final Animation<double> expandAnimation;
  bool open = false;
  late final List<Widget> children;

  @override
  void initState() {
    super.initState();
    var data = Get.arguments;

    videoCallCtrl.channelName = data["channelName"];
    videoCallCtrl.call = data["call"];
    videoCallCtrl.token = data["token"];
    videoCallCtrl.userData = appCtrl.storage.read(session.user);
    setState(() {});
    videoCallCtrl.stream = FirebaseFirestore.instance
        .collection(collectionName.calls)
        .doc(appCtrl.user["id"])
        .collection(collectionName.collectionCallHistory)
        .doc(videoCallCtrl.call!.timestamp.toString())
        .snapshots();
    videoCallCtrl.initAgora();
    videoCallCtrl.update();

    children = [
      ActionButton(
        onPressed: () {
          videoCallCtrl.onToggleSpeaker();
        },
        index: 0,
        image: eSvgAssets.cameraSwitch,
      ),
      ActionButton(
        onPressed: () {
          videoCallCtrl.onToggleMute();
        },
        index: 1,
        image: eSvgAssets.video1,
      ),
      ActionButton(
        onPressed: () {},
        index: 2,
        image: eSvgAssets.mute1,
      ),
    ];
    setState(() {});
    _controller = AnimationController(
      value: 1.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoCallController>(builder: (_) {
      return DirectionalityRtl(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream:  videoCallCtrl.stream
            as Stream<DocumentSnapshot<Map<String, dynamic>>>,
            builder: (BuildContext context, snapshot) {
              return PopScope(
                canPop: false,
                onPopInvoked: (didPop) {
                  if (didPop) return;
                  if (snapshot.hasData) {
                    if (snapshot.data!.data() != null ||
                        snapshot.data != null) {
                      videoCallCtrl.isAlreadyEndedCall =
                          snapshot.data!.data()!["status"] == 'ended' ||
                                  snapshot.data!.data()!["status"] == 'rejected'
                              ? true
                              : false;
                    } else {
                      videoCallCtrl.isAlreadyEndedCall = false;
                    }
                  } else {
                    videoCallCtrl.isAlreadyEndedCall = false;
                  }
                  videoCallCtrl.update();
                  videoCallCtrl.onCallEnd(Get.context!);
                  Get.back();
                },
                child: Scaffold(
                    backgroundColor: appCtrl.appTheme.white,
                    floatingActionButton: ExpandableFab(
                      distance: 140,
                      children: [
                        ActionButton(
                          onPressed: () {
                            videoCallCtrl.onSwitchCamera();
                          },
                          index: 0,
                          image: eSvgAssets.cameraSwitch,
                        ),
                        ActionButton(
                          onPressed: () async {
                            // videoCallCtrl.onToggleSpeaker();
                            // await videoCallCtrl.engine.disableVideo();
                            videoCallCtrl.isCameraShow =
                                !videoCallCtrl.isCameraShow;
                            if (videoCallCtrl.isCameraShow) {
                              await videoCallCtrl.engine.enableVideo();
                              await videoCallCtrl.engine.startPreview();
                            } else {
                              await videoCallCtrl.engine.disableVideo();
                              await videoCallCtrl.engine.stopPreview();
                            }
                            videoCallCtrl.update();
                          },
                          index: 1,
                          image: videoCallCtrl.isCameraShow
                              ? eSvgAssets.video1
                              : eSvgAssets.video,
                        ),
                        ActionButton(
                          onPressed: () {
                            videoCallCtrl.onToggleMute();
                          },
                          index: 2,
                          image: videoCallCtrl.muted
                              ? eSvgAssets.speaker2
                              : eSvgAssets.mute1,
                        )
                      ],
                    ),
                    body: Stack(
                      children: [
                        videoCallCtrl.isCameraShow
                            ? VideoCallClass().buildNormalVideoUI()
                            : Container(
                                color: appCtrl.appTheme.primary,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.height,
                              ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    videoCallCtrl.call!.isGroup == true
                                        ? videoCallCtrl.call!.groupName!
                                        : videoCallCtrl.call!.receiverName!,
                                    style: AppCss.manropeblack20
                                        .textColor(appCtrl.appTheme.sameWhite)),
                                const VSpace(Sizes.s10),
                                if (snapshot.hasData)
                                  snapshot.data!.data() == null ||
                                          snapshot.data == null
                                      ? Text(
                                          "Ringing...",
                                          style: AppCss.manropeblack14
                                              .textColor(
                                                  appCtrl.appTheme.primary),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text(
                                          snapshot.data!.data()!["status"] ==
                                                  'pickedUp'
                                              ? appFonts.picked.tr
                                              : snapshot.data!.data()!["status"] ==
                                                      'noNetwork'
                                                  ? appFonts.connecting.tr
                                                  : snapshot.data!.data()!["status"] ==
                                                              'ringing' ||
                                                          snapshot.data!.data()!["status"] ==
                                                              'missedCall'
                                                      ? appFonts.calling.tr
                                                      : snapshot.data!.data()!["status"] ==
                                                              'calling'
                                                          ? videoCallCtrl.call!.receiverId ==
                                                                  appCtrl.user[
                                                                      "id"]
                                                              ? appFonts
                                                                  .connecting.tr
                                                              : appFonts
                                                                  .calling.tr
                                                          : snapshot.data!.data()!["status"] ==
                                                                  'pickedUp'
                                                              ? appFonts
                                                                  .onCall.tr
                                                              : snapshot.data!.data()!["status"] ==
                                                                      'ended'
                                                                  ? appFonts
                                                                      .callEnded
                                                                      .tr
                                                                  : snapshot.data!.data()!["status"] ==
                                                                          'rejected'
                                                                      ? appFonts
                                                                          .callRejected
                                                                          .tr
                                                                      : appFonts
                                                                          .plsWait
                                                                          .tr,
                                          style: AppCss.manropeblack14
                                              .textColor(appCtrl.appTheme.primary))
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
                                  Image.asset(
                                    eImageAssets.halfEllipse1,
                                    width: MediaQuery.of(context).size.width,
                                    height: 210,
                                    fit: BoxFit.contain,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: Insets.i64,
                                        width: Insets.i64,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Insets.i14),
                                        decoration: const BoxDecoration(
                                            color: Color(0XFFEE595C),
                                            shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                            eSvgAssets.callEnd),
                                      ).inkWell(onTap: () {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.data() != null &&
                                              snapshot.data != null) {
                                            videoCallCtrl.isAlreadyEndedCall =
                                                snapshot.data!.data()![
                                                                "status"] ==
                                                            'ended' ||
                                                        snapshot.data!.data()![
                                                                "status"] ==
                                                            'rejected'
                                                    ? true
                                                    : false;
                                          } else {
                                            videoCallCtrl.isAlreadyEndedCall =
                                                false;
                                          }
                                        } else {
                                          videoCallCtrl.isAlreadyEndedCall =
                                              false;
                                        }
                                        videoCallCtrl.update();
                                        videoCallCtrl.onCallEnd(Get.context!);
                                      }),
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
                              ).paddingSymmetric(horizontal: Insets.i35),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(eSvgAssets.back).inkWell(
                                onTap: () async {
                              if (snapshot.hasData) {
                                if (snapshot.data!.data() != null ||
                                    snapshot.data != null) {
                                  videoCallCtrl.isAlreadyEndedCall = snapshot
                                                  .data!
                                                  .data()!["status"] ==
                                              'ended' ||
                                          snapshot.data!.data()!["status"] ==
                                              'rejected'
                                      ? true
                                      : false;
                                } else {
                                  videoCallCtrl.isAlreadyEndedCall = false;
                                }
                              } else {
                                videoCallCtrl.isAlreadyEndedCall = false;
                              }
                              videoCallCtrl.update();
                              videoCallCtrl.onCallEnd(Get.context!);
                            }),
                            if (snapshot.hasData)
                              if (snapshot.data!.data() != null ||
                                  snapshot.data != null)
                                if (videoCallCtrl.localUserJoined)
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        eImageAssets.timeBg,
                                        height: Sizes.s65,
                                        width: Sizes.s100,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        "${videoCallCtrl.getFormattedTime()}",
                                        style: AppCss.manropeblack14.textColor(
                                            appCtrl.appTheme.sameWhite),
                                      )
                                    ],
                                  )
                          ],
                        ).paddingOnly(
                            top: Insets.i55,
                            right: Insets.i20,
                            left: Insets.i20)
                      ],
                    )),
              );
            }),
      );
    });
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final redCircle = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    final arcRect = Rect.fromCircle(
        center: size.bottomCenter(Offset.zero), radius: size.shortestSide);
    canvas.drawArc(arcRect, 0, -pi, false, redCircle);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => false;
}
