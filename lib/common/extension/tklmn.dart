import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';
import '../../models/vklm.dart';
import '../../utils/snack_and_dialogs_utils.dart';

class CallFunc extends StatefulWidget {
  final SharedPreferences? prefs;

  const CallFunc({super.key, this.prefs});

  @override
  CallFuncState createState() => CallFuncState();
}

class CallFuncState extends State<CallFunc> {
  bool isLoading = true, isCircular = false;
  SharedPreferences? prefs;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  bool isDocHave = false, isCheckAK = true;
  DocumentSnapshot<Map<String, dynamic>>? doc, uc;
  String sV1 = "", sV2 = "", sV3 = "", sV4 = "", sV5 = "", sV6 = "", sV7 = "";

  String k20 = appFonts.codeBase;
  String k21 = appFonts.akCodeBase64Id;
  String k22 = appFonts.akCodeBaseLink;
  String k27 = a2V5;
  bool isA1 = false, isA2 = false, isA3 = false, isA4 = false;

  initialise() async {
    isLoading = true;
    prefs = widget.prefs;

    // if (anikanisani() != "dHJ1ZQ==") {
    /*await a25.then((mn) async {
        if (mn.exists) {
          final docHae = mn.data();

          List list = docHae!.keys.toList();

          list.asMap().entries.forEach((a) {
            if (a.key == 0) {
              isA1 = ak76(k21) == ak76(a.value);
            }
            if (a.key == 1) {
              isA2 = ak76(k20) == ak76(a.value);
            }
            if (a.key == 2) {
              isA3 = ak76(k22) == ak76(a.value);
            }
            if (a.key == 3) {
              isA4 = ak76(k27) == ak76(a.value);
            }
          });

          setState(() {});

          if (isA1) {
            if (isA2) {
              if (isA3) {
                if (isA4) {
                  await rmt().then((e) {
                    doc = e;
                    setState(() {});
                  });
                  await uct().then((e) {
                    uc = e;
                    setState(() {});
                  });

                  setState(() {});
                  isDocHave = true;
                  isCheckAK = false;
                  isLoading = false;
                } else {
                  setState(() {
                    isDocHave = false;
                    isCheckAK = false;
                    isLoading = false;
                  });
                }
              } else {
                setState(() {
                  isDocHave = false;
                  isCheckAK = false;
                  isLoading = false;
                });
              }
            } else {
              setState(() {
                isDocHave = false;
                isCheckAK = false;
                isLoading = false;
              });
            }
          } else {
            setState(() {
              isDocHave = false;
              isCheckAK = false;
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isDocHave = false;
            isCheckAK = false;
            isLoading = false;
          });
        }
      }).catchError((onError) async {
        isCheckAK = false;
        isLoading = false;
        setState(() {});
        if (happens(onError)) {
          isDocHave = false;
          flutterAlertMessage(msg: onError.message);
          setState(() {});
        }
      });*/
    //}
    /*else {
      await rmt().then((e) {
        doc = e;
        setState(() {});
      });
      await uct().then((e) {
        uc = e;
        setState(() {});
      });
      isDocHave = true;
      setState(() {});
      debugPrint("SSSS");
      debugPrint("SSSS $doc");
      debugPrint("SSSS $uc");
      isCheckAK = true;
      setState(() {});
      isLoading = false;
      setState(() {});
    }*/

    await rmt().then((e) {
      doc = e;
      setState(() {});
    });
    await uct().then((e) {
      uc = e;
      setState(() {});
    });
    isDocHave = true;
    setState(() {});
    debugPrint("SSSS");
    debugPrint("SSSS $doc");
    debugPrint("SSSS $uc");
    isCheckAK = true;
    setState(() {});
    isLoading = false;
    setState(() {});

    setState(() {});
  }

  @override
  void initState() {
    initialise();

    super.initState();
  }

  FirebaseApp? app = Firebase.app();

  dest2(String c, String sk3, String sk4) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    final dio = Dio();
    isCircular = true;
    setState(() {});

    String k98 = app!.options.projectId;

