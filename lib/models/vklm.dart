import 'dart:convert';

import '../config.dart';


k64(e) {
  var output = '';
  var chars = "~!@";
  chars += "abcdefghijklmnopqrstuvwxyz";
  chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  chars += "~!@";
  chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_';
  var r = [];
  var count = r.length;
  RegExp regex = RegExp('/[^0-9]/g');
  var nr = int.parse(count.toString().replaceAll(regex, ""));
  var rn = count.round();
  var forNum225 = (int.parse(nr.toString()) + int.parse(rn.toString())).toString();
  Codec<String, String> vn = utf8.fuse(base64);
  var arNbr = forNum225.split(",");
  var xParts = ['K', 'M', 'B', 'T', 'Q'];
  var msl =  vn.decode(e);
  output = msl;
  var xCountParts = arNbr.length - 1 + 2;
  var dn = arNbr[0] + (int.parse(arNbr[0][0]) != 0 ? '.${arNbr[0][0]}' : '');
  dn += xParts[xCountParts - 1];
  return output;
}

DocumentSnapshot<Map<String, dynamic>>? doc, uc;

ak76(keycode) {
  Codec<String, String> stringToBase64 =
  utf8.fuse(base64); // dXNlcm5hbWU6cGFzc3dvcmQ=
  String k84 = stringToBase64.encode(keycode);
  return k84;
}


String a2V5 = "a2V5";
String vamVjcH = "cHJvamVjdF9pZA==";

final a25 = FirebaseFirestore.instance
    .collection(k64(collectionName.col12AK))
    .doc(collectionName.users)
    .get();

final r25 =FirebaseFirestore.instance
    .collection(k64(collectionName.col12AK))
    .doc(collectionName.users);

rmt()async{

 await FirebaseFirestore.instance
      .collection(k64(collectionName.nkfig))
      .doc(collectionName.usageControls)
      .get().then((value) {
    doc = value;
  });
 return doc;
}


uct()async{

  await FirebaseFirestore.instance
      .collection(k64(collectionName.nkfig))
      .doc(collectionName.userAppSettings)
      .get().then((value) {
    doc = value;
  });
  return doc;
}

successSheet(prefs,rma,uc) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10),
        topLeft: Radius.circular(10),
      ),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.49,
        decoration: BoxDecoration(
          color: appCtrl.appTheme.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 17, 28, 17),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                height: 40,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close_outlined,
                      color: Colors.blueGrey.withOpacity(0.5),
                    )),
              ),
              Icon(
                Icons.check_circle_outline_outlined,
                color: appCtrl.appTheme.primary,
                size: 80,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Successfully License Verify & Install ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.4,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
              const VSpace(Sizes.s20),
              const Text(
                "Yuppy!!, Now you can access Pepulse code",
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.4),
              ),
              const VSpace(Sizes.s20),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: Sizes.s46,
                  decoration: BoxDecoration(
                      color: appCtrl.appTheme.primary,
                      borderRadius: BorderRadius.circular(AppRadius.r10)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                    Text("Ready to go for use".tr,
                        textAlign: TextAlign.center,
                        style:AppCss.manropeBold14.textColor(appCtrl.appTheme.white)),
                    const HSpace(Sizes.s20),
                    Icon(Icons.arrow_forward,color: appCtrl.appTheme.white,)
                  ])).inkWell(onTap: (){
                Get.back();
                Get.to(() => SplashScreen(pref: prefs,rm: rma,uc: uc,));
              })
            ],
          ),
        ),
      );
    },
    context: Get.context!,
  );
}
