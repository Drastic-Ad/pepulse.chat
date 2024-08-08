import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import '../../../../../config.dart';

class GroupVideoDoc extends StatefulWidget {
  final MessageModel? document;
final VoidCallback? onLongPress,onTap;
final bool isReceiver;
final String? currentUserId;
  const GroupVideoDoc({super.key, this.document,this.onLongPress,this.isReceiver = false, this.currentUserId,this.onTap});

  @override
  State<GroupVideoDoc> createState() => GroupVideoDocState();
}

class GroupVideoDocState extends State<GroupVideoDoc> {
  VideoPlayerController? videoController;
   Future<void>? initializeVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    // TODO: implement initState

    if (widget.document!.type == MessageType.video.name) {
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.document!.content!.contains("-BREAK-") ? widget.document!.content!.split("-BREAK-")[1] :widget.document!.content!),
      );
      initializeVideoPlayerFuture = videoController!.initialize();
    }
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return Stack(
              alignment: appCtrl.languageVal == "ar" || appCtrl.isRTL ? Alignment.bottomRight : Alignment.bottomLeft,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: Insets.i8),
                  padding: const EdgeInsets.all(Insets.i8),
                  decoration: ShapeDecoration(
                      color: appCtrl.appTheme.primary,
                      shape: const SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.only(
                              topLeft: SmoothRadius(
                                  cornerRadius: 20, cornerSmoothing: 1),
                              topRight: SmoothRadius(
                                  cornerRadius: 20, cornerSmoothing: 1),
                              bottomLeft: SmoothRadius(
                                  cornerRadius:  20,
                                  cornerSmoothing: 1),
                              bottomRight: SmoothRadius(
                                  cornerRadius: 20, cornerSmoothing: 1)))),
                  child: InkWell(
                    onLongPress: widget.onLongPress,
                    onTap: widget.onTap,
                    child: Stack(
                      alignment: appCtrl.isRTL || appCtrl.languageVal == "ar" ? Alignment.bottomRight : Alignment.bottomLeft,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (widget.isReceiver)
                                  if (widget.document!.sender != widget.currentUserId)
                                    Column(children: [
                                      Text(widget.document!.senderName!,
                                          style: AppCss.manropeMedium12
                                              .textColor(appCtrl.appTheme.primary)).paddingAll(Insets.i5).decorated(color: appCtrl.appTheme.white,borderRadius: BorderRadius.circular(AppRadius.r20)),
                                     const VSpace(Sizes.s5),

                                    ]),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r20)),
                                  child: AspectRatio(
                                    aspectRatio: videoController!.value.aspectRatio,
                                    // Use the VideoPlayer widget to display the video.
                                    child: VideoPlayer(videoController!)
                                  ).height(Sizes.s240),
                                ),
                                const VSpace(Sizes.s5),
                                IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (widget.document!.isFavourite != null)
                                        if (widget.document!.isFavourite == true)
                                          if(appCtrl.user["id"] == widget.document!.favouriteId.toString())
                                          Icon(Icons.star,color: appCtrl.appTheme.sameWhite,size: Sizes.s10),
                                        const HSpace(Sizes.s3),
                                        Text(
                                          DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(widget.document!.timestamp.toString()))),
                                          style:
                                          AppCss.manropeMedium12.textColor(appCtrl.appTheme.sameWhite),
                                        )
                                      ]
                                    ).paddingSymmetric(horizontal: Insets.i5)
                                )
                              ],
                            ),
                            IconButton(
                                icon: Icon(
                                    videoController!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: appCtrl.appTheme.white)
                                    .marginAll(Insets.i3)
                                    .decorated(
                                    color: appCtrl.appTheme.secondary,
                                    shape: BoxShape.circle),
                                onPressed: () {
                                  if (videoController!.value.isPlaying) {
                                    videoController!.pause();
                                  } else {
                                    // If the video is paused, play it.
                                    videoController!.play();
                                  }
                                  setState(() {});
                                })

                          ],
                        )

                      ]
                    ).inkWell(onTap: widget.onTap),
                  ),
                ).paddingOnly(bottom: widget.document!.emoji != null ? Insets.i8 : 0),
                if (widget.document!.emoji != null)
                  EmojiLayout(emoji: widget.document!.emoji)
              ],
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return  Container();
          }
        },
      );
    });
  }
}
