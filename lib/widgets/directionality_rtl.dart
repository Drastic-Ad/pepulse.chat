
import '../config.dart';

class DirectionalityRtl extends StatelessWidget {
  final Widget? child;

  const DirectionalityRtl({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: appCtrl.isRTL || appCtrl.languageVal == "ar"
                ? TextDirection.rtl
                : TextDirection.ltr,
        child: child!);
  }
}
