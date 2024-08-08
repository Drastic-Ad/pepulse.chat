import 'dart:math';

import 'package:chatzy/controllers/app_pages_controllers/audio_call_controller.dart';

import '../../../config.dart';

class AudioCall extends StatefulWidget {
  const AudioCall({super.key});

  @override
  State<AudioCall> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall>
    with SingleTickerProviderStateMixin {
  final audioCallCtrl = Get.put(AudioCallController());
  late final AnimationController _controller;
  late final Animation<double> expandAnimation;
  bool open = false;
  late final List<Widget> children;

  @override
  void initState() {
    super.initState();
    var data = Get.arguments;
    audioCallCtrl.channelName = data["channelName"];
    audioCallCtrl.call = data["call"];
    audioCallCtrl.token = data["token"];
    audioCallCtrl.userData = appCtrl.storage.read(session.user);
    setState(() {});
    audioCallCtrl.stream = FirebaseFirestore.instance
        .collection(collectionName.calls)
        .doc(audioCallCtrl.userData["id"] == audioCallCtrl.call!.callerId
        ? audioCallCtrl.call!.receiverId
        : audioCallCtrl.call!.callerId)
        .collection("collectionCallHistory")
        .doc(audioCallCtrl.call!.timestamp.toString())
        .snapshots();
    audioCallCtrl.update();
    audioCallCtrl.initAgora();
    audioCallCtrl.onReady();

    children = [
      ActionButton(
        onPressed: () {
          audioCallCtrl.onToggleSpeaker();
        },
        index: 0,
        image: audioCallCtrl.isSpeaker ? eSvgAssets.volume : eSvgAssets.volume1,
      ),

      ActionButton(
        onPressed: () {
          audioCallCtrl.onToggleMute();
        },
        index: 1,
        image: audioCallCtrl.muted ? eSvgAssets.speaker2 : eSvgAssets.speaker1,
      ),
      ActionButton(
        onPressed: () {},
        index: 2,
        image: eSvgAssets.profileAdd1,
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

    return GetBuilder<AudioCallController>(
        builder: (_) {
print("audioCallCtrl.hoursStr ;#${audioCallCtrl.hoursStr}");
          return DirectionalityRtl(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: audioCallCtrl.stream
            as Stream<DocumentSnapshot<Map<String, dynamic>>>,
              builder: (BuildContext context, snapshot) {
                return PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (didPop) return;
                    if (snapshot.hasData) {
                      if (snapshot.data!.data() != null ||
                          snapshot.data != null) {
                        audioCallCtrl.isAlreadyEnded =
                        snapshot.data!.data()!["status"] == 'ended' ||
                            snapshot.data!.data()!["status"] == 'rejected'
                            ? true
                            : false;
                      } else {
                        audioCallCtrl.isAlreadyEnded = false;
                      }
                    } else {
                      audioCallCtrl.isAlreadyEnded = false;
                    }
                    audioCallCtrl.update();
                    audioCallCtrl.onCallEnd(Get.context!);
                    Get.back();
                  },

                  child: Scaffold(
                      backgroundColor: appCtrl.appTheme.white,
                      floatingActionButton: ExpandableFab(
                        distance: 130,
                        children: [
                          ActionButton(
                            onPressed: () {
                              audioCallCtrl.onToggleSpeaker();
                            },
                            index: 0,
                            image: audioCallCtrl.isSpeaker
                                ? eSvgAssets.volume
                                : eSvgAssets.volume1,
                          ),

                          ActionButton(
                            onPressed: () {
                              audioCallCtrl.onToggleMute();
                            },
                            index: 1,
                            image: audioCallCtrl.muted
                                ? eSvgAssets.mute
                                : eSvgAssets.speaker2,
                          ),
                          ActionButton(
                            onPressed: () {},
                            index: 2,
                            image: eSvgAssets.profileAdd1,
                          ),
                        ],
                      ),
                      body: StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                          stream:audioCallCtrl.stream
                          as Stream<DocumentSnapshot<Map<String, dynamic>>>,
                          builder: (BuildContext context, snapshot) {

                            return Stack(
                              children: [

                                Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
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
                                                  Image.asset(eImageAssets
                                                      .customEllipse),
                                                  Container(
                                                    height: Sizes.s96,
                                                    width: Sizes.s96,
                                                    padding: const EdgeInsets
                                                        .all(Insets.i5),
                                                    alignment: Alignment.center,
                                                    margin: const EdgeInsets
                                                        .only(
                                                        bottom: Insets.i10,
                                                        right: Insets.i5),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: appCtrl
                                                                .appTheme
                                                                .primary),
                                                        image: audioCallCtrl.call!.callerId == appCtrl.user['id'] ? audioCallCtrl
                                                            .call!
                                                            .receiverPic !=
                                                            null &&
                                                            audioCallCtrl.call!
                                                                .receiverPic !=
                                                                ""
                                                            ? DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                            NetworkImage(
                                                                audioCallCtrl
                                                                    .call!
                                                                    .receiverPic!)): DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image:
                                                      AssetImage(
                                                          eImageAssets.anonymous)) :audioCallCtrl
                                                            .call!
                                                            .callerPic !=
                                                            null &&
                                                            audioCallCtrl.call!
                                                                .callerPic !=
                                                                ""
                                                            ? DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                            NetworkImage(
                                                                audioCallCtrl
                                                                    .call!
                                                                    .callerPic!)): DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                            AssetImage(
                                                                eImageAssets.anonymous)),
                                                    ))
                                                ],
                                              ).paddingAll(Insets.i30)),
                                        ),
                                        const VSpace(Sizes.s40),
                                        Text("${audioCallCtrl.userData["id"] == audioCallCtrl.call!.callerId
                                            ? audioCallCtrl.call!.receiverName
                                            : audioCallCtrl.call!.callerName} Audio Call",
                                            style: AppCss.manropeblack20
                                                .textColor(
                                                appCtrl.appTheme.black)),
                                        const VSpace(Sizes.s10),

