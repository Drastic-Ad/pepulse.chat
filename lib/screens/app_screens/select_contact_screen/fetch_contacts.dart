import 'dart:developer';
import 'package:flutter/cupertino.dart';

import '../../../config.dart';
import '../../../controllers/recent_chat_controller.dart';
import '../../../models/status_model.dart';
import '../../../widgets/common_loader.dart';
import '../../auth_screens/invite_people_screen/layouts/un_register_user.dart';
import 'layouts/list_tile_layout.dart';

class FetchContact extends StatefulWidget {
  final SharedPreferences? prefs;
  final PhotoUrl? message;

  const FetchContact({super.key, this.prefs, this.message});

  @override
  State<FetchContact> createState() => _FetchContactState();
}

class _FetchContactState extends State<FetchContact> {
  final scrollController = ScrollController();
  int inviteContactsCount = 30;
  bool isLoading = true, isSelected = false, isSearch = false;
  TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    var data = Get.arguments;
    isSelected = data ?? false;

    scrollController.addListener(scrollListener);
    setState(() {});
    super.initState();
  }

  String? sharedSecret;
  String? privateKey;

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      setStateIfMounted(() {
        inviteContactsCount = inviteContactsCount + 250;
      });
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DirectionalityRtl(
      child: Consumer<FetchContactController>(
          builder: (context, availableContacts, child) {
        return Consumer<RecentChatController>(
            builder: (context, recentChat, child) {
          return PopScope(
            canPop: false,onPopInvoked: (didPop) {

              if(didPop) return;
              availableContacts.onBack();
              Get.back();
            },
            child: Scaffold(
                backgroundColor: appCtrl.appTheme.white,
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: Sizes.s80,
                    elevation: 0,
                    titleSpacing: 5,
                    backgroundColor: appCtrl.appTheme.white,
                    title: isSearch
                        ? TextFieldCommon(
                            //  controller: callListCtrl.searchText,
                            hintText: "Search...",
                            fillColor: appCtrl.appTheme.white,autoFocus: true,
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: appCtrl.appTheme.darkText,
                                ),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r8)),
                            keyboardType: TextInputType.multiline,
                            onChanged: (val) {
                              availableContacts.searchUser(val);
                              searchText.text.isNotEmpty
                                  ? Icon(CupertinoIcons.multiply,
                                          color: appCtrl.appTheme.white,
                                          size: Sizes.s15)
                                      .decorated(
                                          color: appCtrl.appTheme.darkText
                                              .withOpacity(.3),
                                          shape: BoxShape.circle)
                                      .marginAll(Insets.i12)
                                      .inkWell(onTap: () {
                                      isSearch = false;
                                      searchText.text = "";
                                      setState(() {});
                                    })
                                  : SvgPicture.asset(eSvgAssets.search,
                                          height: Sizes.s15)
                                      .marginAll(Insets.i12)
                                      .inkWell(onTap: () {
                                      isSearch = false;
                                      searchText.text = "";
                                      setState(() {});
                                    });
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(appFonts.selectContact.tr,
                                    style: AppCss.manropeBold16
                                        .textColor(appCtrl.appTheme.darkText)),
                                const VSpace(Sizes.s5),
                                Text(
                                    "${availableContacts.contactList!.length} ${appFonts.contact.tr}",
                                    style: AppCss.manropeMedium12
                                        .textColor(appCtrl.appTheme.greyText))
                              ]),
                    actions: [
                      if (!isSearch)
                        ActionIconsCommon(
                            icon: eSvgAssets.refresh,
                            color: appCtrl.appTheme.white,
                            onTap: () async {
                              final FetchContactController contactsProvider =
                                  Provider.of<FetchContactController>(context,
                                      listen: false);
                              contactsProvider.fetchContacts(context,
                                  appCtrl.user["phone"], widget.prefs!, true);
                              flutterAlertMessage(msg: "Loading..");
                            },
                            hPadding: Insets.i15,
                            vPadding: Insets.i20),
                      if (!isSearch)
                        ActionIconsCommon(
                                icon: eSvgAssets.search,
                                color: appCtrl.appTheme.white,
                                onTap: () async {
                                  isSearch = !isSearch;
                                  setState(() {});
                                },
                                vPadding: Insets.i20)
                            .marginOnly(right: Insets.i20)
                    ],
                    leading: ActionIconsCommon(
                        icon: appCtrl.isRTL || appCtrl.languageVal == "ar"
                            ? eSvgAssets.arrowRight
                            : eSvgAssets.arrowLeft,
                        onTap: (){
                          availableContacts.onBack();
                          Get.back();
                        },
                        hPadding: Insets.i8,
                        color: appCtrl.appTheme.white,
                        vPadding: Insets.i20)),
                body: availableContacts.searchContact == true
                    ? loading()
                    : RefreshIndicator(
                        onRefresh: () async {
                          return availableContacts.fetchContacts(context,
                              appCtrl.user["phone"], widget.prefs!, true);
                        },
                        child: ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.only(bottom: 15, top: 0),
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Divider(
                                      height: 1,
                                      thickness: 2,
                                      color: appCtrl.appTheme.borderColor)
                                  .padding(
                                      bottom: Insets.i20,
                                      top: Insets.i10,
                                      horizontal: Insets.i20),
                              ...appArray.selectContactList
                                  .asMap()
                                  .entries
                                  .map((e) => e.value['title'] == appFonts.newGroup.tr?! appCtrl.usageControlsVal!.allowCreatingGroup! ? Container(): ListTileLayout(
                                        data: e.value,
                                        onTap: () {
                                          if (e.key == 0) {
                                            Get.to(() => GroupMessageScreen(),
                                                arguments: true);
                                          }else{
                                            Get.toNamed(routeName.newContact)!.then((value) {
                                              flutterAlertMessage(msg: "Contact Sync..");
                                              return availableContacts.fetchContacts(context,
                                                  appCtrl.user["phone"], widget.prefs!, true);
                                            });
                                          }
                                        },
                                      ).paddingSymmetric(horizontal: Insets.i20) : ListTileLayout(
                  data: e.value,
                  onTap: () {
                    if (e.key == 0) {
                      Get.to(() => GroupMessageScreen(),
                          arguments: true);
                    }else{
                      Get.toNamed(routeName.newContact)!.then((value) {
                        return availableContacts.fetchContacts(context,
                            appCtrl.user["phone"], widget.prefs!, true);
                      });
                    }
                  },
                ).paddingSymmetric(horizontal: Insets.i20))
                              ,
                              availableContacts.registerContactUser.isEmpty
                                  ? const SizedBox()
                                  : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Insets.i20),
                                          child: Text(appFonts.registerPeople.tr,
                                              style: AppCss.manropeBold14
                                                  .textColor(
                                                      appCtrl.appTheme.darkText)))
                                      .paddingOnly(top: Insets.i10),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(00),
                                  itemCount: availableContacts
                                          .searchRegisterContactUser.isNotEmpty
                                      ? availableContacts
                                          .searchRegisterContactUser.length
                                      : availableContacts
                                          .registerContactUser.length,
                                  itemBuilder: (context, idx) {
                                    RegisterContactDetail user = availableContacts
                                            .searchRegisterContactUser.isNotEmpty
                                        ? availableContacts
                                            .searchRegisterContactUser
                                            .elementAt(idx)
                                        : availableContacts.registerContactUser
                                            .elementAt(idx);

                                    String phone = user.phone!;
                                    String name = contactName(phone);

                                    return phone != appCtrl.user["phone"]
                                        ? FutureBuilder<UserData?>(
                                            future: availableContacts
                                                .getUserDataFromStorageAndFirebase(
                                                    widget.prefs!, phone),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<UserData?>
                                                    snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data != null) {
                                                return ListTile(
                                                    leading: CachedNetworkImage(
                                                        imageUrl: snapshot
                                                            .data!.photoURL,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            CircleAvatar(
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xffE6E6E6),
                                                                radius:
                                                                    AppRadius.r25,
                                                                backgroundImage:
                                                                    imageProvider),
                                                        placeholder: (context,
                                                                url) =>
                                                            CircleAvatar(
                                                                backgroundColor:
                                                                    appCtrl
                                                                        .appTheme
                                                                        .primary,
                                                                radius:
                                                                    AppRadius.r25,
                                                                child: Text(
                                                                    snapshot
                                                                            .data!
                                                                            .name
                                                                            .isNotEmpty
                                                                        ? snapshot.data!.name.length >
                                                                                2
                                                                            ? snapshot
                                                                                .data!
                                                                                .name
                                                                                .replaceAll(" ", "")
                                                                                .substring(0, 2)
                                                                                .toUpperCase()
                                                                            : snapshot.data!.name[0]
                                                                        : "C",
                                                                    style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.sameWhite))),
                                                        errorWidget: (context, url, error) => CircleAvatar(
                                                            backgroundColor: appCtrl.appTheme.primary,
                                                            radius: AppRadius.r25,
                                                            child: Text(
                                                              snapshot.data!.name
                                                                      .isNotEmpty
                                                                  ? snapshot
                                                                              .data!
                                                                              .name
                                                                              .length >
                                                                          2
                                                                      ? snapshot
                                                                          .data!
                                                                          .name
                                                                          .replaceAll(
                                                                              " ",
                                                                              "")
                                                                          .substring(
                                                                              0,
                                                                              2)
                                                                          .toUpperCase()
                                                                      : snapshot
                                                                          .data!
                                                                          .name[0]
                                                                  : "C",
                                                              style: AppCss
                                                                  .manropeMedium14
                                                                  .textColor(appCtrl
                                                                      .appTheme
                                                                      .sameWhite),
                                                            ))),
                                                    title: Text( name == "" ?snapshot.data!.name :name, style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)),
                                                    subtitle: Text(snapshot.data!.aboutUser, style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.greyText)),
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 0.0),
                                                    onTap: () async {
                                                      if (isSelected == true) {
                                                        Get.back(result: {
                                                          "name":
                                                              snapshot.data!.name,
                                                          "number": user.phone!,
                                                          "photo": snapshot
                                                              .data!.photoURL
                                                        });
                                                        setState(() {});
                                                      } else {
                                                        final RecentChatController
                                                            recentChatController =
                                                            Provider.of<
                                                                    RecentChatController>(
                                                                Get.context!,
                                                                listen: false);

                                                        bool isEmpty =
                                                            recentChatController
                                                                .userData
                                                                .where((element) {
                                                          return element["receiverId"] ==
                                                                      appCtrl.user[
                                                                          "id"] &&
                                                                  element["senderId"] ==
                                                                      snapshot
                                                                          .data!
                                                                          .id ||
                                                              element["senderId"] ==
                                                                      appCtrl.user[
                                                                          "id"] &&
                                                                  element["receiverId"] ==
                                                                      snapshot
                                                                          .data!
                                                                          .id;
                                                        }).isEmpty;
                                                        log("isEmpty : $isEmpty");
                                                        if (!isEmpty) {
                                                          int index = recentChatController.userData.indexWhere((element) =>
                                                              element["receiverId"] ==
                                                                      appCtrl.user[
                                                                          "id"] &&
                                                                  element["senderId"] ==
                                                                      snapshot
                                                                          .data!
                                                                          .id ||
                                                              element["senderId"] ==
                                                                      appCtrl.user[
                                                                          "id"] &&
                                                                  element["receiverId"] ==
                                                                      snapshot
                                                                          .data!
                                                                          .id);
                                                          UserContactModel userContact =
                                                              UserContactModel(
                                                                  username:
                                                                      snapshot
                                                                          .data!
                                                                          .name,
                                                                  uid: snapshot
                                                                      .data!.id,
                                                                  phoneNumber: snapshot
                                                                      .data!
                                                                      .idVariants,
                                                                  image: snapshot
                                                                      .data!
                                                                      .photoURL,
                                                                  isRegister:
                                                                      true);
                                                          var data = {
                                                            "chatId":
                                                                recentChatController
                                                                        .userData[
                                                                    index]["chatId"],
                                                            "data": userContact
                                                          };

                                                          Get.back();
                                                          Get.toNamed(
                                                              routeName
                                                                  .chatLayout,
                                                              arguments: data);
                                                        } else {
                                                          UserContactModel userContact =
                                                              UserContactModel(
                                                                  username:
                                                                      snapshot
                                                                          .data!
                                                                          .name,
                                                                  uid: snapshot
                                                                      .data!.id,
                                                                  phoneNumber: snapshot
                                                                      .data!
                                                                      .idVariants,
                                                                  image: snapshot
                                                                      .data!
                                                                      .photoURL,
                                                                  isRegister:
                                                                      true);
                                                          var data = {
                                                            "chatId": "0",
                                                            "data": userContact,
                                                          };
                                                          Get.back();
                                                          Get.toNamed(
                                                              routeName
                                                                  .chatLayout,
                                                              arguments: data);
                                                        }
                                                      }
                                                    });
                                              }
                                              return ListTile(
                                                  leading: const CircleAvatar(
                                                      radius: 22),
                                                  title: Text(name == "" ?snapshot.data != null ?snapshot.data!.name : "" :name,
                                                      style: AppCss
                                                          .manropeMedium16
                                                          .textColor(appCtrl
                                                              .appTheme
                                                              .darkText)),
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 22.0,
                                                          vertical: 0.0));
                                            })
                                        : Container();
                                  }),
                              Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Insets.i20),
                                      child: Text(appFonts.invitePeople.tr,
                                          style: AppCss.manropeBold14.textColor(
                                              appCtrl.appTheme.darkText)))
                                  .paddingOnly(top: Insets.i10),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(Insets.i20),
                                  itemCount: inviteContactsCount >=
                                       (availableContacts.searchContactList!.isNotEmpty ? availableContacts.searchContactList!.length:   availableContacts.contactList!.length)
                                      ?  (availableContacts.searchContactList!.isNotEmpty ? availableContacts.searchContactList!.length:   availableContacts.contactList!.length)
                                      : inviteContactsCount,
                                  itemBuilder: (context, idx) {
                                    MapEntry user =  availableContacts.searchContactList!.isNotEmpty ?   availableContacts
                                        .searchContactList!.entries
                                        .elementAt(idx) :   availableContacts
                                        .contactList!.entries
                                        .elementAt(idx);
                                    String phone = user.key;

                                    return availableContacts.registerContactUser
                                                .indexWhere((element) =>
                                                    element.phone == phone) >=
                                            0
                                        ? Container()
                                        : availableContacts.oldPhoneData
                                                    .indexWhere((element) =>
                                                        element.phone == phone) >=
                                                0
                                            ? const CommonLoader()
                                            : UnRegisterUser(
                                                    image: availableContacts
                                                        .getInitials(user.value),
                                                    name: user.value,
                                                    onTap: () => availableContacts
                                                        .onInvitePeople(
                                                            number: user.key))
                                                .inkWell(onTap: () {
                                                if (isSelected == true) {
                                                  Get.back(result: {
                                                    "name": user.value,
                                                    "number": user.key,
                                                    "photo": availableContacts
                                                        .getInitials(user.value)
                                                  });
                                                  setState(() {});
                                                }
                                              });
                                  })
                            ]))),
          );
        });
      }),
    );
  }

  loading() {
    return Stack(children: [
      Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(appCtrl.appTheme.primary),
      ))
    ]);
  }
}
