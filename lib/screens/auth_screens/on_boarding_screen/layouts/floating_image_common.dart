import '../../../../config.dart';

class FloatingImageCommon extends StatelessWidget {
  final double? top, left, width, height,imageHeight,padding;
  final String? image;

  const FloatingImageCommon(
      {super.key,
      this.width,
      this.height,
      this.image,
      this.left,
      this.top,this.imageHeight,this.padding});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        top: top,
        left: left,
        child: AnimatedContainer(
            width: width,
            height: height,
            duration: const Duration(milliseconds: 100),
            child: Stack(alignment: Alignment.center, children: [
              Image.asset(image!),
              Image.asset(image!, height: imageHeight ?? 70).paddingAll(padding ?? Insets.i4).decorated(
                  border:
                      Border.all(color: appCtrl.appTheme.sameWhite, width: 2),
                  shape: BoxShape.circle)
            ])));
  }
}
