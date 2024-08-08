import '../config.dart';

class PopupItemRowCommon extends StatelessWidget {
  final dynamic data;
  final int? index;
  final List? list;
  final GestureTapCallback? onTap;
  const PopupItemRowCommon({super.key,this.index,this.data,this.list,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        SvgPicture.asset(data["image"],colorFilter: ColorFilter.mode(appCtrl.appTheme.darkText, BlendMode.srcIn)),
        const HSpace(Sizes.s8),
        SizedBox(
          width: Sizes.s90,
          child: Text(data["title"].toString().tr,
              overflow: TextOverflow.ellipsis,
              style: AppCss.manropeMedium13.textColor(appCtrl.appTheme.darkText))
        )
      ]),
      if(index != list!.length - 1)
        Divider(height: 1, color: appCtrl.appTheme.borderColor, thickness: 1)
            .paddingOnly(top: Insets.i15, bottom: Insets.i15)
    ]).inkWell(onTap: onTap);
  }
}
