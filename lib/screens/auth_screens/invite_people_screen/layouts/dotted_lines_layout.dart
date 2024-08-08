import '../../../../config.dart';

class DottedLinesWithRound extends StatelessWidget {
  const DottedLinesWithRound({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.circle,size: Sizes.s7,color: appCtrl.appTheme.white),
                Icon(Icons.circle,size: Sizes.s3,color: appCtrl.appTheme.primary)
              ]
          ),
          DottedLines(width: MediaQuery.of(context).size.width / 18,color: appCtrl.appTheme.primary)
        ]
    );
  }
}
