import 'package:flutter/rendering.dart';

/// Fourth Curtain Painter
class FourthCurtainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    final path = Path()
      ..moveTo(size.width * 0.2875000, size.height * 0.6400000)
      ..lineTo(size.width * 0.5491667, size.height * 0.3385714)
      ..lineTo(size.width * 0.6591667, size.height * 0.5142857)
      ..lineTo(size.width * 0.6308333, size.height * 0.6100000)
      ..lineTo(size.width * 1.0016667, size.height * 0.2514286)
      ..lineTo(size.width * 1.0116667, size.height * 0.6114286)
      ..lineTo(size.width * 0.7350000, size.height * 0.7585714)
      ..lineTo(size.width * 0.5825000, size.height * 0.7057143)
      ..lineTo(size.width * 0.5350000, size.height * 0.7842857)
      ..lineTo(size.width * 0.6616667, size.height * 1.0328571)
      ..lineTo(size.width * 0.4313667, size.height * 1.0395143)
      ..lineTo(size.width * 0.4241667, size.height * 0.8000000)
      ..lineTo(size.width * 0.3816667, size.height * 1.0228571)
      ..lineTo(size.width * 0.0533333, size.height * 1.0400000)
      ..lineTo(size.width * 0.3291667, size.height * 0.8171429);

    canvas.drawPath(path, paintFill);

    final paintStroke = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
