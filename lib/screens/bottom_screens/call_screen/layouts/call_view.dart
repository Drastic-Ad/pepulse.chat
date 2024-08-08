import 'package:chatzy/controllers/bottom_controllers/call_list_controller.dart';
import 'package:chatzy/screens/bottom_screens/call_screen/layouts/call_icon.dart';
import 'package:chatzy/screens/bottom_screens/message/layout/image_layout.dart';

import '../../../../config.dart';

class CallView extends StatelessWidget {
  final AsyncSnapshot<dynamic>? snapshot;
  final int? index;
  final String? userId;

  const CallView({super.key, this.snapshot, this.index, this.userId})
     ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallListController>(builder: (callList) {
      return Stack(
        children: [
          SvgPicture.asset(eSvgAssets.pin)
              .padding(horizontal: appCtrl.isRTL || appCtrl.languageVal == "ar" ? MediaQuery.of(context).size.width / 6 : MediaQuery.of(context).size.width / 5.8,top: MediaQuery.of(context).size.height / 35),
          Column(children: [
            Row(
              children: [
                ImageLayout(
                    isLastSeen: false,
                    id: snapshot!.data!.docs[index!].data()["id"] ==
                            appCtrl.user["id"]
                        ? snapshot!.data!.docs[index!].data()["receiverId"]
                        : snapshot!.data!.docs[index!].data()["id"]),
              const HSpace(Sizes.s12),
                Expanded(
                  child: Container(
                  width: MediaQuery.of(context).size.width,
                    padding:const EdgeInsets.all(Insets.i15),
                    decoration: BoxDecoration(
                        color: appCtrl.appTheme.white,
                        boxShadow: [
                          BoxShadow(
                              color:  appCtrl.appTheme.borderColor.withOpacity(0.5),
                              blurRadius: AppRadius.r5,
                              spreadRadius: AppRadius.r2)
                        ],
                        border:
                            Border.all(color: const Color.fromRGBO(127, 131, 132, 0.15),width: 1.2),
                        borderRadius: BorderRadius.circular(AppRadius.r8)),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection(collectionName.users).doc(snapshot!.data!.docs[index!].data()["id"] ==
                          appCtrl.user["id"]
                          ? snapshot!.data!.docs[index!].data()["receiverId"]
                          : snapshot!.data!.docs[index!].data()["id"]).snapshots(),
                      builder: (context,snapShot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Sizes.s180,
                                  child: Text(
                                    snapShot.data != null && snapShot.data!.data() != null ? snapShot.data!.data()!['name']:
                                        "Anonymous",
                                    overflow: TextOverflow.clip,
                                    style: AppCss.manropeSemiBold14
                                        .textColor(appCtrl.appTheme.darkText),
                                  ),
                                ),
                                const VSpace(Sizes.s5),
                                CallIcon(snapshot: snapshot, index: index),
                              ],
                            ),
                            SvgPicture.asset(
                                snapshot!.data!.docs[index!].data()["isVideoCall"]
                                    ? eSvgAssets.callOut
                                    : eSvgAssets.video,
                                colorFilter: ColorFilter.mode(
                                    snapshot!.data!.docs[index!].data()['type'] ==
                                            'inComing'
                                        ? (snapshot!.data!.docs[index!]
                                                    .data()['started'] ==
                                                null
                                            ? snapshot!.data!.docs[index!]
                                                        .data()['receiverId'] ==
                                                    appCtrl.user["id"]
                                                ? appCtrl.appTheme.redColor
                                                : appCtrl.appTheme.primary
                                            : appCtrl.appTheme.primary)
                                        : (snapshot!.data!.docs[index!]
                                                    .data()['started'] ==
                                                null
                                            ? snapshot!.data!.docs[index!]
                                                        .data()['receiverId'] ==
                                                    appCtrl.user["id"]
                                                ? appCtrl.appTheme.redColor
                                                : appCtrl.appTheme.primary
                                            : appCtrl.appTheme.primary),
                                    BlendMode.srcIn))
                          ],
                        );
                      }
                    ),
                  ),
                )
              ],
            ).marginOnly(bottom: Insets.i20)

          ]).marginSymmetric(horizontal: Insets.i20),

        ],
      );
    });
  }
}
