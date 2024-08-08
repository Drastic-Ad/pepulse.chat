import '../config.dart';

flutterAlertMessage ({msg,bgColor}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor ?? appCtrl.appTheme.redColor,
      textColor: appCtrl.appTheme.sameWhite,
      fontSize: Sizes.s16
  );
}