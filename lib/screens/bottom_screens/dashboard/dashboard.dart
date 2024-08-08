import 'dart:developer';
import 'package:scoped_model/scoped_model.dart';
import '../../../config.dart';
import '../../../controllers/recent_chat_controller.dart';
import '../../../models/data_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final dashboardCtrl = Get.put(DashboardController());

  @override
  void initState() {
    // TODO: implement initState
    dashboardCtrl.prefs = Get.arguments;
    WidgetsBinding.instance.addObserver(this);
    dashboardCtrl.initConnectivity();
    setState(() {});
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    log("state ; $state");
    if (state == AppLifecycleState.resumed) {
      firebaseCtrl.setIsActive();
      dashboardCtrl.update();
      Get.forceAppUpdate();
    } else {
      firebaseCtrl.setLastSeen();
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {}
    // firebaseCtrl.statusDeleteAfter24Hours();
    //  firebaseCtrl.deleteForAllUsers();
    firebaseCtrl.syncContact();
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: ScopedModel<DataModel>(
          model: appCtrl.getModel()!,
          child: ScopedModelDescendant<DataModel>(
              builder: (context, child, model) {
            appCtrl.cachedModel = model;
            return Consumer<RecentChatController>(
                builder: (context, recentChat, child) {
              return GetBuilder<DashboardController>(builder: (_) {
                return DirectionalityRtl(
                  child: Scaffold(
                      backgroundColor: appCtrl.appTheme.screenBG,
                      body: dashboardCtrl.bottomNavLists.isEmpty
                          ? Container()
                          : DefaultTabController(
                              length: dashboardCtrl.bottomNavLists.length,
                              initialIndex: 0,
                              child: Column(
                                children: [
                                  AppBar(
                                    toolbarHeight: 1,
                                  ),
                                  Container(
                                    height: Sizes.s70,
                                    child: TabBar(
                                      onTap: (val) {
                                        dashboardCtrl.tabController?.index =
                                            val;
                                        dashboardCtrl.update();
                                      },
                                      controller: dashboardCtrl.tabController,
                                      labelColor: appCtrl.appTheme.primary,
                                      labelStyle: AppCss.manropeSemiBold12
                                          .textColor(appCtrl.appTheme.primary),
                                      unselectedLabelColor:
                                          appCtrl.appTheme.greyText,
                                      unselectedLabelStyle: AppCss
                                          .manropeSemiBold12
                                          .textColor(appCtrl.appTheme.greyText),
                                      isScrollable: false,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      indicator: materialIndicator(),
                                      tabs: dashboardCtrl.bottomNavLists
                                          .asMap()
                                          .entries
                                          .map((e) {
                                        print(e);
                                        return Tab(
                                          icon: e.key == 4
                                              ? SizedBox(
                                                      height: Sizes.s25,
                                                      width: Sizes.s25,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                                  Radius.circular(
                                                                      AppRadius
                                                                          .r20)),
                                                          child: dashboardCtrl
                                                                      .data !=
                                                                  ""
                                                              ? Image.network(dashboardCtrl.data!,
                                                                  fit: BoxFit
                                                                      .cover)
                                                              : Text(
                                                                  appCtrl.user[
                                                                      'name'][0],
                                                                  style: AppCss
                                                                      .manropeMedium14
                                                                      .textColor(appCtrl
                                                                          .appTheme
                                                                          .white),
                                                                ).alignment(Alignment.center).paddingOnly(
                                                                  top: 2)))
                                                  .paddingAll(Insets.i1)
                                                  .decorated(
                                                    color: appCtrl
                                                        .appTheme.primary,
                                                    shape: BoxShape.circle,
                                                  )
                                              : SvgPicture.asset(dashboardCtrl
                                                          .tabController
                                                          ?.index ==
                                                      e.key
                                                  ? e.value["icon"]
                                                  : e.value["icon2"]),
                                          text: e.value["title"].toString().tr,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: dashboardCtrl.tabController,
                                      children: dashboardCtrl.pages,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                );
              });
            });
          })),
    );
  }
}