    String k10 = k64(appFonts.codeBase);
    String k11 = k64(appFonts.akCodeBase64Id);
    String k12 = k64(appFonts.akCodeBaseLink);
    String k13 = k64(c);
    String k14 = k64(sk3);
    String k15 = k64(sk4);
    String k16 = k64(appFonts.akCodeBaseLink24);
    String k17 = k64(a2V5);
    var data = {k17: k13, k10: k14, k11: k15, k12: k98};
    log("DATA :$data");
    try {
      var response = await dio.post(k16, data: data);
      log("response :$response");
      if (response.statusCode == 200) {
        //get response
        var responseData = response.data;
        sV2 = a2V5;
        sV1 = appFonts.codeBase;
        sV6 = appFonts.akCodeBase64Id;
        sV3 = appFonts.akCodeBaseLink;

        await r25
            .set({sV2: c, sV1: k15, sV6: sk4, sV3: ak76(k98)}).then((v) async {
          await rmt().then((e) {
            doc = e;
            setState(() {});
          });
          await uct().then((e) {
            uc = e;
            setState(() {});
          });
          isCircular = false;
          setState(() {});
          successSheet(prefs, doc, uc)!;
        }).catchError((onError) async {
          isCheckAK = false;
          setState(() {});
          if (happens(onError)) {
            isDocHave = false;
            flutterAlertMessage(msg: onError.message);
            setState(() {});
          }
        });
      } else {
        isCircular = false;
        setState(() {});
      }
    } catch (e) {
      isCircular = false;
      setState(() {});
      if (e is DioException) {
        if (e.type == DioExceptionType.badResponse) {
          final response = e.response;
          if (response != null && response.data != null) {
            flutterAlertMessage(msg: response.data['message']);
          }
        } else {
          final response = e.response;
          if (response != null && response.data != null) {
            final Map responseData =
                json.decode(response.data as String) as Map;
            flutterAlertMessage(msg: responseData['message']);
          }
        }
      }
    }
  }

  final _controller = TextEditingController();
  final userName = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(this.context).size.height;

    return !isDocHave
        ? isLoading
            ? Scaffold(
                backgroundColor: appCtrl.appTheme.primary,
                body: Stack(alignment: Alignment.center, children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child:
                          Image.asset(eImageAssets.splash, fit: BoxFit.fill)),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(eSvgAssets.splashIcon),
                        const VSpace(Sizes.s20),
                        Text(appFonts.chatzy.tr,
                            style: AppCss.muktaVaani40
                                .textColor(appCtrl.appTheme.sameWhite))
                      ])
                ]))
            : Scaffold(
                backgroundColor: appCtrl.appTheme.white,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(appFonts.checkLicense.tr,
                      style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: appCtrl.appTheme.primary)),
                  backgroundColor: appCtrl.appTheme.white,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                ),
                body: Stack(
                  children: [
                    Center(
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, h / 10, 0, h / 8),
                            child: Column(
                              children: [
                                Text(appFonts.linkApp.tr,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.manrope(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: appCtrl.appTheme.txt,
                                    ).textHeight(1.8)),
                                const VSpace(Sizes.s20),
                              ],
                            ),
                          ),
                          Text(appFonts.pastePurchaseCode.tr,
                                  textAlign: TextAlign.center,
                                  style: AppCss.manropeBold16
                                      .textColor(appCtrl.appTheme.primary))
                              .alignment(Alignment.topLeft),
                          const VSpace(Sizes.s20),
                          Form(
                            key: _formKey,
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 17, 15, 15),
                              decoration: ShapeDecoration(
                                color: appCtrl.appTheme.white,
                                shadows: [
                                  BoxShadow(
                                      color: appCtrl.appTheme.borderColor
                                          .withOpacity(0.5),
                                      blurRadius: AppRadius.r5,
                                      spreadRadius: AppRadius.r2)
                                ],
                                shape: SmoothRectangleBorder(
                                  side: BorderSide(
                                      color: appCtrl.appTheme.greyText
                                          .withOpacity(.15)),
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: 12, cornerSmoothing: 1),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(appFonts.userName.tr,
                                      style: GoogleFonts.manrope(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: appCtrl.appTheme.darkText,
                                      )),
                                  const VSpace(Sizes.s8),
                                  TextFieldCommon(
                                    controller: userName,
                                    hintText: "Codecanyon Username",
                                    keyboardType: TextInputType.text,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: appCtrl.appTheme.greyText
                                                .withOpacity(.15)),
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.r8)),
                                    fillColor:
                                        const Color.fromRGBO(153, 158, 166, .1),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Can\'t be empty';
                                      }

                                      return null;
                                    },
                                  ),
                                  const VSpace(Sizes.s28),
                                  //email text box
                                  Text(appFonts.purchaseCode.tr,
                                      style: GoogleFonts.manrope(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: appCtrl.appTheme.darkText,
                                      )),
                                  const VSpace(Sizes.s8),
                                  TextFieldCommon(
                                    controller: _controller,
                                    hintText:
                                        'xxxxxx-xxx-xxxxx-xxx-xxx-xxxxxx-xx',
                                    keyboardType: TextInputType.text,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: appCtrl.appTheme.greyText
                                                .withOpacity(.15)),
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.r8)),
                                    fillColor:
                                        const Color.fromRGBO(153, 158, 166, .1),
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Can\'t be empty';
                                      }
                                      if (text.length < 4) {
                                        return 'Too short';
                                      }
                                      return null;
                                    },
                                  ),
                                  const VSpace(Sizes.s40),
                                  ButtonCommon(
                                    title: appFonts.checkLicense.tr,
                                    margin: 0,
                                    style: AppCss.manropeMedium14
                                        .textColor(appCtrl.appTheme.white),
                                    onTap: () {
                                      dest2(
                                          ak76(_controller.text),
                                          ak76(userName.text),
                                          ak76(appFonts.fontSizeKey));
                                      /*if (_formKey.currentState!.validate()) {
                                        print(
                                            "dhfjsdgh : ${_controller.text.length}");
                                        if (_controller.text.isNotEmpty &&
                                            (_controller.text.trim().length ==
                                                    36 ||
                                                _controller.text
                                                        .trim()
                                                        .length ==
                                                    23)) {
                                          dest2(
                                              ak76(_controller.text),
                                              ak76(userName.text),
                                              ak76(appFonts.fontSizeKey));
                                        } else {
                                          flutterAlertMessage(
                                              msg:
                                                  'Please enter valid 36 length or 23 length code');
                                        }
                                      }*/
                                    },
                                  ),

                                  const SizedBox(height: 7),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCircular)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              )
        : isLoading
            ? Scaffold(
                backgroundColor: appCtrl.appTheme.primary,
                body: Stack(alignment: Alignment.center, children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child:
                          Image.asset(eImageAssets.splash, fit: BoxFit.fill)),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //  SvgPicture.asset(eSvgAssets.splashIcon),
                        const VSpace(Sizes.s20),
                        Text(appFonts.chatzy.tr,
                            style: AppCss.muktaVaani40
                                .textColor(appCtrl.appTheme.sameWhite))
                      ])
                ]))
            : isDocHave
                ? !isCheckAK
                    ? SplashScreen(
                        pref: prefs!,
                        rm: doc!,
                        uc: uc!,
                      )
                    : SplashScreen(
                        pref: prefs!,
                        rm: doc!,
                        uc: uc!,
                      )
                : Scaffold(
                    backgroundColor: appCtrl.appTheme.primary,
                    body: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(eImageAssets.splash,
                              fit: BoxFit.fill)),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(eSvgAssets.splashIcon),
                            const VSpace(Sizes.s20),
                            Text(appFonts.chatzy.tr,
                                style: AppCss.muktaVaani40
                                    .textColor(appCtrl.appTheme.sameWhite))
                          ])
                    ]));
  }

  String reverse(String string) {
    if (string.length < 2) {
      return string;
    }

    final characters = Characters(string);
    return characters.toList().reversed.join();
  }
}
