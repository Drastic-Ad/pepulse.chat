import 'dart:developer';

import 'package:chatzy/config.dart';
import 'package:intl/intl.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../models/status_model.dart';
import '../../widgets/common_image_layout.dart';

class StatusViewController extends GetxController {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];
  bool fabVisibility = true;
  int position = -1,
      selectedIndex = 0,
      lastPosition = 0;
  Status? status;
  List seenBy = [];
  bool isSwipeUp = false;

  void initStoryPageItems() {
    for (int i = 0; i < status!.photoUrl!.length; i++) {
      if (status!.photoUrl![i].statusType == StatusType.text.name) {
        int value = int.parse(status!.photoUrl![i].statusBgColor!, radix: 16);
        Color finalColor = Color(value);
        storyItems.add(StoryItem.text(
            title: status!.photoUrl![i].statusText!,
            textStyle: TextStyle(
                color: appCtrl.appTheme.white,
                fontSize: 23,
                height: 1.6,
                fontWeight: FontWeight.w700),
            backgroundColor: finalColor));
      } else if (status!.photoUrl![i].statusType == StatusType.video.name) {
        storyItems.add(
          StoryItem.pageVideo(
            status!.photoUrl![i].image!,
            controller: controller,
          ),
        );
      } else {
        storyItems.add(StoryItem.pageImage(
          url: status!.photoUrl![i].image!,
          controller: controller,
        ));
      }
    }
    update();
  }

  reflect(){
    dynamic user = appCtrl.storage.read(session.user);
    if (status!.uid ==
        (FirebaseAuth.instance.currentUser != null
            ? FirebaseAuth.instance.currentUser!.uid
            : user["id"])) {
      update();

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
          log("lastPosition : $lastPosition");
          log("position : $position");
          seenBy = photoUrl[lastPosition].seenBy!;
          update();
          log("seenBy : $seenBy");
        }
      });
    }
  }

  Widget buildSheet() {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        log("notification: $notification");
        if (fabVisibility && notification.extent >= 0.2) {
            fabVisibility = false;
            update();
        } else if (!fabVisibility && notification.extent < 0.2) {
            fabVisibility = true;
            update();
        }
        return fabVisibility;
        // here determine if scroll is over and func.call()
      },
      child: StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onVerticalDragDown: (panel) {
                fabVisibility = false;
                controller.play();
                Get.back();
                setState;
              },
              child: DirectionalityRtl(
                child: DraggableScrollableSheet(
                    initialChildSize: 0.7,
                    snap: true,
                    minChildSize: 0.5,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                            color: appCtrl.appTheme.white,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppRadius.r20))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(Insets.i20),
                              decoration: BoxDecoration(
                                  color: appCtrl.appTheme.primary,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(AppRadius.r20))),
                              child: Text(
                                "${appFonts.seenBy.tr} ${seenBy.length} ",
                                style: AppCss.manropeMedium14
                                    .textColor(appCtrl.appTheme.white),
                              ),
                            ),
                            ...status!.photoUrl![lastPosition].seenBy!
                                .asMap()
                                .entries
                                .map((e) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection(collectionName.users)
                                      .doc(e.value["uid"])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    String image = "",
                                        name = "";
                                    if (snapshot.hasData) {
                                      image =
                                          snapshot.data!.data()!["image"] ?? "";
                                      name = snapshot.data!.data()!["name"] ?? "";
                                    }
                                    return ListTile(
                                        leading: CommonImage(
                                            image: image,
                                            height: Sizes.s48,
                                            width: Sizes.s48,
                                            name: name),
                                        title: Text(name),
                                        subtitle: Text(
                                            DateFormat('hh:mm a').format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                    int.parse(e.value["seenTime"]
                                                        .toString())))));
                                  });
                            })
                          ],
                        ),
                      );
                    }),
              ),
            );
          }
      ),
    );
  }

  @override
  void onReady() {


    update();
    // TODO: implement onReady
    super.onReady();
  }


}