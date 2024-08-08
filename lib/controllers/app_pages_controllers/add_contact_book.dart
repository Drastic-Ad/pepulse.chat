import 'dart:developer';
import 'package:chatzy/config.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:country_list_pick/support/code_countries_en.dart';

class NewContactController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> profileGlobalKey = GlobalKey<FormState>();
  String? dialCode;
  bool isExist = false,isExistInApp =false;

  @override
  void onReady() {
    final String systemLocales =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode!;
    List country = countriesEnglish;
    int index =
        country.indexWhere((element) => element['code'] == systemLocales);
    dialCode = country[index]['dial_code'];
    update();
    log("DIAL : $dialCode");
    update();

    // TODO: implement onReady
    super.onReady();
  }

  onContactSave() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    Contact contact = Contact(
        displayName: nameController.text,
        givenName: nameController.text,
        androidAccountName: nameController.text,
        emails: [
          Item(label: "personal", value: emailController.text)
        ],
        phones: [
          Item(label: "mobile", value: "$dialCode${phoneController.text}")
        ]);
    log("contact: $contact");

    // await ContactsService.addContact(contact);
    await ContactsService.getContactsForPhone(phoneController.text)
        .then((value) async {
      log("COOOO : $value");
      if (value.isNotEmpty) {
        isExist = true;
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .where("phone", isEqualTo: "$dialCode${phoneController.text}")
            .get()
            .then((user) {
              log("CHECK : ${user.docs.length}");
              if(user.docs.isNotEmpty){
                isExistInApp = false;
              }else{
                isExistInApp =true;
              }
        });
        isExist = false;
       await ContactsService.addContact(contact);
      }
      update();
    });
    Get.back();
  }
}
