import 'package:flutter/rendering.dart';

/// First Curtain Painter
class FirstCurtainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    final path = Path()
      ..moveTo(size.width * -0.0175000, size.height * 0.4271429)
      ..lineTo(size.width * 0.2166667, size.height * -0.0628571)
      ..lineTo(size.width * 1.0158333, size.height * -0.0157143)
      ..lineTo(size.width * 1.0083333, size.height * 1.0542857)
      ..lineTo(size.width * -0.0300000, size.height * 1.0600000);

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
