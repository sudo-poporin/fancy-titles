import 'package:flutter/rendering.dart';

/// Second Curtain Painter
class SecondCurtainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    final path = Path()
      ..moveTo(size.width * -0.0075000, size.height * 0.4357143)
      ..lineTo(size.width * 0.3059083, size.height * -0.0100857)
      ..lineTo(size.width * 1.0108333, size.height * -0.0457143)
      ..lineTo(size.width * 1.0140083, size.height * 1.3599286)
      ..lineTo(size.width * 0.2228083, size.height * 0.5967429)
      ..lineTo(size.width * -0.0133333, size.height * 0.9414286);

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
