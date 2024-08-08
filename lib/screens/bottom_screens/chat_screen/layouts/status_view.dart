import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:story_view/story_view.dart';
import '../../../../config.dart';
import '../../../../controllers/app_pages_controllers/status_view_controller.dart';
import '../../../../models/status_model.dart';
import '../../../../widgets/common_image_layout.dart';

class StatusScreenView extends StatefulWidget {

  const StatusScreenView({super.key});

  @override
  State<StatusScreenView> createState() => _StatusScreenViewState();
}

class _StatusScreenViewState extends State<StatusScreenView> {
  final statusViewCtrl = Get.put(StatusViewController());
bool isSponsor = false;
  int seenList = 0;

  @override
  void initState() {
    initStoryPageItems();
    setState(() {

    });
    // TODO: implement initState
    super.initState();
  }

  void initStoryPageItems() {
    dynamic data = Get.arguments;
    statusViewCtrl.status = data["status"];
    isSponsor = data["isSponsor"] ?? false;
    statusViewCtrl.reflect();
    statusViewCtrl.update();
    for (int i = 0; i < statusViewCtrl.status!.photoUrl!.length; i++) {
      if (statusViewCtrl.status!.photoUrl![i].statusType ==
          StatusType.text.name) {
        int value = int.parse(
            statusViewCtrl.status!.photoUrl![i].statusBgColor!, radix: 16);
        Color finalColor = Color(value);
        statusViewCtrl.storyItems.add(StoryItem.text(
            title: statusViewCtrl.status!.photoUrl![i].statusText!,
            textStyle: TextStyle(
                color: appCtrl.appTheme.white,
                fontSize: 23,
                height: 1.6,
                fontWeight: FontWeight.w700),
            backgroundColor: finalColor));
      } else if (statusViewCtrl.status!.photoUrl![i].statusType ==
          StatusType.video.name) {
        statusViewCtrl.storyItems.add(
          StoryItem.pageVideo(
            statusViewCtrl.status!.photoUrl![i].image!,
            controller: statusViewCtrl.controller,
          ),
        );
      } else {
        statusViewCtrl.storyItems.add(StoryItem.pageImage(
          url: statusViewCtrl.status!.photoUrl![i].image!,
          controller: statusViewCtrl.controller,
        ));
      }
    }
    statusViewCtrl.update();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatusViewController>(
        builder: (_) {
          return GestureDetector(
            onPanEnd: (details) {
              if (details.velocity.pixelsPerSecond.dy > -100) {
                statusViewCtrl.isSwipeUp = true;
                statusViewCtrl.update();
              } else {
                statusViewCtrl.isSwipeUp = false;
                statusViewCtrl.update();
              }
              if (statusViewCtrl.isSwipeUp = true) {
                statusViewCtrl.controller.pause();
              } else {
                statusViewCtrl.controller.play();
              }
              statusViewCtrl.update();
            },
            child: DirectionalityRtl(
              child: Scaffold(
                body: statusViewCtrl.storyItems.isEmpty
                    ? const CircularProgressIndicator()
                    : Stack(
                  alignment: appCtrl.isRTL || appCtrl.languageVal == "ar" ? Alignment.topRight : Alignment.topLeft,
                  children: [
                    StoryView(
                      indicatorForegroundColor: appCtrl.appTheme.primary,
                      indicatorColor: appCtrl.appTheme.greyText.withOpacity(0.2),
                      inline: true,
                      onStoryShow: (s, position) {
                        // Call the asynchronous function
                        handleStoryShowAsync(s);
                      },
                      storyItems: statusViewCtrl.storyItems,
                      controller: statusViewCtrl.controller,
                      onComplete: () {
                        Navigator.maybePop(context);
                      },

                      repeat: false,
                      onVerticalSwipeComplete: (direction) {
                        log("direction : $direction");
                        if (direction == Direction.down) {
                          Navigator.pop(context);
                        } else if (direction == Direction.up) {
                          dynamic user = appCtrl.storage.read(session.user);
                          if (statusViewCtrl.status!.uid ==
                              (FirebaseAuth.instance.currentUser != null
                                  ? FirebaseAuth.instance.currentUser!.uid
                                  : user["id"])) {
                            statusViewCtrl.controller.pause();
                            statusViewCtrl.update();
                            int lastPosition = statusViewCtrl.position - 1;
                            FirebaseFirestore.instance
                                .collection(collectionName.users)
                                .doc(FirebaseAuth.instance.currentUser != null
                                ? FirebaseAuth.instance.currentUser!.uid
                                : user["id"])
                                .collection(collectionName.status)
                                .limit(1)
                                .get()
                                .then((doc) {
                              if (doc.docs.isNotEmpty) {
                                Status getStatus =
                                Status.fromJson(doc.docs[0].data());

                                List<PhotoUrl> photoUrl = getStatus.photoUrl!;
                                log("photoUrl : $photoUrl");
                                statusViewCtrl.seenBy =
                                photoUrl[lastPosition].seenBy!;
                                statusViewCtrl.update();
                              }
                            });
                            showModalBottomSheet(
                              context: context,
                              backgroundColor:
                              appCtrl.appTheme.trans,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(AppRadius.r20))),
                              builder: (context) => statusViewCtrl.buildSheet(),
                            );
                          } else if (direction == Direction.down) {
                            statusViewCtrl.controller.play();
                            statusViewCtrl.update();
                          }
                        }
                      },
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonImage(
                              width: Sizes.s48,
                              height: Sizes.s48,
                              image: statusViewCtrl.status!.profilePic!,
                              name: isSponsor ? "Sponsor" : statusViewCtrl.status!.username!
                          ),
                          const HSpace(Sizes.s12),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(statusViewCtrl.status!.uid ==
                                    appCtrl.user["id"]
                                    ? "My Story"
                                    : statusViewCtrl.status!.username!,
                                    style: AppCss.manropeMedium16
                                        .textColor(appCtrl.appTheme.white)),
                                const VSpace(Sizes.s5),
                                DateFormat("dd/MM/yy").format(DateTime.now()) ==
                                    DateFormat('dd/MM/yy').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(statusViewCtrl.status!
                                                .photoUrl![statusViewCtrl
                                                .lastPosition].timestamp
                                                .toString())))
                                    ? Text("Today ${DateFormat('hh:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(int.parse(
                                        statusViewCtrl.status!
                                            .photoUrl![statusViewCtrl
                                            .lastPosition].timestamp
                                            .toString())))}",
                                    style: AppCss.manropeMedium12
                                        .textColor(const Color.fromRGBO(
                                        255, 255, 255, 0.65)))
                                    : Text(
                                    "Yesterday ${DateFormat('hh:mm a').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(
                                                statusViewCtrl.status!
                                                    .photoUrl![statusViewCtrl
                                                    .lastPosition].timestamp
                                                    .toString())))}",
                                    style: AppCss.manropeMedium12
                                        .textColor(const Color.fromRGBO(
                                        255, 255, 255, 0.65)))
                              ]
                          ).marginOnly(top: Insets.i10)
                        ]
                    ).marginSymmetric(
                        horizontal: Insets.i20, vertical: Insets.i75),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            width: Sizes.s80
                        ).inkWell(onTap: () {
                          log("lastPosition : ${statusViewCtrl.status!.photoUrl!
                              .length}");
                          log("lastPosition : ${statusViewCtrl.lastPosition}");

                          statusViewCtrl.lastPosition =
                              statusViewCtrl.lastPosition - 1;
                          if (statusViewCtrl.lastPosition == -1) {
                            Get.back();
                          } else {
                            statusViewCtrl.controller.previous();
                            statusViewCtrl.update();
                          }

                        })),
                    Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            width: Sizes.s80
                        ).inkWell(onTap: () {
                          statusViewCtrl.lastPosition =
                              statusViewCtrl.lastPosition + 1;

                          if (statusViewCtrl.lastPosition <
                              statusViewCtrl.status!.photoUrl!.length) {
                            statusViewCtrl.controller.next();
                            statusViewCtrl.update();
                          } else {
                            Get.back();
                          }
                        })),
                    if(statusViewCtrl.status!.uid == appCtrl.user["id"])
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                       SizedBox(
                                        height: 30,
                                        width: 100,
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: statusViewCtrl.status!.photoUrl![statusViewCtrl.lastPosition].seenBy!
                                                .asMap()
                                                .entries
                                                .map((e) {
                                              return StreamBuilder(
                                                  stream: FirebaseFirestore.instance
                                                      .collection(
                                                      collectionName.users)
                                                      .doc(e.value["uid"])
                                                      .snapshots(),
                                                  builder: (context, snapshot) {

                                                    seenList = statusViewCtrl.status!.photoUrl![statusViewCtrl.lastPosition].seenBy!.length;

                                                    String image = "",
                                                        name = "";
                                                    if (snapshot.hasData) {
                                                      image =
                                                          snapshot.data!
                                                              .data()!["image"] ??
                                                              "";
                                                      log("IMAGEEEE $image");
                                                      name = snapshot.data!
                                                          .data()!["name"] ??
                                                          "";
                                                      log("NAMEEEE $name");
                                                    }
                                                    return e.key >
                                                        statusViewCtrl.seenBy
                                                            .length - 4 ?
                                                    Stack(
                                                      children: [
                                                        CommonImage(
                                                            image: image,
                                                            height: Sizes.s30,
                                                            width: Sizes.s30,
                                                            name: name)
                                                      ],
                                                    ) : Container();
                                                  });
                                            }).toList()
                                        ),
                                      ),

                                      const VSpace(Sizes.s5),
                                      Text(
                                          "${appFonts.seenBy.tr} $seenList ",
                                          style: AppCss.manropeBold12
                                              .textColor(appCtrl.appTheme.white)
                                      )
                                    ]
                                ),
                                /*SvgPicture.asset(eSvgAssets.trash,
                                    colorFilter: ColorFilter.mode(
                                        appCtrl.appTheme.sameWhite,
                                        BlendMode.srcIn))*/
                              ]
                          ).paddingSymmetric(
                              vertical: Insets.i25, horizontal: Insets.i20)
                      )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Future<void> handleStoryShowAsync(StoryItem s) async {
    log("STATUS : ${s.reactive}");
    statusViewCtrl.selectedIndex = statusViewCtrl.selectedIndex + 1;
    statusViewCtrl.position = statusViewCtrl.position + 1;

    if ((statusViewCtrl.position - 1) < statusViewCtrl.status!.photoUrl!.length) {
      if (isSponsor) {
        var doc = await FirebaseFirestore.instance.collection(collectionName.adminStatus).get();
        if (doc.docs.isNotEmpty) {
          Status getStatus = Status.fromJson(doc.docs[0].data());
          log("getStatus : ${doc.docs[0].id}");
          List<PhotoUrl> photoUrl = getStatus.photoUrl!;
          bool isSeen = photoUrl[statusViewCtrl.lastPosition].seenBy!.where((element) => element["uid"] == appCtrl.user["id"]).isNotEmpty;

          if (!isSeen) {
            photoUrl[statusViewCtrl.lastPosition].seenBy!.add({
              "uid": appCtrl.user["id"],
              "seenTime": DateTime.now().millisecondsSinceEpoch
            });
            log("SEEN L %${photoUrl[statusViewCtrl.lastPosition].seenBy}");
            await FirebaseFirestore.instance.collection(collectionName.adminStatus).doc(doc.docs[0].id).update({
              "photoUrl": photoUrl.map((e) => e.toJson()).toList()
            });
          }

          if (statusViewCtrl.position == statusViewCtrl.status!.photoUrl!.length) {
            List seenAll = statusViewCtrl.status!.seenAllStatus ?? [];
            if (!seenAll.contains(statusViewCtrl.status!.uid)) {
              seenAll.add(appCtrl.user["id"]);
            }
            await FirebaseFirestore.instance.collection(collectionName.adminStatus).doc(doc.docs[0].id).update({"seenAllStatus": seenAll});
          }
        }
      } else {
        var doc = await FirebaseFirestore.instance.collection(collectionName.users).doc(statusViewCtrl.status!.uid).collection(collectionName.status).limit(1).get();
        if (doc.docs.isNotEmpty) {
          Status getStatus = Status.fromJson(doc.docs[0].data());
          log("getStatus : ${doc.docs[0].id}");
          List<PhotoUrl> photoUrl = getStatus.photoUrl!;
          bool isSeen = photoUrl[statusViewCtrl.lastPosition].seenBy!.where((element) => element["uid"] == appCtrl.user["id"]).isNotEmpty;

          if (!isSeen) {
            photoUrl[statusViewCtrl.lastPosition].seenBy!.add({
              "uid": appCtrl.user["id"],
              "seenTime": DateTime.now().millisecondsSinceEpoch
            });
            log("SEEN L %${photoUrl[statusViewCtrl.lastPosition].seenBy}");
            await FirebaseFirestore.instance.collection(collectionName.users).doc(statusViewCtrl.status!.uid).collection(collectionName.status).doc(doc.docs[0].id).update({
              "photoUrl": photoUrl.map((e) => e.toJson()).toList()
            });
          }

          if (statusViewCtrl.position == statusViewCtrl.status!.photoUrl!.length) {
            List seenAll = statusViewCtrl.status!.seenAllStatus ?? [];
            if (!seenAll.contains(statusViewCtrl.status!.uid)) {
              seenAll.add(appCtrl.user["id"]);
            }
            await FirebaseFirestore.instance.collection(collectionName.users).doc(statusViewCtrl.status!.uid).collection(collectionName.status).doc(doc.docs[0].id).update({"seenAllStatus": seenAll});
          }
        }
      }
    }
  }


}

