import 'dart:developer';

import 'package:chatzy/config.dart';

class LanguageController extends GetxController {
  int selectedIndex = 0;

  onTapLanguage(index) {
    selectedIndex = index;
    update();
  }

  //on language select
  onLanguageSelectTap(index, data) async {
    selectedIndex = index;
    /*if (data["code"].toString().contains("en")) {
      appCtrl.languageVal = "en";
    } else if (data["code"].toString().contains("hi")) {
      appCtrl.languageVal = "hi";
    } else if (data["code"].toString().contains("ar")) {
      appCtrl.languageVal = "ar";
    } else if (data["code"] == "ko") {
      appCtrl.languageVal = "ko";
    }*/
    appCtrl.languageVal = data["code"].toString().split("_")[0];

    appCtrl.update();
    await appCtrl.storage.write("index", selectedIndex);
    log("LANG CODE ${data["code"]}");
    log("LANG CODE ${data["code"]}");
    await appCtrl.storage.write(session.locale, data["code"]);
    Locale locale = Locale(data['code']);
    Get.updateLocale(locale);
    update();
    appCtrl.update();
    Get.forceAppUpdate();
  }


  List orderByName = [];

  getLanguageList() async {
    List storageList = appCtrl.storage.read(session.languageList) ?? [];
    Locale locale = appCtrl.locale!;
    if(storageList.isEmpty) {
      FirebaseFirestore.instance
          .collection(collectionName.languages)
          .doc(collectionName.language)
          .snapshots()
          .listen((event) {
        if (event.exists) {
          List lan = event.data()!["language"];

          appCtrl.languagesLists =
              lan.where((element) => element['isActive'] == true).toList();
        }
        appCtrl.languagesLists.sort((a, b) => a["title"].compareTo(b["title"]));
        appCtrl.update();
        appCtrl.storage.write(session.languageList, appCtrl.languagesLists);
        appCtrl.update();
        int index = appCtrl.languagesLists.indexWhere((element) {
          log("EL :${element["code"]}");
          return element['code'].toString() == locale.toString();
        });
        selectedIndex = index;
        update();
      });
    }else{
      if(storageList.isNotEmpty){
        appCtrl.languagesLists = storageList;
        appCtrl.update();
        int index = appCtrl.languagesLists.indexWhere((element) {
          log("EL :${element["code"]}");
          return element['code'].toString() == locale.toString();
        });
        selectedIndex = index;
        update();
      }
    }
  }
}
