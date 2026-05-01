import 'package:fancy_titles/evangelion/painters/painters.dart';
import 'package:fancy_titles/evangelion/widgets/cached_blur_image.dart';
import 'package:fancy_titles/evangelion/widgets/cached_blur_widget.dart';
import 'package:flutter/material.dart';

/// Visual contents for [SparkOrder.second]. Internal to spark dispatcher.
class SecondSpark extends StatelessWidget {
  /// Creates the second spark visual.
  const SecondSpark({
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
              begin: 0.7,
              end: 1,
            ).chain(CurveTween(curve: curve)),
          ),
          child: child,
        );
      },
      child: fadeOut
          ? const SizedBox.shrink()
          : Stack(
              children: [
                Positioned(
                  right: screenSize.width * 0.08,
                  top: screenSize.height * 0.08,
                  child: CachedBlurWidget(
                    size: Size(
                      screenSize.width * 1.3,
                      screenSize.height * 1.3,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(163, 255, 255, 255),
                          width: 100,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF2196F3),
                            blurRadius: 10,
                            spreadRadius: 10,
                            blurStyle: BlurStyle.outer,
                          ),
                          BoxShadow(
                            color: Color(0xFF00BCD4),
                            blurRadius: 10,
                            spreadRadius: -10,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                CachedBlurPainter(
                  painter: const SecondCrossPainter(),
                  size: Size(screenSize.width, screenSize.height),
                ),
              ],
            ),
    );
  }
}
