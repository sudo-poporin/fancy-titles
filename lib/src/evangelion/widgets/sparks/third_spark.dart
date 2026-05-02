import 'package:fancy_titles/evangelion/painters/painters.dart';
import 'package:fancy_titles/evangelion/widgets/cached_blur_image.dart';
import 'package:fancy_titles/evangelion/widgets/cached_blur_widget.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Visual contents for `SparkOrder.third`. Internal to spark dispatcher.
@internal
class ThirdSpark extends StatelessWidget {
  /// Creates the third spark visual.
  const ThirdSpark({
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
              begin: 0,
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
                  right: screenSize.width * -0.27,
                  top: screenSize.height * -0.27,
                  child: CachedBlurWidget(
                    size: Size(
                      screenSize.width * 1.05,
                      screenSize.height * 1.05,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(40, 24, 67, 237),
                          width: 60,
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
                Positioned(
                  right: screenSize.width * -0.37,
                  top: screenSize.height * -0.37,
                  child: CachedBlurWidget(
                    size: Size(
                      screenSize.width * 1.25,
                      screenSize.height * 1.25,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(40, 24, 237, 70),
                          width: 60,
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
                Positioned(
                  right: screenSize.width * -0.5,
                  top: screenSize.height * -0.5,
                  child: CachedBlurWidget(
                    size: Size(
                      screenSize.width * 1.5,
                      screenSize.height * 1.5,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(28, 237, 24, 24),
                          width: 80,
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
                  painter: const ThirdCrossPainter(),
                  size: Size(screenSize.width, screenSize.height),
                ),
              ],
            ),
    );
  }
}
