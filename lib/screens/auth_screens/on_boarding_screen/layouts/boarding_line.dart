import '../../../../config.dart';

class BoardingLineLayout extends StatelessWidget {
  const BoardingLineLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SemiCircleIcon(),
      Row(children: [
        DottedLines(
            direction: Axis.vertical,
            width: Sizes.s50,
            color: appCtrl.appTheme.greyText),
        const HSpace(Sizes.s2),
        DottedLines(
            direction: Axis.vertical,
            width: Sizes.s50,
            color: appCtrl.appTheme.greyText)
      ]),
      const SizedBox(height: Sizes.s30, width: Sizes.s30).decorated(
          shape: BoxShape.circle,
          border: Border.all(color: appCtrl.appTheme.greyText))
    ]);
  }
}
