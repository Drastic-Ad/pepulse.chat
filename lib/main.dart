import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'common/extension/tklmn.dart';
import 'common/languages/index.dart';
import 'config.dart';
import 'controllers/common_controllers/firebase_common_controller.dart';
import 'controllers/common_controllers/notification_controller.dart';
import 'controllers/recent_chat_controller.dart';

const encryptedKey = "MyCHATZY32lengthENCRYPTKEY132456";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  cameras = await availableCameras();
  //Get.put(LoadingController());
  // Set the background messaging handler early on, as a named top-level function
  Get.put(AppController());
  Get.put(FirebaseCommonController());
  Get.put(CustomNotificationController());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: appCtrl.appTheme.trans));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    lockScreenPortrait();
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapData) {
          if (snapData.hasData) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FetchContactController()),
                ChangeNotifierProvider(create: (_) => RecentChatController()),
              ],
              child: GetMaterialApp(
                builder: (context, widget) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: widget!,
                  );
                },
                debugShowCheckedModeBanner: false,
                translations: Language(),
                locale: const Locale('en', 'US'),
                fallbackLocale: const Locale('en', 'US'),
                title: appFonts.chatzy.tr,
                home: CallFunc(prefs: snapData.data),
                getPages: appRoute.getPages,
                theme: AppTheme.fromType(ThemeType.light).themeData,
                darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                themeMode: ThemeService().theme,
              ),
            );
          } else {
            log("NO DATA ");
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FetchContactController()),
                ChangeNotifierProvider(create: (_) => RecentChatController()),
              ],
              child: MaterialApp(
                  theme: AppTheme.fromType(ThemeType.light).themeData,
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
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
                      ]))),
            );
          }
        });
  }

  lockScreenPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
