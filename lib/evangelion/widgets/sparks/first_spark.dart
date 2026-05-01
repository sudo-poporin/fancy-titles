import 'package:fancy_titles/evangelion/painters/painters.dart';
import 'package:fancy_titles/evangelion/widgets/cached_blur_image.dart';
import 'package:flutter/material.dart';

/// Visual contents for `SparkOrder.first`. Internal to spark dispatcher.
class FirstSpark extends StatelessWidget {
  /// Creates the first spark visual.
  const FirstSpark({
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
      reverseDuration: Duration.zero,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation.drive(
            Tween<double>(
              begin: 0.7,
              end: 1,
            ).chain(CurveTween(curve: curve)),
          ),
          child: child,
        );
      },
      child: fadeOut
          ? const SizedBox.shrink()
          : CachedBlurPainter(
              painter: const FirstCrossPainter(),
              size: Size(screenSize.width, screenSize.height),
              sigmaX: 15,
              sigmaY: 15,
            ),
    );
  }
}
