import 'package:fancy_titles/persona_5/persona_5_theme.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

/// Painter que dibuja círculos concéntricos para la animación Persona 5.
///
/// Este painter crea un efecto de círculos expandidos alternando entre
/// dos colores, característico de las transiciones del juego Persona 5.
///
/// Los círculos se dibujan desde el exterior hacia el interior,
/// creando un efecto visual de ondas concéntricas.
class CirclePainter extends CustomPainter {
  /// Crea un [CirclePainter] que dibuja círculos basados en los valores
  /// de inflación proporcionados.
  ///
  /// [inflatedValues] lista de valores que determinan el radio adicional
  /// de cada círculo concéntrico.
  /// [primaryColor] color de los círculos pares (por defecto rojo).
  /// [secondaryColor] color de los círculos impares (por defecto negro).
  CirclePainter({
    required List<int> inflatedValues,
    Color primaryColor = Persona5Colors.red,
    Color secondaryColor = Persona5Colors.black,
  })  : _inflatedValues = inflatedValues,
        _primaryPaint = Paint()..color = primaryColor,
        _secondaryPaint = Paint()..color = secondaryColor,
        _primaryColor = primaryColor,
        _secondaryColor = secondaryColor;

  final List<int> _inflatedValues;
  final Paint _primaryPaint;
  final Paint _secondaryPaint;
  final Color _primaryColor;
  final Color _secondaryColor;

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
        i.isEven ? _primaryPaint : _secondaryPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    // Solo repintar si los valores o colores cambian
    return !listEquals(_inflatedValues, oldDelegate._inflatedValues) ||
        _primaryColor != oldDelegate._primaryColor ||
        _secondaryColor != oldDelegate._secondaryColor;
  }
}
