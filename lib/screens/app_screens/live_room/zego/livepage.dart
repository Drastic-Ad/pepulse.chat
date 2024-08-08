import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class LivePage extends StatelessWidget {
  final String roomID;
  final bool isHost;
  final String userID;
  final String userName;

  const LivePage({
    Key? key,
    required this.roomID,
    required this.userID,
    required this.userName,
    this.isHost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveAudioRoom(
        appID:
            721748679, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            '524f99ece2e0414678b93fe6cf9d807b4345775bd91f9eadd5e7c7c89a2fc767', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userID,
        userName: userName,
        roomID: roomID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
            : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience(),
      ),
    );
  }
}
