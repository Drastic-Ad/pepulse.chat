import '../config.dart';

class DottedLines extends StatelessWidget {
  final Color? color;
  final double? width;
  final Axis? direction;
  const DottedLines({super.key,this.color,this.width,this.direction});

  @override
  Widget build(BuildContext context) {
    return DottedLine(
        direction: direction ?? Axis.horizontal,
        lineLength: width ?? double.infinity,
        lineThickness: 1,
        dashLength: 2,
        dashColor:color ?? appCtrl.appTheme.darkText);
  }
}
