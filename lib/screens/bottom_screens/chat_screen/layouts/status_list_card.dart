import 'dart:math';
import 'package:chatzy/screens/bottom_screens/chat_screen/layouts/stat_video.dart';
import 'package:intl/intl.dart';
import '../../../../config.dart';
import '../../../../models/status_model.dart';
import '../../../../widgets/common_image_layout.dart';

double radius = 27.0;

double colorWidth(double radius, int statusCount, double separation) {
  return ((2 * pi * radius) - (statusCount * separation)) / statusCount;
}

double separation(int statusCount) {
  if (statusCount <= 20) {
    return 3.0;
  } else if (statusCount <= 30) {
    return 1.8;
  } else if (statusCount <= 60) {
    return 1.0;
  } else {
    return 0.3;
  }
}

class StatusListCard extends StatelessWidget {
  final Status? snapshot;
  final bool isUserStatus,isSeen;

  const StatusListCard({super.key, this.snapshot,this.isUserStatus = true,this.isSeen = false})
     ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatusController>(builder: (statusCtrl) {
      return Column(mainAxisSize: MainAxisSize.min,children: [
        ListTile(
          horizontalTitleGap: 10,
          contentPadding: const EdgeInsets.symmetric(horizontal: Insets.i15),
          subtitle: Row(children: [
            Text(
                DateFormat("dd/MM/yyyy").format(statusCtrl.date) ==
                        DateFormat('dd/MM/yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(snapshot!.createdAt!)))
                    ? appFonts.today.tr
                    : appFonts.yesterday.tr,
                style: AppCss.manropeMedium12
                    .textColor(appCtrl.appTheme.greyText)),
            Text(
                DateFormat('HH:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(snapshot!.createdAt!))),
                style: AppCss.manropeMedium12
                    .textColor(appCtrl.appTheme.greyText)),
          ]),
          title:  Text(isUserStatus ?  snapshot!.username! : "Sponsor",
              style: AppCss.manropeblack14.textColor(appCtrl.appTheme.txt)),
          leading: DottedBorder(
            color: isSeen ?appCtrl.appTheme.greyText : appCtrl.appTheme.primary,
            padding: const EdgeInsets.all(Insets.i2),
            borderType: BorderType.RRect,
            strokeCap: StrokeCap.round,
            radius: const SmoothRadius(
              cornerRadius: 15,
              cornerSmoothing: 1,
            ),
            dashPattern: snapshot!.photoUrl!.length == 1
                ? [
                    //one status
                    (2 * pi * (radius + 2)),
                    0,
                  ]
                : [
                    //multiple status
                    colorWidth(radius + 2, snapshot!.photoUrl!.length,
                        separation(snapshot!.photoUrl!.length)),
                    separation(snapshot!.photoUrl!.length),
                  ],
            strokeWidth: 1,
            child: Stack(alignment: Alignment.bottomRight, children: [
              snapshot!.photoUrl!.isEmpty? Container():   snapshot!.photoUrl![snapshot!.photoUrl!.length - 1].statusType ==
                      StatusType.text.name
                  ? Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: Insets.i4),
                      height: Sizes.s50,
                      width: Sizes.s50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(int.parse(
                            snapshot!
                                .photoUrl![snapshot!.photoUrl!.length - 1]
                                .statusBgColor!,
                            radix: 16)),
                        shape: BoxShape.circle
                      ),
                      child: Text(
                        snapshot!.photoUrl![snapshot!.photoUrl!.length - 1]
                            .statusText!,
                        textAlign: TextAlign.center,
                        style: AppCss.manropeMedium10
                            .textColor(appCtrl.appTheme.white),
                      ),
                    )
                  : snapshot!.photoUrl![snapshot!.photoUrl!.length - 1]
                              .statusType ==
                          StatusType.image.name
                      ? CommonImage(
                          height: Sizes.s50,
                          width: Sizes.s50,
                          image: snapshot!
                              .photoUrl![snapshot!.photoUrl!.length - 1].image
                              .toString(),
                          name: isUserStatus ? snapshot!.username : "C",
                        )
                      : StatusVideo(snapshot: snapshot!),
            ]),
          ),
        )
      ]);
    });
  }
}
