import 'package:intl/intl.dart';

import '../../../../config.dart';

class LastSeen extends StatelessWidget {
  final DocumentSnapshot? document;
  const LastSeen({super.key,this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            right: 10.0, top: 5.0, bottom: 5.0),
        child: Text(
          DateFormat('dd MMM kk:mm').format(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(document!['timestamp']))),
          style: AppCss.manropeBold12
              .style(FontStyle.italic)
              .textColor(appCtrl.appTheme.primary),
        ));
  }
}
