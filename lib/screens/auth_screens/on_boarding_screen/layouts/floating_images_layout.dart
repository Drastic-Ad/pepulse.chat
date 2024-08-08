import '../../../../config.dart';

class FloatingImagesLayout extends StatelessWidget {
  const FloatingImagesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      builder: (onBoardingCtrl) {
        return Stack(children: [
          FloatingImageCommon(
              top: onBoardingCtrl.isPositionedRight ? 77 : 66,
              left: onBoardingCtrl.isPositionedRight ? 160 : 20,
              width: onBoardingCtrl.isPositionedRight ? 80 : 50,
              height: onBoardingCtrl.isPositionedRight ? 80 : 50,
              imageHeight: onBoardingCtrl.isPositionedRight ? 70 : 45,
              padding: onBoardingCtrl.isPositionedRight ? Insets.i4 : Insets.i2,
              image: eImageAssets.obYellow),
          FloatingImageCommon(
              top: onBoardingCtrl.isPositionedRight ? 66 : 77,
              left: onBoardingCtrl.isPositionedRight ? 20 : 160,
              width: onBoardingCtrl.isPositionedRight ? 50 : 80,
              height: onBoardingCtrl.isPositionedRight ? 50 : 80,
              imageHeight: onBoardingCtrl.isPositionedRight ? 45 : 70,
              padding: onBoardingCtrl.isPositionedRight ? Insets.i2 : Insets.i4,
              image: eImageAssets.obSky),
          FloatingImageCommon(
              top: onBoardingCtrl.isPositionedRight ? 143 : 50,
              left: onBoardingCtrl.isPositionedRight ? 80 : 290,
              width: 50,
              height: 50,
              imageHeight:  45,
              padding: Insets.i1,
              image: eImageAssets.obPink),
          FloatingImageCommon(
              top: onBoardingCtrl.isPositionedRight ? 50 : 150,
              left: onBoardingCtrl.isPositionedRight ? 290 : 267,
              width: 50,
              height: 50,
              imageHeight: 45,
              padding: Insets.i1,
              image: eImageAssets.obBlue),
          FloatingImageCommon(
              top: onBoardingCtrl.isPositionedRight ? 150 : 140,
              left: onBoardingCtrl.isPositionedRight ? 267 : 86,
              width: onBoardingCtrl.isPositionedRight ? 54 : 50,
              height: onBoardingCtrl.isPositionedRight ? 54 : 50,
              imageHeight:  45 ,
              padding: onBoardingCtrl.isPositionedRight ? Insets.i3 : Insets.i1,
              image: eImageAssets.obPurple)
        ]);
      }
    );
  }
}
