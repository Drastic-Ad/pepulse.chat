import '../../../../../../config.dart';
import '../../../widgets/common_app_bar.dart';
import 'layouts/wallpaper_layout.dart';

class BackgroundList extends StatefulWidget {
  const BackgroundList({super.key});

  @override
  State<BackgroundList> createState() => _BackgroundListState();
}

class _BackgroundListState extends State<BackgroundList> {

  String? chatId, groupId, broadcastId;

  @override
  void initState() {
    // TODO: implement initState
   /* var data = Get.arguments;
    if (data["chatId"] != null) {
      chatId = data["chatId"];
    }
    if (data["groupId"] != null) {
      groupId = data["groupId"];
    }
    if (data["broadcastId"] != null) {
      broadcastId = data["broadcastId"];
    }
    setState(() {});*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DirectionalityRtl(
      child: Scaffold(
        backgroundColor: appCtrl.appTheme.screenBG,
        appBar: CommonAppBar(text: appFonts.defaultWallpaper.tr),
        body: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(collectionName.wallpaper)

                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container();
                  } else if (snapshot.hasData) {

                    if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
                     return Column(

                       children: [
                       ...snapshot.data!.docs.asMap().entries.map((e){
                         List image = e.value['image'];
                         return Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             if(e.key !=0)
                             const VSpace(Sizes.s15),
                             Text(e.value['type'].toString().capitalizeFirst!,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)),
                             const VSpace(Sizes.s15),
                             WallpaperLayout(wallpaperList: image),
                            /* Text(appFonts.lightWallpaper.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)).paddingOnly(bottom: Insets.i15,top: Insets.i25),
                             WallpaperLayout(wallpaperList: appArray.lightWallpaper),
                             Text(appFonts.darkWallpaper.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)).paddingOnly(bottom: Insets.i15,top: Insets.i25),
                             WallpaperLayout(wallpaperList: appArray.darkWallpaper)*/
                           ],
                         );
                       })
                         /*Text(appFonts.solidWallpaper.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)),
                         const VSpace(Sizes.s15),
                         WallpaperLayout(wallpaperList: appArray.solidWallpaper),
                         Text(appFonts.lightWallpaper.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)).paddingOnly(bottom: Insets.i15,top: Insets.i25),
                         WallpaperLayout(wallpaperList: appArray.lightWallpaper),
                         Text(appFonts.darkWallpaper.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)).paddingOnly(bottom: Insets.i15,top: Insets.i25),
                         WallpaperLayout(wallpaperList: appArray.darkWallpaper)*/

                       ],
                     );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                })
           /* Row(
              children: [
                SvgPicture.asset(eSvgAssets.wallpaper),
                const HSpace(Sizes.s10),
                Text("Default Background",
                        style: AppCss.manropeSemiBold16
                            .textColor(appCtrl.appTheme.darkText))
                    .inkWell(onTap: () async {
                  */
            /*if (chatId != null) {
                    dynamic userData = appCtrl.storage.read(session.user);
                    await FirebaseFirestore.instance
                        .collection(collectionName.users)
                        .doc(userData["id"])
                        .collection(collectionName.chats)
                        .where("chatId",
                        isEqualTo: chatId)
                        .limit(1)
                        .get()
                        .then((userChat) {
                      if(userChat.docs.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection(
                            collectionName.users)
                            .doc(userData["id"])
                            .collection(
                            collectionName.chats)
                            .doc(userChat.docs[0].id)
                            .update(
                            {
                              'backgroundImage': ""
                            });
                      }
                    });
                  }
                  if (groupId != null) {
                    await FirebaseFirestore.instance
                        .collection(collectionName.groups)
                        .doc(groupId)
                        .update({'backgroundImage': ""});
                  }
                  if (broadcastId != null) {
                    await FirebaseFirestore.instance
                        .collection(collectionName.broadcast)
                        .doc(broadcastId)
                        .update({'backgroundImage': ""});
                  }
                  Get.back();*//*
                }),
              ],
            ).marginSymmetric(horizontal: Insets.i15),
            const VSpace(Sizes.s20),*/
          /*  Text(appFonts.solidWallpaper.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)),
            const VSpace(Sizes.s15),
            WallpaperLayout(wallpaperList: appArray.solidWallpaper),
            Text(appFonts.lightWallpaper.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)).paddingOnly(bottom: Insets.i15,top: Insets.i25),
            WallpaperLayout(wallpaperList: appArray.lightWallpaper),
            Text(appFonts.darkWallpaper.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)).paddingOnly(bottom: Insets.i15,top: Insets.i25),
            WallpaperLayout(wallpaperList: appArray.darkWallpaper),*/
           /* StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(collectionName.wallpaper)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(Insets.i20),
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 20,
                              mainAxisExtent: 216,
                              mainAxisSpacing: 20.0,
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,

                          //color: Colors.black.withOpacity(0.4), colorBlendMode: BlendMode.darken,
                          height: Sizes.s210,
                          decoration: BoxDecoration(
                              color: appCtrl.appTheme.screenBG,
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    color: Color.fromRGBO(0, 0, 0, 0.08))
                              ],
                              borderRadius: BorderRadius.circular(AppRadius.r10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      snapshot.data!.docs[index]["image"]!))),
                        ).inkWell(
                            onTap: () => Get.back(
                                result: snapshot.data!.docs[index]["image"]));
                      },
                    );
                  } else {
                    return Container();
                  }
                }),*/
          ],
        ).paddingSymmetric(horizontal: Insets.i20),
      ),
    );
  }
}
