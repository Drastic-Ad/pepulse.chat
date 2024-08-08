import 'package:chatzy/config.dart';

class OnBoardingScreen extends StatelessWidget {
  final onBoardingCtrl = Get.put(OnBoardingController());

  OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(builder: (_) {
      return Scaffold(
          backgroundColor: appCtrl.appTheme.screenBG,
          body: Stack(children: [
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              const VSpace(Sizes.s10),
              Stack(alignment: Alignment.bottomCenter, children: [
                Stack(alignment: Alignment.bottomCenter, children: [
                  Column(children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [BoardingLineLayout(), BoardingLineLayout()]),
                    SizedBox(
                        height: Sizes.s180,
                        width: MediaQuery.of(context).size.width)
                  ]),
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 1.41,
                      child: Column(children: [
                        Image.asset(
                            onBoardingCtrl.selectIndex == 0
                                ? eImageAssets.ob1
                                : onBoardingCtrl.selectIndex == 1
                                    ? eImageAssets.ob2
                                    : eImageAssets.ob3,
                            height: MediaQuery.of(context).size.height / 2.73)
                      ]))
                ]),
                Stack(children: [
                  const Stack(
                      alignment: Alignment.bottomCenter,
                      children: [OnBoardTextData(), BottomLayout()]),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SemiCircleIconColor(),
                        SemiCircleIconColor()
                      ]).paddingSymmetric(
                      horizontal: MediaQuery.of(context).size.width / 7.2)
                ])
              ])
            ]),
            onBoardingCtrl.selectIndex == 0
                ? CarouselSlider(
                        options: CarouselOptions(
                            height: Sizes.s150,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true),
                        items: appArray.reelsList.map((i) {
                          return Builder(builder: (BuildContext context) {
                            return Image.asset(i, fit: BoxFit.fitWidth);
                          });
                        }).toList())
                    .paddingOnly(top: Insets.i30)
                : onBoardingCtrl.selectIndex == 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            SelfieImageCommon(image: onBoardingCtrl.photo),
                            SelfieImageCommon(image: onBoardingCtrl.photo2)
                          ]).paddingOnly(top: Insets.i50)
                    : const FloatingImagesLayout()
          ]).paddingOnly(bottom: Insets.i35));
    });
  }
}
