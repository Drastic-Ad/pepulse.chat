

import '../config.dart';

class PopupMenuCommon extends StatelessWidget {
  final PopupMenuItemBuilder itemBuilder;
  final VoidCallback? onOpened;
  final PopupMenuCanceled? onCanceled;
  const PopupMenuCommon({super.key,required this.itemBuilder,this.onCanceled,this.onOpened});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.s40,
      width: Sizes.s40,
      child: PopupMenuButton(
        color: appCtrl.appTheme.white,
        constraints: const BoxConstraints(minWidth: Sizes.s160,maxWidth: Sizes.s160),
          position: PopupMenuPosition.under,

          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(AppRadius.r8)
              )
          ),
          onOpened: onOpened,
          onCanceled: onCanceled,
          padding: const EdgeInsets.all(0),
          iconSize: Sizes.s20,
          icon: SvgPicture.asset(eSvgAssets.more,
              height: Sizes.s20,colorFilter: ColorFilter.mode(appCtrl.appTheme.darkText, BlendMode.srcIn)),
          itemBuilder: itemBuilder).decorated(
          color: appCtrl.appTheme.white,
          border: Border.all(
              color: appCtrl.appTheme.borderColor,
              width: 1),
          borderRadius: const BorderRadius.all(
              Radius.circular(AppRadius.r8)),
          boxShadow: [
            BoxShadow(
                color: appCtrl.appTheme.borderColor
                    .withOpacity(0.08),
                spreadRadius: 2,
                blurRadius: 2)
          ]),
    );
  }
}

