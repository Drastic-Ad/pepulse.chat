import '../../../../../config.dart';
import '../../../../widgets/common_photo_view.dart';

class ChatUserProfileTitle extends StatelessWidget {
  final bool isSliverAppBarExpanded,isBroadcast;
  final String? image, name;

  const ChatUserProfileTitle(
      {super.key, this.isSliverAppBarExpanded = false,this.isBroadcast = false, this.name, this.image})
     ;

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
        duration: const Duration(milliseconds: 2),
        alignment: !isSliverAppBarExpanded
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: AnimatedContainer(
            height: !isSliverAppBarExpanded ? 0 : Sizes.s45,
            duration: const Duration(milliseconds: 1),
            child: AnimatedOpacity(
                opacity: !isSliverAppBarExpanded ? 0 : 1,
                duration: const Duration(milliseconds: 1),
                child: isBroadcast ? Container(
                    height: Sizes.s45,
                    width: Sizes.s45,
                    alignment: Alignment.center,
                    padding:
                    const EdgeInsets.symmetric(vertical: Insets.i10),
                    decoration: ShapeDecoration(
                        color: appCtrl.appTheme.secondary,
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                              cornerRadius: 13, cornerSmoothing: 1),
                        ),
                        image:isBroadcast ?DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage(eImageAssets.profileAnon)) : DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(image!))),
                    child: SvgPicture.asset(eSvgAssets.people)): CachedNetworkImage(
                    imageUrl: image!,
                    imageBuilder: (context, imageProvider) => Container(
                        height: Sizes.s45,
                        width: Sizes.s45,
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                            color: appCtrl.appTheme.borderColor,
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: 13, cornerSmoothing: 1)),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage('$image')))).inkWell(onTap: ()=> Get.to(CommonPhotoView(image: image,))),
                    placeholder: (context, url) => Container(
                        height: Sizes.s45,
                        width: Sizes.s45,
                        alignment: Alignment.center,
                        padding:
                            const EdgeInsets.symmetric(vertical: Insets.i10),
                        decoration: ShapeDecoration(
                            color: appCtrl.appTheme.secondary,
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: 13, cornerSmoothing: 1),
                            ),
                        ),
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
                                .textColor(appCtrl.appTheme.white))),
                    errorWidget: (context, url, error) => Container(
                        height: Sizes.s45,
                        width: Sizes.s45,
                        alignment: Alignment.center,
                        padding:
                            const EdgeInsets.symmetric(vertical: Insets.i8),
                        decoration: ShapeDecoration(
                          color: appCtrl.appTheme.secondary,
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 13, cornerSmoothing: 1),
                          ),
                        ),
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
                                .textColor(appCtrl.appTheme.white)))))));
  }
}
