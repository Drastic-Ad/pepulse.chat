import '../../../../config.dart';


class CommonLoader extends StatelessWidget {

  const CommonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (appCtrl) {
        return Center(
            child: Material(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(60)),
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<
                                Color>(
                                appCtrl.appTheme
                                    .primary),
                            // appColor.primaryColor
                            strokeWidth: 3)))));
      }
    );
  }
}
