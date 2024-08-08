import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:photo_view/photo_view.dart';
import '../config.dart';
import 'common_loader.dart';

class CommonPhotoView extends StatefulWidget {
  final String? image;

  const CommonPhotoView({super.key, this.image});

  @override
  State<CommonPhotoView> createState() => _CommonPhotoViewState();
}

class _CommonPhotoViewState extends State<CommonPhotoView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appCtrl.appTheme.sameBlack,
      appBar: AppBar(
        backgroundColor: appCtrl.appTheme.sameBlack,
        actions: [
          Icon(Icons.download_outlined, color: appCtrl.appTheme.white)
              .marginSymmetric(horizontal: Insets.i20)
              .inkWell(onTap: () async {
                log("IMAGE URL :${widget.image}");
            final androidInfo = await DeviceInfoPlugin().androidInfo;
            late final Map<Permission, PermissionStatus> status;

            if (Platform.isAndroid) {
              if (androidInfo.version.sdkInt <= 32) {
                status = await [Permission.storage].request();
              } else {
                status = await [Permission.photos].request();
              }
            } else {
              status = await [Permission.photosAddOnly].request();
            }

            var allAccept = true;
            status.forEach((permission, status) {
              if (status != PermissionStatus.granted) {
                allAccept = false;
              }
            });

            if (allAccept) {
              isLoading = true;
              setState(() {

              });
              isLoading = false;
              setState(() {

              });
              Get.snackbar('Success', "Image Downloaded Successfully",
                  backgroundColor: appCtrl.appTheme.icon,
                  colorText: appCtrl.appTheme.white);

              setState(() {

              });
            } else {
              isLoading = false;
              Get.snackbar('Alert!', "Something Went Wrong",
                  backgroundColor: appCtrl.appTheme.error,
                  colorText: appCtrl.appTheme.white);
              setState(() {

              });
            }
          })
        ],
      ),
      body:  Stack(
        children: [
          PhotoView(imageProvider: NetworkImage(widget.image!)),
          if(isLoading)
            const CommonLoader()
        ],
      ),
    );
  }
}