                                        if(snapshot.hasData )
                                          snapshot.data!.data() == null ||
                                              snapshot.data == null ?
                                          Text(
                                            "Ringing...",
                                            style: AppCss.manropeblack14
                                                .textColor(
                                                appCtrl.appTheme.primary),
                                            textAlign: TextAlign.center,
                                          ) : Text(
                                              snapshot.data!
                                                  .data()!["status"] ==
                                                  'pickedUp'
                                                  ? appFonts.picked.tr
                                                  : snapshot.data!
                                                  .data()!["status"] ==
                                                  'noNetwork'
                                                  ? appFonts.connecting.tr
                                                  : snapshot.data!
                                                  .data()!["status"] ==
                                                  'ringing' || snapshot.data!
                                                  .data()!["status"] ==
                                                  'missedCall'
                                                  ? appFonts.calling.tr
                                                  : snapshot.data!
                                                  .data()!["status"] ==
                                                  'calling'
                                                  ? audioCallCtrl.call!
                                                  .receiverId ==
                                                  appCtrl.user["id"]
                                                  ? appFonts.connecting.tr
                                                  : appFonts.calling.tr
                                                  : snapshot.data!
                                                  .data()!["status"] ==
                                                  'pickedUp'
                                                  ? appFonts.onCall.tr
                                                  : snapshot.data!
                                                  .data()!["status"] == 'ended'
                                                  ? appFonts.callEnded.tr
                                                  : snapshot.data!
                                                  .data()!["status"] ==
                                                  'rejected'
                                                  ? appFonts.callRejected.tr
                                                  : appFonts.plsWait.tr,
                                              style: AppCss.manropeblack14
                                                  .textColor(
                                                  appCtrl.appTheme.primary))
                                      ],
                                    ).marginOnly(
                                        left: Insets.i45,
                                        top: MediaQuery
                                            .of(context)
                                            .size
                                            .height / 7,
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
                                              Container(
                                                height: Insets.i64,
                                                width: Insets.i64,

                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: Insets.i14),
                                                decoration: const BoxDecoration(
                                                    color: Color(0XFFEE595C),
                                                    shape: BoxShape.circle),
                                                child: SvgPicture.asset(
                                                    eSvgAssets.callEnd),
                                              ).inkWell(onTap: () {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data!.data() !=
                                                      null) {
                                                    audioCallCtrl
                                                        .isAlreadyEnded =
                                                    snapshot.data!
                                                        .data()!["status"] ==
                                                        'ended' ||
                                                        snapshot
                                                            .data!
                                                            .data()!["status"] ==
                                                            'rejected'
                                                        ? true
                                                        : false;
                                                  } else {
                                                    audioCallCtrl
                                                        .isAlreadyEnded = false;
                                                  }
                                                } else {
                                                  audioCallCtrl.isAlreadyEnded =
                                                  false;
                                                }
                                                audioCallCtrl.update();
                                                audioCallCtrl.onCallEnd(
                                                    Get.context!);
                                              }),
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
                                              ).marginSymmetric(
                                                  vertical: Insets.i20)
                                            ],
                                          )
                                        ],
                                      ).paddingSymmetric(
                                          horizontal: Insets.i50),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    ActionIconsCommon(
                                      onTap: () async {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.data() != null ||
                                              snapshot.data != null) {
                                            audioCallCtrl.isAlreadyEnded =
                                            snapshot.data!.data()!["status"] ==
                                                'ended' ||
                                                snapshot
                                                    .data!
                                                    .data()!["status"] ==
                                                    'rejected'
                                                ? true
                                                : false;
                                          } else {
                                            audioCallCtrl.isAlreadyEnded =
                                            false;
                                          }
                                        } else {
                                          audioCallCtrl.isAlreadyEnded = false;
                                        }
                                        audioCallCtrl.update();
                                        audioCallCtrl.onCallEnd(Get.context!);
                                      },
                                      icon: appCtrl.isRTL ||
                                          appCtrl.languageVal == "ar"
                                          ? eSvgAssets.arrowRight
                                          : eSvgAssets.arrowLeft,
                                      vPadding: Insets.i15,
                                      color: appCtrl.appTheme.white,
                                      hPadding: 15,
                                    ),
                                    if(snapshot.hasData)
                                      if(snapshot.data!.data() != null ||
                                          snapshot.data != null)
                                        if(audioCallCtrl.localUserJoined)
                                          Stack(alignment: Alignment.center,
                                            children: [
                                              Image.asset(eImageAssets.timeBg,
                                                height: Sizes.s65,
                                                width: Sizes.s100,
                                                fit: BoxFit.fill,),
                                              Text(
                                                "${audioCallCtrl.getFormattedTime()}",
                                                style: AppCss.manropeblack14
                                                    .textColor(
                                                    appCtrl.appTheme.sameWhite),
                                              )
                                            ],
                                          )

                                  ],
                                ).paddingOnly(top: Insets.i55)
                              ],
                            );
                          }
                      )),
                );
              },
            ),
          );
        }
    );
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

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = true;

  @override
  void initState() {
    super.initState();
    _open = true;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          ..._buildExpandingActionButtons(),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 180.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
    i < count;
    i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          index: i,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
    required this.index,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: (MediaQuery
              .of(context)
              .size
              .width / 2.9) + offset.dx,
          bottom: 15.0 + offset.dy,
          child: child!,
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.index,
    required this.image,
  });

  final VoidCallback? onPressed;
  final int index;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          index == 0 ? eImageAssets.buttonBg : eImageAssets.button2,
          height: Sizes.s80,
          width: Sizes.s80,
          fit: BoxFit.fill,
        ),
        SvgPicture.asset(image).paddingOnly(bottom: Insets.i5)
      ],
    ).paddingOnly(right: index == 0 ? 10 : 0).inkWell(onTap: onPressed);
  }
}
