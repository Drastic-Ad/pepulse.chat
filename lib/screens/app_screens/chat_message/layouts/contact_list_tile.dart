import '../../../../config.dart';

class ContactListTile extends StatelessWidget {
  final MessageModel? document;
  final bool isReceiver;

  const ContactListTile({super.key, this.document, this.isReceiver = false})
     ;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minVerticalPadding: 0,

        dense:true,
        contentPadding: const EdgeInsets.symmetric(horizontal: Insets.i15),
        leading: CachedNetworkImage(
            imageUrl: decryptMessage(document!.content).split('-BREAK-')[2],
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: isReceiver?appCtrl.appTheme.greyText : appCtrl.appTheme.primaryLight,
              radius: AppRadius.r22,
              backgroundImage: NetworkImage(
                  decryptMessage(document!.content).split('-BREAK-')[2]),
            ),
            placeholder: (context, url) => CircleAvatar(
                backgroundColor: isReceiver?appCtrl.appTheme.greyText : appCtrl.appTheme.primaryLight,
                radius: AppRadius.r22,
                child: Icon(Icons.people, color: appCtrl.appTheme.primaryLight)),
            errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: isReceiver?appCtrl.appTheme.primaryLight1 : appCtrl.appTheme.primaryLight,
                radius: AppRadius.r22,
                child:
                Icon(Icons.people, color: appCtrl.appTheme.sameWhite))),
        title: Text(decryptMessage(document!.content).split('-BREAK-')[0],
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppCss.manropeblack14.textColor(isReceiver
                ? appCtrl.appTheme.sameWhite
                : appCtrl.appTheme.sameWhite)));
  }
}
