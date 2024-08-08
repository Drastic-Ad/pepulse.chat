import 'package:intl/intl.dart';
import '../../../../config.dart';
import '../../../../widgets/common_image_layout.dart';
import 'group_card_sub_title.dart';

class GroupMessageCardLayout extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId;
  final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>? userSnapShot,
      snapshot;

  const GroupMessageCardLayout(
      {super.key,
      this.document,
      this.currentUserId,
      this.userSnapShot,
      this.snapshot})
     ;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                CommonImage(
                    image:( snapshot!.hasData && snapshot!.data!.exists && snapshot!.data!.data() != null )? (snapshot!.data!)["image"]:"",
                    name:( snapshot!.hasData && snapshot!.data!.exists && snapshot!.data!.data() != null )?  (snapshot!.data!)["name"]:document!['name']),
                const HSpace(Sizes.s12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(document!['name'],
                      style: AppCss.manropeblack14
                          .textColor(appCtrl.appTheme.darkText)),
                  const VSpace(Sizes.s5),
                  document!["lastMessage"] != null
                      ? GroupCardSubTitle(
                          currentUserId: currentUserId,
                          name:( userSnapShot!.hasData && userSnapShot!.data!.exists && userSnapShot!.data!.data() != null )?  userSnapShot!.data!["name"]:"",
                          document: document,
                          hasData: userSnapShot!.hasData)
                      : Container(height: Sizes.s15)
                ])
              ]),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(collectionName.groups)
                      .doc(document!["groupId"])
                      .collection(collectionName.chat)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      int number = getGroupUnseenMessagesNumber(snapshot.data!.docs);
                      return Column(
                        children: [
                          Text(
                              DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(document!['updateStamp']))),
                              style: AppCss.manropeMedium12
                                  .textColor(currentUserId == document!["senderId"]
                                      ? appCtrl.appTheme.darkText
                                      : number == 0
                                          ? appCtrl.appTheme.darkText
                                          : appCtrl.appTheme.primary)),
                          if ((currentUserId != document!["senderId"]))
                            number == 0
                                ? Container()
                                : Container(
                                    height: Sizes.s20,
                                    width: Sizes.s20,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: Insets.i5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            appCtrl.appTheme.primary,
                                            appCtrl.appTheme.primary
                                          ],
                                        )),
                                    child: Text(number.toString(),
                                        textAlign: TextAlign.center,
                                        style: AppCss.manropeBold10
                                            .textColor(appCtrl.appTheme.sameWhite)
                                            .textHeight(1.3))),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }),
            ]).paddingSymmetric(vertical: Insets.i10),
        Divider(height: 1,color: appCtrl.appTheme.borderColor,thickness: 1).paddingSymmetric(horizontal: Insets.i10)
      ],
    );
  }
}
