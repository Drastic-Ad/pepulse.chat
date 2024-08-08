import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatzy/controllers/app_pages_controllers/video_call_controller.dart';

import '../../../../config.dart';

class VideoCallClass {
  //build video call view

  Widget buildNormalVideoUI() {
    return GetBuilder<VideoCallController>(builder: (videoCtrl) {
      log("viewa : ${videoCtrl.remoteUId}");
      log("viewa : ${videoCtrl.users}");
      return SizedBox(height: Get.height, child: buildJoinUserUI(videoCtrl));
    });
  }

  //join user
  Widget buildJoinUserUI(VideoCallController? videoCtrl) {
    final views = _getRenderViews(videoCtrl);
    log("views : ${views.length}");
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[_videoView(views[0])],
        );
      case 2:
        return GetBuilder<VideoCallController>(builder: (videoCallCtrl) {
          return SizedBox(
              width: Get.width,
              height: Get.height,
              child: Stack(children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Column(children: <Widget>[
                      _expandedVideoRow([views[1]])
                    ])),
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: Sizes.s8, color: Colors.white38),
                            borderRadius: BorderRadius.circular(Insets.i10)),
                        margin: const EdgeInsets.fromLTRB(
                            Insets.i15, Insets.i40, Insets.i10, Insets.i15),
                        width: Sizes.s110,
                        height: Sizes.s140,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _expandedVideoRow([views[0]])
                            ])))
              ]));
        });
      case 3:
        return Column(children: <Widget>[
          _expandedVideoRow(views.sublist(0, 2)),
          _expandedVideoRow(views.sublist(2, 3))
        ]);
      case 4:
        return Column(children: <Widget>[
          _expandedVideoRow(views.sublist(0, 2)),
          _expandedVideoRow(views.sublist(2, 4))
        ]);
      default:
    }
    return Container();
  }

  //user view
  List<Widget> _getRenderViews(VideoCallController? videoCallCtrl) {
    final List<AgoraVideoView> list = [
      AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: videoCallCtrl!.engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      )
    ];
    videoCallCtrl.users
        .asMap()
        .entries
        .forEach((uid) => list.add(AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: videoCallCtrl.engine,
                canvas: VideoCanvas(uid: uid.value),
              ),
            )));

    log("AGORA : $list");
    return list;
  }

  //video view
  Widget _videoView(view) {
    return GetBuilder<VideoCallController>(builder: (videoCallCtrl) {
      return Expanded(child: Container(child: view));
    });
  }

  //multiple user add view
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return GetBuilder<VideoCallController>(builder: (videoCallCtrl) {
      return Expanded(child: Row(children: wrappedViews));
    });
  }


}
