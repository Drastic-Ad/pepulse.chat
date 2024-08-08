import 'package:chatzy/models/status_model.dart';
import 'package:chatzy/screens/bottom_screens/chat_screen/layouts/status_layout.dart';
import '../../../../config.dart';
import 'current_user_empty_status.dart';

class CurrentUserStatus extends StatelessWidget {
  final String? currentUserId;
  final Status? status;
  final GestureTapCallback? onTap;

  const CurrentUserStatus(
      {super.key, this.currentUserId, this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    return status == null
        ? CurrentUserEmptyStatus(currentUserId: currentUserId, onTap: onTap)
        : status!.photoUrl!.isNotEmpty
            ? StatusLayout(snapshot: status, onTap: onTap)
            : CurrentUserEmptyStatus(
                currentUserId: currentUserId, onTap: onTap);
  }
}

class SponsorStatus extends StatelessWidget {
  final Status? status;
  final GestureTapCallback? onTap;

  const SponsorStatus({super.key, this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    return status == null
        ? Container()
        : status!.photoUrl!.isEmpty
            ? Container()
            : StatusLayout(
                snapshot: status,
                onTap: onTap,
                isSponsor: true,
              ).marginOnly(right: Insets.i15);
  }
}
