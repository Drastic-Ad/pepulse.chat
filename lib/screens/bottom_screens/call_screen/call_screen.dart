import 'package:chatzy/screens/bottom_screens/call_screen/layouts/call_list_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../config.dart';
import '../../../controllers/bottom_controllers/call_list_controller.dart';

class CallScreen extends StatelessWidget {
  final callListCtrl = Get.put(CallListController());

  CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: GetBuilder<CallListController>(builder: (_) {
        return GetBuilder<DashboardController>(builder: (dashCtrl) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) return;
              if (callListCtrl.isSearch == true) {
                callListCtrl.isSearch = false;
                callListCtrl.searchText.text = "";

                dashCtrl.update();

              } else if (dashCtrl.tabController!.index != 0) {
                dashCtrl.onChange(0);
                dashCtrl.tabController!.index = 0;
                dashCtrl.update();

              } else {
                SystemNavigator.pop();

              }
            },

            child: Scaffold(
                backgroundColor: appCtrl.isTheme
                    ? appCtrl.appTheme.screenBG
                    : appCtrl.appTheme.white,
                appBar: AppBar(
                    toolbarHeight: Sizes.s70,
                    backgroundColor: appCtrl.isTheme
                        ? appCtrl.appTheme.screenBG
                        : appCtrl.appTheme.white,
                    elevation: 0,
                    actions: [
                      if (!callListCtrl.isSearch)
                        ActionIconsCommon(
                          icon: eSvgAssets.search,
                          vPadding: Insets.i15,
                          onTap: () {
                            callListCtrl.isSearch = true;
                            callListCtrl.update();
                          },
                          color: appCtrl.appTheme.white,
                        ),
                      if (!callListCtrl.isSearch) const HSpace(Sizes.s15),
                      if (!callListCtrl.isSearch)
                        ActionIconsCommon(
                          icon: eSvgAssets.trash,
                          vPadding: Insets.i15,
                          onTap: () => callListCtrl.buildPopupDialog(),
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
                              horizontal: Insets.i20),
                        )),
                    title: callListCtrl.isSearch
                        ? SizedBox(
                            height: Sizes.s50,
                            child: TextFieldCommon(
                                controller: callListCtrl.searchText,
                                hintText: "Search...",
                                fillColor: appCtrl.appTheme.white,
                                autoFocus: true,
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: appCtrl.appTheme.darkText,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.r8)),
                                keyboardType: TextInputType.multiline,
                                onChanged: (val) {
                                  callListCtrl.onSearch(val);
                                  callListCtrl.update();
                                },
                                suffixIcon:
                                    callListCtrl.searchText.text.isNotEmpty
                                        ? Icon(CupertinoIcons.multiply,
                                                color: appCtrl.appTheme.white,
                                                size: Sizes.s15)
                                            .decorated(
                                                color: appCtrl.appTheme.darkText
                                                    .withOpacity(.3),
                                                shape: BoxShape.circle)
                                            .marginAll(Insets.i12)
                                            .inkWell(onTap: () {
                                            callListCtrl.isSearch = false;
                                            callListCtrl.searchText.text = "";
                                            callListCtrl.update();
                                          })
                                        : SvgPicture.asset(eSvgAssets.search,
                                                height: Sizes.s15)
                                            .marginAll(Insets.i12)
                                            .inkWell(onTap: () {
                                            callListCtrl.isSearch = false;
                                            callListCtrl.searchText.text = "";
                                            callListCtrl.update();
                                          })),
                          )
                        : Text(appFonts.chatzy.tr,
                            style: AppCss.muktaVaani20
                                .textColor(appCtrl.appTheme.darkText))),
                body: ListView(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VSpace(Sizes.s20),
                      Text(
                        appFonts.callHistory.tr,
                        style: AppCss.manropeMedium12
                            .textColor(appCtrl.appTheme.greyText),
                      ).marginSymmetric(horizontal: Insets.i20),
                      const VSpace(Sizes.s10),
                      StreamBuilder(
                          stream: callListCtrl.searchText.text.isNotEmpty
                              ? callListCtrl
                                  .onSearch(callListCtrl.searchText.text)
                              : FirebaseFirestore.instance
                                  .collection(collectionName.calls)
                                  .doc(appCtrl.user["id"])
                                  .collection(
                                      collectionName.collectionCallHistory)
                                  .orderBy("timestamp", descending: true)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Container();
                            } else if (!snapshot.hasData) {
                              return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                    Image.asset(eImageAssets.noCall,
                                        height: Sizes.s150),
                                    Text(appFonts.youNotCall.tr,
                                            style: AppCss.manropeBold16
                                                .textColor(appCtrl
                                                    .appTheme.darkText))
                                        .paddingSymmetric(
                                            vertical: Insets.i10),
                                    Text(appFonts.thereIsNoCall.tr,
                                        textAlign: TextAlign.center,
                                        style: AppCss.manropeMedium14
                                            .textColor(
                                                appCtrl.appTheme.greyText)
                                            .textHeight(1.5))
                                  ])
                                  .height(MediaQuery.of(context).size.height /
                                      1.5)
                                  .paddingSymmetric(horizontal: Insets.i20)
                                  .alignment(Alignment.center);
                            } else {
                              return snapshot.data!.docs.isEmpty
                                  ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                          Image.asset(eImageAssets.noCall,
                                              height: Sizes.s150),
                                          Text(appFonts.youNotCall.tr,
                                                  style: AppCss.manropeBold16
                                                      .textColor(appCtrl
                                                          .appTheme.darkText))
                                              .paddingSymmetric(
                                                  vertical: Insets.i10),
                                          Text(appFonts.thereIsNoCall.tr,
                                              textAlign: TextAlign.center,
                                              style: AppCss.manropeMedium14
                                                  .textColor(appCtrl
                                                      .appTheme.greyText)
                                                  .textHeight(1.5))
                                        ])
                                      .height(
                                          MediaQuery.of(context).size.height /
                                              1.5)
                                      .paddingSymmetric(
                                          horizontal: Insets.i20)
                                      .alignment(Alignment.center)
                                  : CallListLayout(snapshot: snapshot);
                            }
                          })
                    ]).height(MediaQuery.of(context).size.height)).inkWell(onTap: () {
              callListCtrl.isSearch = false;
              callListCtrl.update();
            }),
          );
        });
      }),
    );
  }
}
