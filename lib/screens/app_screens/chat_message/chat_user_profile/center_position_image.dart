import '../../../../../config.dart';
import '../../../../widgets/common_photo_view.dart';

class CenterPositionImage extends StatelessWidget {
  final int topAlign;
  final bool isSliverAppBarExpanded, isGroup, isBroadcast;
  final String? image, name;
  final GestureTapCallback? onTap;

  const CenterPositionImage(
      {super.key,
      this.topAlign = 5,
      this.isSliverAppBarExpanded = false,
      this.isGroup = false,
      this.isBroadcast = false,
      this.onTap,
      this.image,
      this.name})
     ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isBroadcast
            ? Container(
          height: Sizes.s240,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration:  BoxDecoration(
                  color: appCtrl.appTheme.borderColor,
                    borderRadius:  const BorderRadius.only(bottomLeft: Radius.circular(AppRadius.r6),bottomRight: Radius.circular(AppRadius.r6))),
                child: SvgPicture.asset(eSvgAssets.broadCast,height: Sizes.s60,width: Sizes.s60,colorFilter: ColorFilter.mode(appCtrl.appTheme.primary, BlendMode.srcIn)))
            : CachedNetworkImage(
                imageUrl: image!,
                imageBuilder: (context, imageProvider) => Container(
                        height: Sizes.s240,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: appCtrl.appTheme.primary,
                            image: DecorationImage(
                                fit: BoxFit.fill, image: imageProvider),
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(AppRadius.r6),
                                right: Radius.circular(AppRadius.r6))))
                    .inkWell(
                        onTap: () => Get.to(CommonPhotoView(
                              image: image,
                            ))),
                placeholder: (context, url) => Container(
                      height: Sizes.s240,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(AppRadius.r6),
                              right: Radius.circular(AppRadius.r6))),
                      child: Text(
                          name != null
                              ? name!.length > 2
                                  ? name!
                                      .replaceAll(" ", "")
                                      .substring(0, 2)
                                      .toUpperCase()
                                  : name![0]
                              : "C",
                          style: AppCss.manropeblack16
                              .textColor(appCtrl.appTheme.white)),
                    ),
                errorWidget: (context, url, error) => Container(
                      height: Sizes.s240,
                      alignment: Alignment.center,
                      decoration:  BoxDecoration(
                          color: appCtrl.appTheme.primary,
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(AppRadius.r6),
                              right: Radius.circular(AppRadius.r6))),
                      child: SizedBox(
                        child: Text(
                          name != null && name != ""
                              ? name!.length > 2
                                  ? name!
                                      .replaceAll(" ", "")
                                      .substring(0, 2)
                                      .toUpperCase()
                                  : name![0]
                              : "C",
                          style: AppCss.manropeblack16
                              .textColor(appCtrl.appTheme.white),
                        ).paddingAll(Insets.i20),
                      ).decorated(color: appCtrl.appTheme.sameWhite.withOpacity(0.3),shape: BoxShape.circle),
                    )),
      ],
    );
  }
}
