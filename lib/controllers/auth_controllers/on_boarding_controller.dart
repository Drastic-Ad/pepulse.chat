import 'dart:async';
import 'dart:math';

import 'package:chatzy/config.dart';


class OnBoardingController extends GetxController {

  int selectIndex = 0;

  List<String> randomPics = [eImageAssets.selfie1, eImageAssets.selfie2];
  List<String> randomPics2 = [eImageAssets.selfie3, eImageAssets.selfie4];
  String photo = eImageAssets.selfie1;
  String photo2 = eImageAssets.selfie3;
  final random = Random();
  final random2 = Random();
  bool selected = true;
  bool isPositionedRight = false;
  SharedPreferences? pref;

  configureTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final int index = random.nextInt(randomPics.length);
        photo = randomPics[index];
      final int index2 = random2.nextInt(randomPics2.length);
      photo2 = randomPics2[index2];
      update();
    });
  }

  onFloatImage () {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      isPositionedRight = !isPositionedRight;
      update();
    });
  }

  onTapPageChange() {
    selectIndex++;
    if(selectIndex == 3) {
      appCtrl.storage.write("onBoard", true);
      update();
      Get.offAllNamed(routeName.loginScreen, arguments: pref);
      update();
    }
    update();
  }

  @override
  void onReady() {
    pref = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) => configureTimer());
    WidgetsBinding.instance.addPostFrameCallback((_) => onFloatImage());
    update();
    // TODO: implement onReady
    super.onReady();
  }

}