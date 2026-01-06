import 'package:fancy_titles/persona_5/painters/circle_painter.dart';
import 'package:flutter/material.dart';

/// This widget displays a background circle with a specific color and size.
class BackgroundCircle extends StatelessWidget {
  /// Creates a [BackgroundCircle] with the specified inflation state,
  /// delta, and color based on evenness.
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
