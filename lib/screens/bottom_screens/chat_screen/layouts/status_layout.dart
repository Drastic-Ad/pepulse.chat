import 'package:video_player/video_player.dart';
import '../../../../config.dart';
import '../../../../models/status_model.dart';

class StatusLayout extends StatefulWidget {
  final Status? snapshot;
  final GestureTapCallback? onTap;
  final bool isShowAddIcon,isSponsor;

  const StatusLayout(
      {super.key, this.snapshot, this.onTap, this.isShowAddIcon = true,this.isSponsor =false});

  @override
  State<StatusLayout> createState() => _StatusLayoutState();
}

class _StatusLayoutState extends State<StatusLayout> {
  VideoPlayerController? videoController;
  Future<void>? initializeVideoPlayerFuture;
  bool startedPlaying = false;
  Status? status;

  @override
  void initState() {
    // TODO: implement initState

    Status status = widget.snapshot!;
    List<PhotoUrl> photoUrl = status.photoUrl!;
    if (photoUrl.isNotEmpty) {
      if (photoUrl.isNotEmpty) {
        if (status
                .photoUrl![
                    status.photoUrl!.isEmpty ? 0 : status.photoUrl!.length - 1]
                .statusType ==
            StatusType.video.name) {
          videoController = VideoPlayerController.networkUrl(
            Uri.parse(status.photoUrl![status.photoUrl!.length - 1].image!),
          )..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {});
            }).onError((error, stackTrace) {});
          initializeVideoPlayerFuture = videoController!.initialize();
        }
      }
    }
    setState(() {});

    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (videoController != null) {
      if (videoController!.value.isInitialized) {
        videoController!.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    status = widget.snapshot!;

    int seen = status!.seenAllStatus != null
        ? status!.seenAllStatus!.contains(appCtrl.user["id"])
            ? 0
            : 0
        : 0;
    status!.photoUrl!.asMap().entries.forEach((element) {
      if (element.value.seenBy!.contains(appCtrl.user["id"])) {
        seen = seen + 1;
      }
    });

    return InkWell(
      onTap: () {
        Status status = widget.snapshot!;

        Get.toNamed(routeName.statusView, arguments: {"status" :status,"isSponsor":widget.isSponsor});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  RotatedBox(
                      quarterTurns: 1,
                      child: SizedBox(
                          width: Sizes.s60,
                          height: Sizes.s60,
                          child: CustomPaint(
                              painter: DottedBorders(
                                  numberOfStories: status!.photoUrl!,
                                  spaceLength:
                                      widget.snapshot!.photoUrl!.length == 1
                                          ? 0
                                          : 4)))),
                  if(widget
                      .snapshot!
                      .photoUrl!.isNotEmpty)
                  widget
                              .snapshot!
                              .photoUrl![widget.snapshot!.photoUrl!.length - 1]
                              .statusType ==
                          StatusType.text.name
                      ? Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: Insets.i4),
                          height: Sizes.s55,
                          width: Sizes.s55,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(int.parse(widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1].statusBgColor!,
                                  radix: 16)),
                              shape: BoxShape.circle),
                          child: Text(widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1].statusText!,
                              textAlign: TextAlign.center,
                              style: AppCss.manropeMedium10
                                  .textColor(appCtrl.appTheme.white)))
                      : widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1].statusType ==
                              StatusType.image.name
                          ? CachedNetworkImage(
                              imageUrl: widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1].image
                                  .toString(),
                              imageBuilder: (context, imageProvider) => Container(
                                  height: Sizes.s55,
                                  width: Sizes.s55,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1].image.toString())))),
                              placeholder: (context, url) => Container(
                                    height: Sizes.s55,
                                    width: Sizes.s55,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: appCtrl.appTheme.primary),
                                    child: Text(
                                        widget.snapshot!.username != null
                                            ? widget.snapshot!.username!
                                                        .length >
                                                    2
                                                ? widget.snapshot!.username!
                                                    .replaceAll(" ", "")
                                                    .substring(0, 2)
                                                    .toUpperCase()
                                                : widget.snapshot!.username![0]
                                            : "C",
                                        style: AppCss.manropeblack16
                                            .textColor(appCtrl.appTheme.white)),
                                  ),
                              errorWidget: (context, url, error) => Container(
                                    height: Sizes.s55,
                                    width: Sizes.s55,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: appCtrl.appTheme.primary),
                                    child: Text(
                                      widget.snapshot!.username!.length > 2
                                          ? widget.snapshot!.username!
                                              .replaceAll(" ", "")
                                              .substring(0, 2)
                                              .toUpperCase()
                                          : widget.snapshot!.username![0],
                                      style: AppCss.manropeBold12.textColor(
                                          appCtrl.appTheme.sameWhite),
                                    ),
                                  ))
                          : ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: SmoothBorderRadius(cornerRadius: 50, cornerSmoothing: 1),
                              child: videoController!.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          videoController!.value.aspectRatio,
                                      // Use the VideoPlayer widget to display the video.
                                      child: VideoPlayer(videoController!),
                                    ).height(Sizes.s55).width(Sizes.s55)
                                  : Container(
                                      padding: const EdgeInsets.symmetric(horizontal: Insets.i4),
                                      height: Sizes.s55,
                                      width: Sizes.s55,
                                      alignment: Alignment.center,
                                      decoration: ShapeDecoration(
                                          color: appCtrl.appTheme.primary,
                                          shape: SmoothRectangleBorder(
                                            borderRadius: SmoothBorderRadius(
                                                cornerRadius: 12,
                                                cornerSmoothing: 1),
                                          )),
                                      child: const Text("C"))),
                ],
              ),
              if (appCtrl.usageControlsVal!.allowCreatingStatus!)
                if (widget.isShowAddIcon)
                  SizedBox(
                          child: Icon(Icons.add,
                                  size: Sizes.s15,
                                  color: appCtrl.appTheme.sameWhite)
                              .paddingAll(Insets.i2))
                      .decorated(
                          color: appCtrl.appTheme.primary,
                          borderRadius: BorderRadius.circular(AppRadius.r20),
                          border: Border.all(
                              color: appCtrl.appTheme.sameWhite, width: 1))
                      .inkWell(onTap: widget.onTap)
            ],
          ),
          const VSpace(Sizes.s8),
          Text(
                  widget.isShowAddIcon
                      ? appFonts.myStory.tr
                      : status!.username!.capitalizeFirst!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style:
                      AppCss.manropeBold12.textColor(appCtrl.appTheme.darkText))
              .width(Sizes.s60)
        ],
      ),
    );
  }
}
