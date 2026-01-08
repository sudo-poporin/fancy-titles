import 'package:fancy_titles/persona_5/constants/constants.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

/// Painter que dibuja círculos concéntricos para la animación Persona 5.
///
/// Este painter crea un efecto de círculos expandidos alternando entre
/// rojo y negro, característico de las transiciones del juego Persona 5.
///
/// Los círculos se dibujan desde el exterior hacia el interior,
/// creando un efecto visual de ondas concéntricas.
class CirclePainter extends CustomPainter {
  /// Crea un [CirclePainter] que dibuja círculos basados en los valores
  /// de inflación proporcionados.
  ///
  /// [inflatedValues] lista de valores que determinan el radio adicional
  /// de cada círculo concéntrico.
  const CirclePainter({required List<int> inflatedValues})
    : _inflatedValues = inflatedValues;

  final List<int> _inflatedValues;

  // Paint objects pre-creados (inmutables)
  static final _redPaint = Paint()..color = redColor;
  static final _blackPaint = Paint()..color = blackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final baseRadius = size.width * 0.25;

    for (var i = 0; i < _inflatedValues.length; i++) {
      // Usar drawOval en lugar de drawPath(Path..addOval)
      // Esto evita la creación del Path intermedio
      final radius = baseRadius + _inflatedValues[i];
      canvas.drawOval(
        Rect.fromCircle(center: center, radius: radius),
        i.isEven ? _redPaint : _blackPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    // Solo repintar si los valores cambian
    return !listEquals(_inflatedValues, oldDelegate._inflatedValues);
  }
}
