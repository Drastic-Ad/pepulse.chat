
import 'package:video_player/video_player.dart';

import '../../../../../config.dart';
import '../../../../widgets/common_video_view.dart';

class ChatVideo extends StatefulWidget {
  final dynamic snapshot;

  const ChatVideo({super.key, this.snapshot});

  @override
  State<ChatVideo> createState() => _ChatVideoState();
}

class _ChatVideoState extends State<ChatVideo> {
  VideoPlayerController? videoController;
  late Future<void> initializeVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    // TODO: implement initState

    videoController = VideoPlayerController.networkUrl(Uri.parse(widget.snapshot));
    initializeVideoPlayerFuture = videoController!.initialize();
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
            child: AspectRatio(
                    aspectRatio: videoController!.value.aspectRatio,

                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(videoController!))
                .height(Sizes.s70)
                .width(Sizes.s70))
        .inkWell(
            onTap: ()=> Get.to(CommonVideoView(snapshot: widget.snapshot)));
  }
}
