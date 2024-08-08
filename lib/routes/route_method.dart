import 'package:chatzy/screens/app_screens/new_contact/new_contact.dart';
import 'package:chatzy/screens/app_screens/video_call/video_call.dart';
import 'package:chatzy/screens/auth_screens/login_screen/phone_wrap.dart';
import 'package:chatzy/screens/bottom_screens/chat_screen/layouts/status_view.dart';
import 'package:chatzy/widgets/edit_group_details_screen.dart';
import '../config.dart';
import '../screens/app_screens/audio_call/audio_call.dart';
import '../screens/app_screens/broadcast_chat/broadcast_chat.dart';
import '../screens/app_screens/broadcast_chat/layouts/broadcast_profile/broadcast_profile.dart';
import '../screens/app_screens/group_message_screen/group_chat_message.dart';
import '../screens/app_screens/group_message_screen/layouts/group_profile/add_participants.dart';
import '../screens/app_screens/group_message_screen/layouts/group_profile/group_profile.dart';

RouteName _routeName = RouteName();

class AppRoute {
  final List<GetPage> getPages = [
    GetPage(name: _routeName.onBoardingScreen, page: () => OnBoardingScreen()),
    GetPage(name: _routeName.loginScreen, page: () => LoginScreen()),
    GetPage(
        name: _routeName.profileSetupScreen, page: () => ProfileSetupScreen()),
    GetPage(
        name: _routeName.invitePeopleScreen,
        page: () => const InvitePeopleScreen()),
    GetPage(name: _routeName.dashboard, page: () => const Dashboard()),
    GetPage(name: _routeName.chatLayout, page: () => const Chat()),
//add voice room
    GetPage(
        name: _routeName.backgroundList, page: () => const BackgroundList()),
    GetPage(
        name: _routeName.chatUserProfile, page: () => const ChatUserProfile()),
    GetPage(name: _routeName.languageScreen, page: () => LanguageScreen()),
    GetPage(
        name: _routeName.fingerScannerScreen, page: () => FingerPrintScreen()),
    GetPage(name: _routeName.profileScreen, page: () => ProfileScreen()),
    GetPage(name: _routeName.statusView, page: () => const StatusScreenView()),
    GetPage(
        name: _routeName.groupMessageScreen, page: () => GroupMessageScreen()),
    GetPage(name: _routeName.groupTitleScreen, page: () => GroupTitleScreen()),
    GetPage(
        name: _routeName.groupChatMessage,
        page: () => const GroupChatMessage()),
    GetPage(name: _routeName.broadcastChat, page: () => const BroadcastChat()),
    GetPage(name: _routeName.groupProfile, page: () => const GroupProfile()),
    GetPage(
        name: _routeName.editGroupDetailScreen,
        page: () => EditGroupDetailScreen()),
    GetPage(
        name: _routeName.broadcastProfile,
        page: () => const BroadcastProfile()),
    GetPage(name: _routeName.addParticipants, page: () => AddParticipants()),
    GetPage(name: _routeName.audioCall, page: () => const AudioCall()),
    GetPage(name: _routeName.videoCall, page: () => const VideoCall()),
    GetPage(name: _routeName.phoneWrap, page: () => const PhoneWrap()),
    GetPage(name: _routeName.newContact, page: () => NewContact()),
  ];
}
