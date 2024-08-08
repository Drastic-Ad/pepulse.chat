import 'dart:developer';

import 'package:scoped_model/scoped_model.dart';
import '../../../../config.dart';
import '../../../../controllers/recent_chat_controller.dart';
import '../../../../models/data_model.dart';

/*class ChatCard extends StatefulWidget {
  const ChatCard({super.key});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final messageCtrl = Get.isRegistered<ChatDashController>()
      ? Get.find<ChatDashController>()
      : Get.put(ChatDashController());

  final scrollController = ScrollController();
  int inviteContactsCount = 30;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  String? sharedSecret;
  String? privateKey;

  void scrollListener() {
    if (scrollController.offset >=
        scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      setStateIfMounted(() {
        inviteContactsCount += 250;
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
    return GetBuilder<ChatDashController>(builder: (messageCtrl) {
      return GetBuilder<DashboardController>(builder: (dashboardCtrl) {
        return Consumer<RecentChatController>(
          builder: (context, recentChat, child) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(appCtrl.user["id"])
                  .collection(collectionName.chats)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(eImageAssets.noChat, height: Sizes.s150),
                        Text(
                          appFonts.noChat.tr,
                          style: AppCss.manropeBold16.textColor(appCtrl.appTheme.darkText),
                        ).paddingSymmetric(vertical: Insets.i10),
                        Text(
                          appFonts.thereIsNoChat.tr,
                          textAlign: TextAlign.center,
                          style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.greyText).textHeight(1.5),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: Insets.i20).alignment(Alignment.center),
                  );
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    recentChat.updateChats(snapshot.data!.docs);
                  });

                  return Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: recentChat.messageWidgetList.length,
                      itemBuilder: (context, index) {
                        return recentChat.messageWidgetList[index];
                      },
                    ),
                  );
                }
              },
            );
          },
        );
      });
    });
  }
}*/

class ChatCard extends StatefulWidget {
  const ChatCard({super.key});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final messageCtrl = Get.isRegistered<ChatDashController>()
      ? Get.find<ChatDashController>()
      : Get.put(ChatDashController());

  final scrollController = ScrollController();
  int inviteContactsCount = 30;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    refreshChats();
  }

  void refreshChats() {
    final recentChatController = context.read<RecentChatController>();
    FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.chats)
        .snapshots()
        .listen((snapshot) {
      recentChatController.updateChats(snapshot.docs);
    });
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
    return GetBuilder<ChatDashController>(builder: (messageCtrl) {
      return GetBuilder<DashboardController>(builder: (dashboardCtrl) {
        return Consumer<RecentChatController>(
            builder: (context, recentChat, child) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(appCtrl.user["id"])
                  .collection(collectionName.chats)
                  .snapshots(),
              builder: (context, snapshot) {
                return ScopedModelDescendant<DataModel>(
                    builder: (context, child, model) {
                  appCtrl.cachedModel = model;
                  return recentChat.userData.isNotEmpty
                      ? Expanded(
                          child:
                              ListView(controller: scrollController, children: [
                            Column(
                              children: [
                                ...recentChat.messageWidgetList
                                    .asMap()
                                    .entries
                                    .map((e) => e.value)
                              ],
                            ).marginSymmetric(
                                vertical: Insets.i20, horizontal: Insets.i10)
                          ]),
                        )
                      : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Image.asset(eImageAssets.noChat,
                                  height: Sizes.s150),
                              Text(appFonts.noChat.tr,
                                      style: AppCss.manropeBold16
                                          .textColor(appCtrl.appTheme.darkText))
                                  .paddingSymmetric(vertical: Insets.i10),
                              Text(appFonts.thereIsNoChat.tr,
                                  textAlign: TextAlign.center,
                                  style: AppCss.manropeMedium14
                                      .textColor(appCtrl.appTheme.greyText)
                                      .textHeight(1.5))
                            ])
                          .paddingSymmetric(horizontal: Insets.i20)
                          .alignment(Alignment.center);
                });
              });
        });
      });
    });
  }
}
