import 'package:video_player/video_player.dart';

import '../../../../config.dart';
import '../../../../models/status_model.dart';

class StatusVideo extends StatefulWidget {
  final Status? snapshot;

  const StatusVideo({super.key, this.snapshot});

  @override
  State<StatusVideo> createState() => _StatusVideoState();
}

class _StatusVideoState extends State<StatusVideo> {
  VideoPlayerController? videoController;
  late Future<void> initializeVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1]
            .statusType ==
        StatusType.video.name) {
      videoController = VideoPlayerController.networkUrl(
      Uri.parse(  widget
          .snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1].image!),
      );
      initializeVideoPlayerFuture = videoController!.initialize();
    }
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(


      borderRadius:  SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        // Use the VideoPlayer widget to display the video.
        child: VideoPlayer(videoController!),
      ).height(Sizes.s50).width(Sizes.s50)
    );
  }
}
