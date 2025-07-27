import 'package:fancy_titles/persona_5/consts/const.dart';
import 'package:flutter/material.dart';

/// This class is used to paint concentric circles on the screen.
class CirclePainter extends CustomPainter {
  /// Creates a [CirclePainter] that draws circles based on the provided
  /// inflation state and a list of inflated values.
  const CirclePainter({required List<int> inflatedValues})
    : _inflatedValues = inflatedValues;

  final List<int> _inflatedValues;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width * 0.5, size.height * 0.5),
      radius: size.width * 0.25,
    );

    for (var i = 0; i < _inflatedValues.length; i++) {
      canvas.drawPath(
        Path()..addOval(rect.inflate(_inflatedValues[i].toDouble())),
        Paint()..color = i.isEven ? redColor : blackColor,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
