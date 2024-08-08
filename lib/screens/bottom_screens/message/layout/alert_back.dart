import 'package:flutter/services.dart';

import '../../../../config.dart';

class AlertBack extends StatelessWidget {
  const AlertBack({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text(appFonts.alert.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  <Widget>[
          Text(appFonts.areYouSure.tr),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(appFonts.close.tr),
        ),
        TextButton(
          onPressed: () async {
            SystemNavigator.pop();
          },
          child:  Text(appFonts.yes.tr),
        ),
      ],
    );
  }
}
