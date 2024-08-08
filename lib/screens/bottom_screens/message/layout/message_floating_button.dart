/*
import '../../../../config.dart';

class MessageFloatingButton extends StatelessWidget {
  const MessageFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: ()async {
          final contactCtrl = Get.isRegistered<ContactListController>()
              ? Get.find<ContactListController>()
              : Get.put(ContactListController());
          contactCtrl.isLoading =true;
          contactCtrl.update();
          Get.forceAppUpdate();
*/
/*
          Get.to(() =>  ContactList(),
              transition: Transition.downToUp);*//*

        Get.toNamed(routeName.contactList);
        await Future.delayed(DurationsClass.s3);
          contactCtrl.isLoading =false;
          contactCtrl.update();
        },
        backgroundColor: appCtrl.appTheme.primary,
        child: Container(
            width: Sizes.s52,
            height: Sizes.s52,
            padding: const EdgeInsets.all(Insets.i8),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  appCtrl.isTheme
                      ? appCtrl.appTheme.primary.withOpacity(.8)
                      : appCtrl.appTheme.lightPrimary,
                  appCtrl.appTheme.primary
                ])),
            child: SvgPicture.asset(eSvgAssets.add,
                height: Sizes.s15)));
  }
}
*/
