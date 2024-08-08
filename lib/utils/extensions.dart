import 'package:chatzy/config.dart';

extension ChatzyExtensions on Widget {
  Widget boxDecoration({Color? color ,double? bWidth}) => SizedBox(child: this).decorated(
      color: appCtrl.appTheme.white,
      boxShadow: [
        BoxShadow(
            color:  appCtrl.appTheme.borderColor.withOpacity(0.5),
            blurRadius: AppRadius.r5,
            spreadRadius: AppRadius.r2)
      ],
      border: Border.all(color: color ?? appCtrl.appTheme.borderColor,width: bWidth ?? 1),
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r8)));

  bottomNavDecoration() => SizedBox(child: this).decorated(
          boxShadow: [
            BoxShadow(
                color: appCtrl.appTheme.darkText.withOpacity(0.08),
                blurRadius: 7,
                spreadRadius: 2)
          ],
          color: appCtrl.appTheme.borderColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.r8),
              topRight: Radius.circular(AppRadius.r8)));

  Widget commonDecoration() => Container(child: this).decorated(
          color: appCtrl.appTheme.white,
          borderRadius: BorderRadius.circular(AppRadius.r10),
          boxShadow: [
            const BoxShadow(
                color: Color.fromRGBO(49, 100, 189, 0.08),
                offset: Offset(0, 2),
                blurRadius: 15)
          ]);

  Widget chatBgExtension(dynamic image) =>
      Container(child: this).backgroundImage(DecorationImage(
          image: NetworkImage(image ?? eImageAssets.bg2),
          fit: BoxFit.fill));

  Widget newBoxDecoration({Color? color ,double? bWidth}) => SizedBox(child: this).decorated(
      color: appCtrl.appTheme.white.withOpacity(0.15),
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r8)));
  
}

typedef StringCallback = void Function(int);
