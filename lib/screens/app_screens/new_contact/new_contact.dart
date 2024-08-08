import 'package:chatzy/config.dart';
import 'package:chatzy/controllers/app_pages_controllers/add_contact_book.dart';
import 'package:chatzy/screens/auth_screens/login_screen/layouts/country_list_layout.dart';
import 'package:chatzy/widgets/common_app_bar.dart';
import 'package:chatzy/widgets/validation.dart';

class NewContact extends StatelessWidget {
  final contactCtrl = Get.put(NewContactController());

  NewContact({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewContactController>(builder: (_) {
      return Scaffold(
        appBar: CommonAppBar(
          text: appFonts.addContact.tr,
        ),
        body: ListView(
          children: [
            Text(appFonts.displayName.tr,
                style:
                    AppCss.manropeBold15.textColor(appCtrl.appTheme.darkText)),
            const VSpace(Sizes.s8),
            TextFieldCommon(
                hintText: appFonts.enterYourName.tr,
                controller: contactCtrl.nameController,
                validator: (name) => Validation().nameValidation(name)),
            const VSpace(Sizes.s20),
            Text(appFonts.email.tr,
                style:
                    AppCss.manropeBold15.textColor(appCtrl.appTheme.darkText)),
            const VSpace(Sizes.s8),
            TextFieldCommon(
                hintText: appFonts.enterYourEmail.tr,
                controller: contactCtrl.emailController,
                validator: (email) => Validation().emailValidation(email)),
            const VSpace(Sizes.s20),
            Text(appFonts.phoneNumber.tr,
                style: AppCss.manropeSemiBold15
                    .textColor(appCtrl.appTheme.darkText)),
            const VSpace(Sizes.s8),
            Row(children: [
              CountryListLayout(
                  dialCode: contactCtrl.dialCode,
                  onChanged: (code) {
                    contactCtrl.dialCode = code!.dialCode;
                    contactCtrl.update();
                  }),
              const HSpace(Sizes.s10),
              Expanded(
                  child: TextFieldCommon(
                      keyboardType: TextInputType.number,
                     
                      validator: (phone) => Validation().phoneValidation(phone),
                      controller: contactCtrl.phoneController,
                      hintText: appFonts.enterNumber.tr))
            ]),
            if (contactCtrl.isExist || contactCtrl.isExistInApp)
              Column(
                children: [
                  const VSpace(Sizes.s15),
                  Text(contactCtrl.isExist
                      ? appFonts.alreadyInContact.tr
                      : appFonts.userNotInChatzy.tr,style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.greyText.withOpacity(.5)),),
                  const VSpace(Sizes.s15),
                ],
              ),
            const VSpace(Sizes.s50),
            ButtonCommon(
              title: appFonts.addContact.tr,
              onTap: () => contactCtrl.onContactSave(),
            )
          ],
        ).paddingSymmetric(horizontal: Insets.i20),
      );
    });
  }
}
