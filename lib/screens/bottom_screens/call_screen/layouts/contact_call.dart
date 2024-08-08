import 'package:chatzy/controllers/bottom_controllers/call_list_controller.dart';

import 'package:chatzy/widgets/common_image_layout.dart';
import 'package:chatzy/widgets/common_loader.dart';
import 'package:flutter/cupertino.dart';
import '../../../../config.dart';

class ContactCall extends StatelessWidget {
  final callCtrl = Get.isRegistered<CallListController>()
      ? Get.find<CallListController>()
      : Get.put(CallListController());

  ContactCall({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallListController>(builder: (callCtrl) {
      return Consumer<FetchContactController>(
          builder: (context, availableContacts, child) {
        return DirectionalityRtl(
          child:  PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) return;
              callCtrl.isContactSearch = false;
              callCtrl.update();
              Get.back();
            },
            child: Scaffold(
              backgroundColor: appCtrl.appTheme.white,
              appBar: AppBar(
                  toolbarHeight: Sizes.s70,
                  backgroundColor: appCtrl.appTheme.white,
                  elevation: 0,
                  leading: ActionIconsCommon(
                      icon: appCtrl.isRTL || appCtrl.languageVal == "ar"
                          ? eSvgAssets.arrowRight
                          : eSvgAssets.arrowLeft,
                      onTap: () => Get.back(),
                      hPadding: Insets.i8,
                      color: appCtrl.appTheme.white,
                      vPadding: Insets.i13),
                  actions: [
                    if (!callCtrl.isContactSearch)
                      ActionIconsCommon(
                        icon: eSvgAssets.search,
                        vPadding: Insets.i15,
                        onTap: () {
                          callCtrl.isContactSearch = true;
                          callCtrl.update();
                        },
                        color: appCtrl.appTheme.white,
                      ),
                    if (!callCtrl.isContactSearch) const HSpace(Sizes.s15),
                    if (!callCtrl.isContactSearch)
                      ActionIconsCommon(
                        icon: eSvgAssets.refresh,
                        vPadding: Insets.i15,
                        onTap: () {
                          final FetchContactController contactsProvider =
                          Provider.of<FetchContactController>(context,
                              listen: false);
                          contactsProvider.fetchContacts(
                              context, appCtrl.user["phone"], appCtrl.pref!, true);
                          flutterAlertMessage(msg: "Loading..");
                        },
                        color: appCtrl.appTheme.white,
                      ),
                    const HSpace(Sizes.s20),
                  ],
                  bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(4.0),
                      child: Container(
                          color: const Color.fromRGBO(127, 131, 132, 0.15),
                          height: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: Insets.i20))),
                  title: callCtrl.isContactSearch
                      ? SizedBox(
                          height: Sizes.s45,
                          child: TextFieldCommon(
                              controller: callCtrl.searchContactText,
                              hintText: "Search...",
                              fillColor: appCtrl.appTheme.white,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: appCtrl.appTheme.darkText,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.r8)),
                              keyboardType: TextInputType.multiline,
                              onChanged: (val) {
                                callCtrl.onContactSearch(val);
                                callCtrl.update();
                              },
                              prefixIcon:
                                  callCtrl.searchContactText.text.isNotEmpty
                                      ? Icon(CupertinoIcons.multiply,
                                              color: appCtrl.appTheme.white,
                                              size: Sizes.s15)
                                          .decorated(
                                              color: appCtrl.appTheme.darkText
                                                  .withOpacity(.3),
                                              shape: BoxShape.circle)
                                          .marginAll(Insets.i12)
                                          .inkWell(onTap: () {
                                          callCtrl.isContactSearch = false;
                                          callCtrl.searchContactText.text = "";
                                          callCtrl.update();
                                        })
                                      : SvgPicture.asset(eSvgAssets.search,
                                              height: Sizes.s15)
                                          .marginAll(Insets.i12)
                                          .inkWell(onTap: () {
                                          callCtrl.isContactSearch = false;
                                          callCtrl.searchContactText.text = "";
                                          callCtrl.update();
                                        })),
                        )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appFonts.selectContact.tr,
                              style: AppCss.muktaVaani20
                                  .textColor(appCtrl.appTheme.darkText)),
                          const VSpace(Sizes.s5),
                          Text("${availableContacts
                              .registerContactUser.length} ${appFonts.contact.tr}",
                              style: AppCss.manropeMedium12
                                  .textColor(appCtrl.appTheme.greyText))
                        ],
                      )),
              body: Scrollbar(
                thumbVisibility: true,
                thickness: 5,
                radius: const Radius.circular(5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(children: [
                        callCtrl.searchList.isEmpty
                            ? availableContacts
                                    .registerContactUser
                                    .isNotEmpty
                                ? Column(children: [
                                    ...availableContacts
                                        .registerContactUser
                                        .asMap()
                                        .entries
                                        .map((e) => StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection(
                                                    collectionName.users)
                                                .doc(e.value.id)
                                                .snapshots(),
                                            builder: (context, snapshot) {

                                              if (snapshot.hasData) {

                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(children: [
                                                          CommonImage(
                                                              image:
                                                                  e.value.image,
                                                              name:
                                                                  e.value.name),
                                                          const HSpace(
                                                              Sizes.s10),
                                                          Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    e.value.name ??
                                                                        "",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: AppCss
                                                                        .manropeBold14
                                                                        .textColor(appCtrl
                                                                            .appTheme
                                                                            .darkText)),
                                                                const VSpace(
                                                                    Sizes.s8),
                                                                Text(
                                                                    e.value.statusDesc ??
                                                                        "",
                                                                    style: AppCss
                                                                        .manropeMedium14
                                                                        .textColor(appCtrl
                                                                            .appTheme
                                                                            .greyText))
                                                              ])
                                                        ]),
                                                        IntrinsicHeight(
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                eSvgAssets
                                                                    .callOut,
                                                                height:
                                                                    Sizes.s22,
                                                                colorFilter: ColorFilter.mode(
                                                                    appCtrl
                                                                        .appTheme
                                                                        .darkText,
                                                                    BlendMode
                                                                        .srcIn),
                                                              ).inkWell(
                                                                  onTap: () => callCtrl.callFromList(
                                                                      false,
                                                                      snapshot
                                                                          .data!
                                                                          .data())),
                                                              const VerticalDivider(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        78,
                                                                        160,
                                                                        247,
                                                                        0.20),
                                                                width: 0,
                                                                thickness: 1,
                                                              ).paddingSymmetric(
                                                                  horizontal:
                                                                      Insets
                                                                          .i17),
                                                              SvgPicture.asset(
                                                                      eSvgAssets
                                                                          .video)
                                                                  .inkWell(
                                                                      onTap: () => callCtrl.callFromList(
                                                                          true,
                                                                          snapshot
                                                                              .data!
                                                                              .data())),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Divider(
                                                            height: 1,
                                                            color: appCtrl
                                                                .appTheme
                                                                .greyText.withOpacity(.3))
                                                        .paddingSymmetric(
                                                            vertical:
                                                                Insets.i15)
                                                  ],
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }))

                                  ]).paddingSymmetric(horizontal: Insets.i20)
                                : const CommonLoader()
                            : Column(children: [
                                ...callCtrl.searchList
                                    .asMap()
                                    .entries
                                    .map((e) => StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection(collectionName.users)
                                            .doc(e.value.id)
                                            .snapshots(),
                                        builder: (context, snapshot) {

                                          if (snapshot.hasData) {

                                            return Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(children: [
                                                      CommonImage(
                                                          image: e.value.image,
                                                          name: e.value.name),
                                                      const HSpace(Sizes.s10),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                e.value.name ??
                                                                    "",
                                                                style: AppCss
                                                                    .manropeBold14
                                                                    .textColor(appCtrl
                                                                        .appTheme
                                                                        .darkText)),
                                                            const VSpace(
                                                                Sizes.s8),
                                                            Text(
                                                                e.value.statusDesc ??
                                                                    "",
                                                                style: AppCss
                                                                    .manropeMedium14
                                                                    .textColor(appCtrl
                                                                        .appTheme
                                                                        .greyText))
                                                          ])
                                                    ]),
                                                    IntrinsicHeight(
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            eSvgAssets.callOut,
                                                            height: Sizes.s22,
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    appCtrl
                                                                        .appTheme
                                                                        .darkText,
                                                                    BlendMode
                                                                        .srcIn),
                                                          ).inkWell(
                                                              onTap: () => callCtrl
                                                                  .callFromList(
                                                                      false,
                                                                      snapshot
                                                                          .data!
                                                                          .data())),
                                                          const VerticalDivider(
                                                            color:
                                                                Color.fromRGBO(
                                                                    78,
                                                                    160,
                                                                    247,
                                                                    0.20),
                                                            width: 0,
                                                            thickness: 1,
                                                          ).paddingSymmetric(
                                                              horizontal:
                                                                  Insets.i17),
                                                          SvgPicture.asset(
                                                                  eSvgAssets
                                                                      .video)
                                                              .inkWell(
                                                                  onTap: () => callCtrl
                                                                      .callFromList(
                                                                          true,
                                                                          snapshot
                                                                              .data!
                                                                              .data())),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Divider(
                                                        height: 1,
                                                        color: appCtrl.appTheme
                                                            .borderColor)
                                                    .paddingSymmetric(
                                                        vertical: Insets.i15)
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }))

                              ]).paddingSymmetric(horizontal: Insets.i20)
                      ])
                    ],
                  ).marginSymmetric(vertical: Insets.i20),
                ).inkWell(onTap: () {
                  callCtrl.isContactSearch = false;
                  callCtrl.update();
                }),
              ),
            ),
          ),
        );
      });
    });
  }
}
