import '../../../../../config.dart';

class ShareButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  const ShareButton({super.key,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(Insets.i11),
      margin:const EdgeInsets.symmetric( horizontal: Insets.i20, vertical: Insets.i20),
      decoration:  ShapeDecoration(
        color: appCtrl.appTheme.white,
        shape:   SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 8,cornerSmoothing: 1))
      ),
      child: const Icon(Icons.share))
        .inkWell(onTap:onTap);
  }
}
