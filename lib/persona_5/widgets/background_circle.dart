import 'package:fancy_titles/persona_5/painters/circle_painter.dart';
import 'package:flutter/material.dart';

/// Widget que muestra los circulos concentricos del fondo de Persona 5.
///
/// Renderiza multiples circulos concentricos alternando entre rojo y negro,
/// creando el efecto visual de espiral/vortice caracteristico de los menus
/// de Persona 5.
///
/// Los circulos se dibujan usando [CirclePainter] con valores de inflacion
/// predefinidos que van desde 1200 hasta -200 pixeles, creando 15 circulos
/// concentricos.
///
/// El widget esta envuelto en un [RepaintBoundary] para aislar los repintados
/// y mejorar el rendimiento.
///
/// Se utiliza internamente en `Persona5Title` como capa de fondo detras
/// del texto y la imagen.
///
/// ## Ejemplo
///
/// ```dart
/// Stack(
///   children: [
///     BackgroundCircle(),
///     // Otros widgets encima...
///   ],
/// )
/// ```
///
/// Ver tambien:
/// - [CirclePainter] el painter que dibuja los circulos
/// - `Persona5Title` widget principal que usa este componente
class BackgroundCircle extends StatelessWidget {
  /// Crea el fondo de circulos concentricos estilo Persona 5.
  const BackgroundCircle({super.key});

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary aísla los repintados de los círculos concéntricos
    return const RepaintBoundary(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: CirclePainter(
            inflatedValues: [
              1200,
              1100,
              1000,
              900,
              800,
              700,
              600,
              500,
              400,
              300,
              200,
              100,
              0,
              -100,
              -200,
            ],
          ),
        ),
      ),
    );
  }
}
