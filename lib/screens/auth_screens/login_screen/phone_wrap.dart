import 'dart:developer';


import 'package:chatzy/controllers/recent_chat_controller.dart';

import '../../../config.dart';

class PhoneWrap extends StatelessWidget {

  const PhoneWrap({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapData) {
          log("SNAP 111: ${snapData.hasData}");
          if (snapData.hasData) {
            appCtrl.pref = snapData.data;
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FetchContactController()),
                ChangeNotifierProvider(create: (_) => RecentChatController()),
              ],
              child: LoginScreen(preferences: snapData.data,)
            );
          } else {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FetchContactController()),
                ChangeNotifierProvider(create: (_) => RecentChatController()),
              ],
              child: Scaffold(
                  backgroundColor: appCtrl.appTheme.primary,
                  body: Center(
                      child: Image.asset(
                        eImageAssets.splash,
                        // replace your Splashscreen icon
                        width: Sizes.s210,
                      ))),
            );
          }
        });
  }
}
