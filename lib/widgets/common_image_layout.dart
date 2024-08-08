import '../config.dart';
import 'common_photo_view.dart';

class CommonImage extends StatelessWidget {
  final String? image, name;
  final double height, width;

  const CommonImage(
      {super.key,
      this.image,
      this.name,
      this.width = Sizes.s45,
      this.height = Sizes.s45})
     ;

  @override
  Widget build(BuildContext context) {

    return image != "" && image != null
        ? CachedNetworkImage(
            imageUrl: image!,
            imageBuilder: (context, imageProvider) => Container(
                  height: height,
                  width: width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover, image:imageProvider)
                  )
                ).inkWell(onTap: (){
                  Get.to(CommonPhotoView(image: image));
            }),
            placeholder: (context, url) => Container(
                  height: height,
                  width: width,
                  alignment: Alignment.center,
                  decoration:   BoxDecoration(
                      shape: BoxShape.circle,
                    color: appCtrl.appTheme.tick,
                  ),
                  child: Text(
                      name != null ?  name!.length > 2
                          ? name!
                              .replaceAll(" ", "")
                              .substring(0, 2)
                              .toUpperCase()
                          : name![0] : "C",
                      style: AppCss.manropeblack16
                          .textColor(appCtrl.appTheme.sameWhite)),
                ),
            errorWidget: (context, url, error) => Container(
                  height: height,
                  width: width,
                  alignment: Alignment.center,
                  decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                    color: appCtrl.appTheme.tick

                  ),
                  child: Text(
                    name!.length > 2
                        ? name!
                            .replaceAll(" ", "")
                            .substring(0, 2)
                            .toUpperCase()
                        : name![0],
                    style:
                        AppCss.manropeBold12.textColor(appCtrl.appTheme.sameWhite),
                  ),
                ))
        : Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration:   BoxDecoration(
              color: appCtrl.appTheme.tick,
                shape: BoxShape.circle
            ),
            child: Text(
                name!= null?  name!.isNotEmpty?   name!.length > 2
                  ? name!.replaceAll(" ", "").substring(0, 2).toUpperCase()
                  : name![0] : "C" :"C",
              style: AppCss.manropeBold12.textColor(appCtrl.appTheme.sameWhite)
            )
          );
  }
}
