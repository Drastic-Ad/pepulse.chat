import '../../../../config.dart';
import '../../../../widgets/common_image_layout.dart';

class AllRegisteredContact extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool? isExist;
  final RegisterContactDetail? data;

  const AllRegisteredContact({super.key, this.onTap, this.data, this.isExist})
     ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(collectionName.users).doc(data!.id).snapshots(),
        builder: (context,snapshot) {
    if(snapshot.hasData) {
      return Column(
          children: [
            Row(children: [
              Container(
                  decoration: BoxDecoration(
                      color: isExist!
                          ? appCtrl.appTheme.primary
                          : appCtrl.appTheme.trans,
                      border: Border.all(
                          color: isExist!
                              ? appCtrl.appTheme.trans
                              : appCtrl.appTheme.borderColor,
                          width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(isExist! ? Icons.check : null,
                      size: Sizes.s15,
                      color: isExist!
                          ? appCtrl.appTheme.sameWhite
                          : appCtrl.appTheme.trans)
                      .paddingAll(Insets.i2))
                  .inkWell(onTap: onTap),
              const HSpace(Sizes.s20),
              CommonImage(
                  image: snapshot.data!.data()!["image"], name: data!.name),
              const HSpace(Sizes.s10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(data!.name ?? "",
                    style: AppCss.manropeBold14.textColor(
                        appCtrl.appTheme.darkText)),
                const VSpace(Sizes.s8),
                Text(snapshot.data!.data()!["statusDesc"] ?? "",
                    style: AppCss.manropeMedium14.textColor(
                        appCtrl.appTheme.greyText))
              ])
            ]),
            Divider(height: 1, color: appCtrl.appTheme.borderColor)
                .paddingSymmetric(vertical: Insets.i20)
          ]
      );
    } else {
      return Container();
    }
      }
    );
  }
}
