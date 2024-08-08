import '../../config.dart';

class GradientPainter extends CustomPainter {
  GradientPainter({
    required this.strokeWidth,
    required this.radius,
    required this.borderColor,
  });

  final double radius;
  final double strokeWidth;

  final Color borderColor;
  final Paint _paintObject = Paint();

  LinearGradient get _gradient => LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: <Color>[
      borderColor.withAlpha(50),
      borderColor.withAlpha(55),
      borderColor.withAlpha(50),
    ],
    stops: const <double>[0.06, 0.95, 1],
  );

  @override
  void paint(Canvas canvas, Size size) {
    final RRect innerRect2 = RRect.fromRectAndRadius(
      Rect.fromLTRB(strokeWidth, strokeWidth, size.width - strokeWidth,
          size.height - strokeWidth),
      Radius.circular(radius - strokeWidth),
    );

    final RRect outerRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    _paintObject.shader = _gradient.createShader(Offset.zero & size);

    final Path outerRectPath = Path()..addRRect(outerRect);
    final Path innerRectPath2 = Path()..addRRect(innerRect2);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        outerRectPath,
        Path.combine(
          PathOperation.intersect,
          outerRectPath,
          innerRectPath2,
        ),
      ),
      _paintObject,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}