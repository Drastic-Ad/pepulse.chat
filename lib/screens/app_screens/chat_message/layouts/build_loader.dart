import '../../../../config.dart';

class BuildLoader extends StatelessWidget {
  const BuildLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        builder: (chatCtrl) {
          return Positioned(
            child: chatCtrl.isLoading
                ? Container(
              color: appCtrl.appTheme.white.withOpacity(0.8),
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        appCtrl.appTheme.primary)),
              ),
            )
                : Container(),
          );
        }
    );
  }
}
