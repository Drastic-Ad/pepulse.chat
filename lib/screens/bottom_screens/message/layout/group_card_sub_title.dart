import '../../../../config.dart';

class GroupCardSubTitle extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? name, currentUserId;
  final bool hasData;

  const GroupCardSubTitle(
      {super.key,
      this.document,
      this.name,
      this.currentUserId,
      this.hasData = false})
     ;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        if (currentUserId == document!["senderId"])
          if(document!["lastMessage"] != "" && document!["lastMessage"] != null)
          Icon(Icons.done_all,
              color: appCtrl.isTheme
                  ? appCtrl.appTheme.white
                  : appCtrl.appTheme.greyText,
              size: Sizes.s16),
        if (currentUserId == document!["senderId"])
        const HSpace(Sizes.s5),
        if(document!["lastMessage"] != "" && document!["lastMessage"] != null)
        (decryptMessage(document!["lastMessage"]).contains(".gif"))
            ? const Icon(
                Icons.gif_box,
                size: Sizes.s20,
              ).alignment(Alignment.centerLeft)
            : SizedBox(
          width: Sizes.s150,
              child: Text(
                  document!["lastMessage"] == "" && document!["lastMessage"] != null ? "":
                  (decryptMessage(document!["lastMessage"]).contains("media"))
                      ? hasData
                          ? "$name Media Share"
                          : "Media Share"
                      : (decryptMessage(document!["lastMessage"]).contains(".pdf") ||
                              decryptMessage(document!["lastMessage"]).contains(".doc") ||
                              decryptMessage(document!["lastMessage"]).contains(".mp3") ||
                              decryptMessage(document!["lastMessage"]).contains(".mp4") ||
                              decryptMessage(document!["lastMessage"]).contains(".xlsx") ||
                              decryptMessage(document!["lastMessage"]).contains(".ods"))
                          ? decryptMessage(document!["lastMessage"]).split("-BREAK-")[0]
                          : decryptMessage(document!["lastMessage"]) == ""
                              ? currentUserId == document!["senderId"]
                                  ? "Welcome ${document!["group"]['name']}"
                                  : "${document!["sender"]['name']} added you"
                              : decryptMessage(document!["lastMessage"]),
                  overflow: TextOverflow.ellipsis,
                  style: AppCss.manropeMedium12
                      .textColor(appCtrl.appTheme.darkText)
                      .textHeight(1.2)
                      .letterSpace(.2)).width(Sizes.s170),
            ),
      ],
    );
  }
}
