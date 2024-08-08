import '../../../../config.dart';

class ListTileLayout extends StatelessWidget {
  final dynamic data;
  final GestureTapCallback? onTap;

  const ListTileLayout({super.key, this.data,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        onTap: onTap,
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(data["image"]),
          title: Text(data["title"],
              style: AppCss.manropeSemiBold14
                  .textColor(appCtrl.appTheme.darkText))),
      Divider(height: 1, thickness: 1.5, color: appCtrl.appTheme.borderColor).paddingSymmetric(vertical: Insets.i20)
    ]);
  }
}
