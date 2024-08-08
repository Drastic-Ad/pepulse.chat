import '../../../../config.dart';

class ChatInterface extends StatelessWidget {
  final double? bottomRight,bottomLeft;
  final Alignment? alignment;
  final String? title;
  final bool? isSentByMe;

  const ChatInterface({super.key,this.bottomLeft,this.bottomRight,this.title,this.isSentByMe,this.alignment });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(isSentByMe == false)
        ClipRRect(
            borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.r50)),
            child: Image.asset(eImageAssets.dummyImage,
                fit: BoxFit.cover,
                width: Sizes.s34,
                height: Sizes.s34)).paddingOnly(left: Insets.i10,top: Insets.i5),

        Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Insets.i15, vertical: Insets.i15),
            decoration: BoxDecoration(
                color: isSentByMe == true ? appCtrl.appTheme.primary : appCtrl.appTheme.borderColor,
                borderRadius:  BorderRadius.only(
                    topRight: const Radius.circular(Insets.i20),
                    topLeft: const Radius.circular(Insets.i20),
                    bottomRight: Radius.circular(bottomRight!),
                    bottomLeft: Radius.circular(bottomLeft!)
                )),
            child: Text(title!.toString().tr,
                overflow: TextOverflow.clip,
                style: AppCss.manropeMedium14
                    .textColor(isSentByMe == true ? appCtrl.appTheme.sameWhite : appCtrl.appTheme.darkText).textHeight(1.3)
            ).width(title!.length > 40 ? Sizes.s200 : Sizes.s130)).paddingSymmetric(horizontal: Insets.i10,vertical: Insets.i10).alignment(alignment!)
      ]
    ).alignment(alignment!);
  }
}
