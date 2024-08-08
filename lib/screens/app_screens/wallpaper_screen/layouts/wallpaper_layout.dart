import '../../../../config.dart';

class WallpaperLayout extends StatelessWidget {
  final List? wallpaperList;

  const WallpaperLayout({super.key, this.wallpaperList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: wallpaperList!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 20,
          mainAxisExtent: 216,
          mainAxisSpacing: 20.0,
          crossAxisCount: 2),
      itemBuilder: (context, index) {
        /*   return Container(
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
              borderRadius: BorderRadius.circular(AppRadius.r14)
          ),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r10)),
              child: Image.network(wallpaperList![index],fit: BoxFit.fill))
        ).inkWell(
            onTap: () => Get.back(
                result: wallpaperList![index]));*/
        return CachedNetworkImage(
          imageUrl: wallpaperList![index],
          imageBuilder: (context, imageProvider) => Container(
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
                      borderRadius: BorderRadius.circular(AppRadius.r14)),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppRadius.r10)),
                      child: Image(image: imageProvider, fit: BoxFit.fill)))
              .inkWell(onTap: () => Get.back(result: wallpaperList![index])),
          errorWidget: (context, url, error) => Container(
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
                  borderRadius: BorderRadius.circular(AppRadius.r14)),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppRadius.r10)),
                  child: Image.asset(eImageAssets.appLogo, fit: BoxFit.fill))),
        );
      },
    );
  }
}
