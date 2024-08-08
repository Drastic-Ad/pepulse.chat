import '../../../../../config.dart';
import '../../../../../controllers/app_pages_controllers/add_participants_controller.dart';
import '../all_registered_contact.dart';
import '../selected_users.dart';

class AddParticipants extends StatelessWidget {
  final groupChatCtrl = Get.isRegistered<AddParticipantsController>()
      ? Get.find<AddParticipantsController>()
      : Get.put(AddParticipantsController());

  AddParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddParticipantsController>(builder: (_) {

      return  PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          groupChatCtrl.selectedContact = [];
          groupChatCtrl.update();
          Get.back();
        },

        child: GetBuilder<AppController>(builder: (appCtrl) {
          return Scaffold(
              backgroundColor: appCtrl.appTheme.white,
              appBar: AppBar(
                  centerTitle: false,
                  automaticallyImplyLeading: false,

                  leading: Icon(Icons.arrow_back,
                      color: appCtrl.appTheme.sameWhite)
                      .inkWell(onTap: () => Get.back()),
                  backgroundColor: appCtrl.appTheme.primary,
                  title: Text(appFonts.addContact.tr,
                      style: AppCss.manropeMedium18
                          .textColor(appCtrl.appTheme.sameWhite))),
              floatingActionButton: groupChatCtrl.selectedContact.isNotEmpty
                  ? FloatingActionButton(
                  onPressed: () => groupChatCtrl.addGroupBottomSheet(),
                  backgroundColor: appCtrl.appTheme.primary,
                  child: Icon(Icons.arrow_forward_outlined,
                      color: appCtrl.appTheme.sameWhite))
                  : Container(),
              body: Stack(children: [
                SingleChildScrollView(
                    child:Consumer<FetchContactController>(
                        builder: (context, registerAvailableContact, child) {

                          return Stack(children: [
                            SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (groupChatCtrl.selectedContact.isNotEmpty)

                                Column(
                                children: [
                                Divider(height: 1,color: appCtrl.appTheme.greyText.withOpacity(0.2)),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: groupChatCtrl.selectedContact.asMap().entries.map((e) {
                                      return SelectedUsers(
                                          data: e.value,
                                          onTap: () {
                                            groupChatCtrl.selectedContact.remove(e.value);
                                            groupChatCtrl.update();
                                          }
                                      );
                                    }).toList()
                                ).paddingSymmetric(vertical: Insets.i10)
                            ),
                            Divider(height: 1,color: appCtrl.appTheme.greyText.withOpacity(0.2))
                          ]
                          ).backgroundColor(appCtrl.appTheme.borderColor),
                                      if (registerAvailableContact.registerContactUser.isNotEmpty)
                                        Column(children: [
                                          ...registerAvailableContact.registerContactUser
                                              .asMap()
                                              .entries
                                              .map((e) {
                                            return AllRegisteredContact(
                                                onTap: () => groupChatCtrl.selectUserTap(e.value),
                                                isExist: groupChatCtrl.selectedContact.any((file) =>
                                                file["phone"] == e.value.phone),
                                                data: e.value);
                                          })
                                        ]).paddingAll(Insets.i20)
                                    ])),
                          ]);
                        }
                    )),
              ]));
        }),
      );
    });
  }
}
