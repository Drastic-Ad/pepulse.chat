import 'package:intl/intl.dart';
import '../../../../config.dart';

class TrailingLayout extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, unSeenMessage;

  const TrailingLayout(
      {super.key, this.document, this.currentUserId, this.unSeenMessage})
     ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatDashController>(builder: (msgCtrl) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [


            StreamBuilder(
                stream: FirebaseFirestore.instance.collection(collectionName.users).doc(appCtrl.user["id"])
                    .collection(collectionName.messages)
                    .doc(document!["chatId"])
                    .collection(collectionName.chat).where("receiver",isEqualTo:  appCtrl.user["id"])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int number = getUnseenMessagesNumber(snapshot.data!.docs);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            DateFormat('HH:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document!['updateStamp']))),
                            style: AppCss.manropeMedium12.textColor(currentUserId == document!["senderId"] ? appCtrl.appTheme.darkText: number == 0? appCtrl.appTheme.darkText : appCtrl.appTheme.primary)),
                        if(appCtrl.user["id"] != document!["senderId"])
                          number == 0
                              ? Container()
                              : Container(
                              height: Sizes.s20,
                              width: Sizes.s20,alignment: Alignment.center,
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
                                  style: AppCss.manropeBold10.textColor(
                                      appCtrl.appTheme.white).textHeight(1.3))
                          ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                })
          ]).marginOnly(top: Insets.i8);
    });
  }
}
