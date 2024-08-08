
import 'package:chatzy/widgets/common_loader.dart';

import '../../../config.dart';
import 'layouts/un_register_user.dart';

class InvitePeopleScreen extends StatefulWidget {


  const InvitePeopleScreen({super.key});

  @override
  State<InvitePeopleScreen> createState() => _InvitePeopleScreenState();
}

class _InvitePeopleScreenState extends State<InvitePeopleScreen> {
  int inviteContactsCount = 30;

  final invitePeopleCtrl = Get.put(InvitePeopleController());
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FetchContactController>(builder: (context, availableContacts, child) {

      return GetBuilder<InvitePeopleController>(
        builder: (invitePeopleCtrl) {
          return Scaffold(
              backgroundColor: appCtrl.appTheme.screenBG,
              appBar: AppBar(
                  centerTitle: true,
                  title: Text(appFonts.invitePeople.tr,
                      style: AppCss.manropeBold16
                          .textColor(appCtrl.appTheme.darkText)),
                  backgroundColor: appCtrl.appTheme.screenBG,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  actions: [
                    Text(appFonts.skip.tr,
                            style: AppCss.manropeBold14
                                .textColor(appCtrl.appTheme.greyText)).inkWell(onTap: () {
                      appCtrl.storage.write("skip", true);
                      Get.offAllNamed(routeName.dashboard,arguments: invitePeopleCtrl.pref);
                      setState(() {

                      });
                    })
                        .alignment(Alignment.center)
                        .paddingSymmetric(horizontal: Insets.i20)
                  ]),
              body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    TextFieldCommon(
                            fillColor: appCtrl.appTheme.white,
                            hintText: appFonts.searchHere.tr,
                            prefixIcon: SvgPicture.asset(eSvgAssets.search,
                                fit: BoxFit.scaleDown))
                        .decorated(boxShadow: [
                      BoxShadow(
                          color: appCtrl.appTheme.borderColor.withOpacity(0.1),
                          spreadRadius: AppRadius.r2,
                          blurRadius: AppRadius.r3)
                    ]).paddingOnly(top: Insets.i20, bottom: Insets.i30),
                    Column(
                      children: [
                        availableContacts
                            .contactList!.isNotEmpty ?
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemCount: inviteContactsCount >=
                              availableContacts
                                  .contactList!.length
                              ? availableContacts
                              .contactList!.length
                              : inviteContactsCount,
                          itemBuilder: (context, idx) {
                            MapEntry user = availableContacts
                                .contactList!.entries
                                .elementAt(idx);
                            String phone = user.key;
                            return availableContacts
                                .oldPhoneData
                                .indexWhere((element) =>
                            element.phone == phone) >=
                                0
                                ? const CommonLoader()
                                : UnRegisterUser(
                              image:  availableContacts
                                  .getInitials(user.value),
                                name: user.value,
                                onTap: () => invitePeopleCtrl.onInvitePeople(
                                    number: user.key)
                            );
                          },
                        ) : const CommonLoader()
                      ]
                    )
                  ]).paddingSymmetric(horizontal: Insets.i20)));
        }
      );
    });
  }
}
