import '../../../../config.dart';

class SelfieImageCommon extends StatelessWidget {
  final String? image;
  const SelfieImageCommon({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Sizes.s160,
        height: Sizes.s160,
        child: Image(
            image: AssetImage(image!),
            gaplessPlayback: true
        )
    );
  }
}
