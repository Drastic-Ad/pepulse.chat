import '../../../../config.dart';
import 'icon_creation.dart';

class ImagePickerLayout extends StatelessWidget {
  final GestureTapCallback? cameraTap,galleryTap;
  const ImagePickerLayout({super.key,this.cameraTap,this.galleryTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: Sizes.s150,
      color: appCtrl.appTheme.sameWhite,
      alignment: Alignment.bottomCenter,
      child: Column(children: [
        const VSpace(Sizes.s20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconCreation(
                icons: eImageAssets.liveCamera,
                color:appCtrl.appTheme.white ,
                text: appFonts.camera.tr,
                onTap: cameraTap),
            IconCreation(
                icons: eImageAssets.photos,
                color:appCtrl.appTheme.white,
                text: appFonts.gallery.tr,
                onTap:galleryTap),

          ],
        ),
      ]),
    );
  }
}
