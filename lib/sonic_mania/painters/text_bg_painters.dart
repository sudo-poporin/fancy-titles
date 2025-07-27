import 'package:flutter/rendering.dart';

/// Dibuja la barra de texto
class LargeBGDraw extends CustomPainter {
  /// Dibuja la barra de texto
  LargeBGDraw(Color color) {
    painter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  /// Constructor de CustomDraw
  late Paint painter;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(-48, size.height * 0.6)
      ..lineTo(0, size.height * 0.6)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width + 48, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Dibuja la barra de texto
class SmallBGDraw extends CustomPainter {
  /// Dibuja la barra de texto
  SmallBGDraw(Color color) {
    painter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  /// Constructor de CustomDraw
  late Paint painter;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(-24, size.height * 0.8)
      ..lineTo(0, size.height * 0.8)
      ..lineTo(size.width, size.height * 0.8)
      ..lineTo(size.width + 24, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
