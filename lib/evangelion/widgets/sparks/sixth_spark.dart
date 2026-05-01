import 'package:fancy_titles/evangelion/painters/painters.dart';
import 'package:fancy_titles/evangelion/widgets/cached_blur_image.dart';
import 'package:flutter/material.dart';

/// Visual contents for `SparkOrder.sixth`. Internal to spark dispatcher.
class SixthSpark extends StatelessWidget {
  /// Creates the sixth spark visual.
  const SixthSpark({
    required this.duration,
    required this.curve,
    required this.fadeOut,
    required this.screenSize,
    super.key,
  });

  /// Animation duration provided by the dispatcher.
  final Duration duration;

  /// Animation curve provided by the dispatcher.
  final Curve curve;

  /// Whether the spark should be hidden.
  final bool fadeOut;

  /// Current screen size used to size the underlying painter.
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation.drive(
            Tween<double>(
              begin: 0.5,
              end: 1,
            ).chain(CurveTween(curve: curve)),
          ),
          child: child,
        );
      },
      child: fadeOut
          ? const SizedBox.shrink()
          : CachedBlurPainter(
              painter: const SixthCrossPainter(),
              size: Size(screenSize.width, screenSize.height),
              sigmaX: 5,
              sigmaY: 5,
            ),
    );
  }
}
