import 'package:chatzy/widgets/common_loader.dart';
import '../../../config.dart';
import 'layouts/all_registered_contact.dart';
import 'layouts/selected_contact_list.dart';

class GroupMessageScreen extends StatelessWidget {
  final groupCtrl = Get.isRegistered<GroupMessageController>()
      ? Get.find<GroupMessageController>()
      : Get.put(GroupMessageController());

  GroupMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
      return GetBuilder<GroupMessageController>(builder: (groupCtrl) {
        return Consumer<FetchContactController>(
            builder: (context, availableContacts, child) {
            return PickupLayout(
              scaffold: DirectionalityRtl(
                child: Scaffold(
                  backgroundColor:appCtrl.appTheme.white ,
                  appBar: AppBar(
                      backgroundColor: appCtrl.appTheme.white,
                      elevation: 0,
                      leading: ActionIconsCommon(
                          icon: appCtrl.isRTL || appCtrl.languageVal == "ar" ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
                          onTap: () => Get.back(),
                          vPadding: Insets.i8,
                          hPadding: Insets.i8),
                      titleSpacing: 0,
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(groupCtrl.isGroup ? appFonts.newGroup.tr : appFonts.newBroadcast.tr,
                            style: AppCss.manropeBold16
                                .textColor(appCtrl.appTheme.darkText)),
                        const VSpace(Sizes.s5),
                        Text(appFonts.addParticipant.tr,
                            style: AppCss.manropeMedium12
                                .textColor(appCtrl.appTheme.greyText))
                      ]),
                      actions: [
                        Row(children: [
                          ActionIconsCommon(
                              icon: eSvgAssets.refresh,
                              onTap: () {},
                              vPadding: Insets.i8),
                          ActionIconsCommon(
                              icon: eSvgAssets.search,
                              onTap: () {},
                              vPadding: Insets.i8,
                              hPadding: Insets.i10)
                        ])
                      ]),
                  floatingActionButton: groupCtrl.selectedContact.length >= 2 ? FloatingActionButton(
                    onPressed: ()=> Get.toNamed(routeName.groupTitleScreen),
                    backgroundColor: appCtrl.appTheme.primary,
                    child: Icon(Icons.arrow_forward_outlined,color: appCtrl.appTheme.sameWhite)
                  ) : null,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (groupCtrl.selectedContact.isNotEmpty)
                          Divider(thickness: 2,endIndent: Insets.i20,indent: Insets.i20, color: appCtrl.appTheme.borderColor)
                              .paddingSymmetric(vertical: Insets.i15),
                        if (groupCtrl.selectedContact.isNotEmpty)
                          const SelectedContactList(),
                        Divider(thickness: 2,endIndent: Insets.i20,indent: Insets.i20, color: appCtrl.appTheme.borderColor)
                            .paddingSymmetric(vertical: Insets.i15),
                        Column(children: [
                          availableContacts.registerContactUser.isNotEmpty
                              ? Column(children: [
                            ...availableContacts.registerContactUser
                                      .asMap()
                                      .entries
                                      .map((e) => AllRegisteredContact(
                                          onTap: () => groupCtrl.selectUserTap(e.value),
                                          isExist: groupCtrl.selectedContact.any((file) =>
                                              file["phone"] == e.value.phone),
                                          data: e.value))

                                ]).paddingSymmetric(horizontal: Insets.i20)
                              : const CommonLoader()
                        ])
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        );
      });
  }
}
