import '../../../../config.dart';

class ReceiverChatImage extends StatelessWidget {
  final String? id;
  const ReceiverChatImage({super.key,this.id});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionName.users)
            .where("id", isEqualTo: id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (!snapshot.data!.docs.isNotEmpty) {
              return Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: appCtrl.appTheme.borderColor,
                          shape:BoxShape.circle),
                      child: Image.asset(
                        eImageAssets.anonymous,
                        height: Sizes.s35,
                        width: Sizes.s35,
                        color: appCtrl.appTheme.white
                      ).paddingAll(Insets.i15))
                ]
              );
            } else {
              return CachedNetworkImage(
                  imageUrl: snapshot.data!.docs[0].data()["image"],
                  imageBuilder: (context, imageProvider) => Container(
                    height: Sizes.s35,
                    width: Sizes.s35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: appCtrl.appTheme.primary,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage('${snapshot.data!.docs[0].data()["image"]}')))
                  ),
                  placeholder: (context, url) => Container(
                    height: Sizes.s35,
                    width: Sizes.s35,
                    alignment: Alignment.center,
                    decoration:  BoxDecoration(
                        color: appCtrl.appTheme.primary,
                        shape: BoxShape.circle),
                    child: Text(
                        snapshot.data!.docs[0].data()["name"].length > 2
                            ? snapshot.data!.docs[0].data()["name"]
                            .replaceAll(" ", "")
                            .substring(0, 2)
                            .toUpperCase()
                            : snapshot.data!.docs[0].data()["name"][0],
                        style: AppCss.manropeblack16
                            .textColor(appCtrl.appTheme.white)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: Sizes.s35,
                    width: Sizes.s35,
                    alignment: Alignment.center,
                    decoration:  BoxDecoration(
                        color: appCtrl.appTheme.primary,
                        shape: BoxShape.circle),
                    child: Text(
                      snapshot.data!.docs[0].data()["name"].length > 2
                          ? snapshot.data!.docs[0].data()["name"]
                          .replaceAll(" ", "")
                          .substring(0, 2)
                          .toUpperCase()
                          : snapshot.data!.docs[0].data()["name"][0],
                      style:
                      AppCss.manropeblack16.textColor(appCtrl.appTheme.white),
                    ),
                  ));
            }
          } else {
            return Container(
              height: Sizes.s35,
              width: Sizes.s35,
              decoration: BoxDecoration(
                  color: appCtrl.appTheme.borderColor,
                  shape:BoxShape.circle),
              child: Image.asset(
                eImageAssets.anonymous,
                height: Sizes.s35,
                width: Sizes.s35,
                color: appCtrl.appTheme.white,
              ).paddingAll(Insets.i15),
            );
          }
        });
  }
}
