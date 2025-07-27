import 'package:flutter/rendering.dart';

/// Fifth Curtain Painter
class FifthCurtainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    final path = Path()
      ..moveTo(size.width * 0.5569083, size.height * 0.6831714)
      ..lineTo(size.width * 0.4068417, size.height * 0.4750000)
      ..lineTo(size.width * 0.6205667, size.height * 0.3341714)
      ..lineTo(size.width * 0.6709917, size.height * 0.4868143);

    canvas.drawPath(path, paintFill);

    final paintStroke = Paint()
      ..color = const Color.fromARGB(255, 22, 22, 22)
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
