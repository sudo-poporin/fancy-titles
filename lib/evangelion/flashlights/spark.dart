import 'dart:ui';

import 'package:fancy_titles/evangelion/painters/painters.dart';
import 'package:flutter/material.dart';

/// Order of the flash light
enum SparkOrder {
  /// First flash light
  first,

  /// Second flash light
  second,

  /// Third flash light
  third,

  /// Fourth flash light
  fourth,

  /// Fifth flash light
  fifth,

  /// Sixth flash light
  sixth,
}

/// First Flash Light
class Spark extends StatefulWidget {
  /// Shows the first flash light of Evangelion title
  const Spark({
    required SparkOrder order,
    this.duration = const Duration(milliseconds: 50),
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
    super.key,
  }) : _order = order;

  /// Shows the first flash light of Evangelion title
  const Spark.first({super.key})
    : _order = SparkOrder.first,
      duration = const Duration(milliseconds: 75),
      curve = Curves.easeInOut,
      delay = Duration.zero;

  /// Shows the second flash light of Evangelion title
  const Spark.second({super.key})
    : _order = SparkOrder.second,
      duration = const Duration(milliseconds: 75),
      curve = Curves.easeInOut,
      delay = const Duration(milliseconds: 150);

  /// Shows the third flash light of Evangelion title
  const Spark.third({super.key})
    : _order = SparkOrder.third,
      duration = const Duration(milliseconds: 75),
      curve = Curves.easeInOut,
      delay = const Duration(milliseconds: 230);

  /// Shows the fourth flash light of Evangelion title
  const Spark.fourth({super.key})
    : _order = SparkOrder.fourth,
      duration = const Duration(milliseconds: 75),
      curve = Curves.easeInOut,
      delay = const Duration(milliseconds: 330);

  /// Shows the fifth flash light of Evangelion title
  const Spark.fifth({super.key})
    : _order = SparkOrder.fifth,
      duration = const Duration(milliseconds: 75),
      curve = Curves.easeInOut,
      delay = const Duration(milliseconds: 400);

  /// Shows the sixth flash light of Evangelion title
  const Spark.sixth({super.key})
    : _order = SparkOrder.sixth,
      duration = const Duration(milliseconds: 75),
      curve = Curves.easeInOut,
      delay = const Duration(milliseconds: 475);

  final SparkOrder _order;

  /// Duración de la animación
  final Duration duration;

  /// Curva de la animación
  final Curve curve;

  /// Retardo de la animación
  final Duration delay;

  @override
  State<Spark> createState() => _SparkState();
}

class _SparkState extends State<Spark> {
  bool _fadeOut = true;

  @override
  void initState() {
    Future<void>.delayed(
      widget.delay,
      () => setState(() => _fadeOut = false),
    ).then(
      (_) => Future<void>.delayed(
        widget.duration,
        () => setState(() => _fadeOut = true),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    switch (widget._order) {
      case SparkOrder.first:
        return AnimatedSwitcher(
          duration: widget.duration,
          reverseDuration: Duration.zero,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(
                  begin: 0.7,
                  end: 1,
                ).chain(CurveTween(curve: widget.curve)),
              ),
              child: child,
            );
          },
          child: _fadeOut
              ? const SizedBox.shrink()
              : ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: CustomPaint(
                    painter: FirstCrossPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
      case SparkOrder.second:
        return AnimatedSwitcher(
          duration: widget.duration,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(
                  begin: 0.7,
                  end: 1,
                ).chain(CurveTween(curve: widget.curve)),
              ),
              child: child,
            );
          },
          child: _fadeOut
              ? const SizedBox.shrink()
              : Stack(
                  children: [
                    Positioned(
                      right: screenSize.width * 0.08,
                      top: screenSize.height * 0.08,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: SizedBox(
                          width: screenSize.width * 1.3,
                          height: screenSize.height * 1.3,
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
                    ),
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: CustomPaint(
                        painter: SecondCrossPainter(),
                        size: Size(screenSize.width, screenSize.height),
                      ),
                    ),
                  ],
                ),
        );
      case SparkOrder.third:
        return AnimatedSwitcher(
          duration: widget.duration,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(
                  begin: 0,
                  end: 1,
                ).chain(CurveTween(curve: widget.curve)),
              ),
              child: child,
            );
          },
          child: _fadeOut
              ? const SizedBox.shrink()
              : Stack(
                  children: [
                    Positioned(
                      right: screenSize.width * -0.27,
                      top: screenSize.height * -0.27,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: SizedBox(
                          width: screenSize.width * 1.05,
                          height: screenSize.height * 1.05,
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
                    ),
                    Positioned(
                      right: screenSize.width * -0.37,
                      top: screenSize.height * -0.37,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: SizedBox(
                          width: screenSize.width * 1.25,
                          height: screenSize.height * 1.25,
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
                    ),
                    Positioned(
                      right: screenSize.width * -0.5,
                      top: screenSize.height * -0.5,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: SizedBox(
                          width: screenSize.width * 1.5,
                          height: screenSize.height * 1.5,
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
                    ),
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: CustomPaint(
                        painter: ThirdCrossPainter(),
                        size: Size(screenSize.width, screenSize.height),
                      ),
                    ),
                  ],
                ),
        );
      case SparkOrder.fourth:
        return AnimatedSwitcher(
          duration: widget.duration,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(
                  begin: 0.5,
                  end: 1,
                ).chain(CurveTween(curve: widget.curve)),
              ),
              child: child,
            );
          },
          child: _fadeOut
              ? const SizedBox.shrink()
              : Stack(
                  children: [
                    Positioned(
                      right: screenSize.width * 0.04,
                      top: screenSize.height * -0.24,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: SizedBox(
                          width: screenSize.width * 1.25,
                          height: screenSize.height * 1.25,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
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
                    ),
                    Positioned(
                      right: screenSize.width * -0.25,
                      top: screenSize.height * -0.35,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: SizedBox(
                          width: screenSize.width * 1.65,
                          height: screenSize.height * 1.65,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
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
                    ),
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: CustomPaint(
                        painter: FourthCrossRenderer(),
                        size: Size(screenSize.width, screenSize.height),
                      ),
                    ),
                  ],
                ),
        );
      case SparkOrder.fifth:
        return AnimatedSwitcher(
          duration: widget.duration,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(
                  begin: 0.5,
                  end: 1,
                ).chain(CurveTween(curve: widget.curve)),
              ),
              child: child,
            );
          },
          child: _fadeOut
              ? const SizedBox.shrink()
              : Stack(
                  children: [
                    Positioned(
                      right: screenSize.width * -1.45,
                      top: screenSize.height * -0.5,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: SizedBox(
                          width: screenSize.width * 3.7,
                          height: screenSize.height * 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 120,
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
                    ),
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: CustomPaint(
                        painter: FifthCrossPainter(),
                        size: Size(screenSize.width, screenSize.height),
                      ),
                    ),
                  ],
                ),
        );
      case SparkOrder.sixth:
        return AnimatedSwitcher(
          duration: widget.duration,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(
                  begin: 0.5,
                  end: 1,
                ).chain(CurveTween(curve: widget.curve)),
              ),
              child: child,
            );
          },
          child: _fadeOut
              ? const SizedBox.shrink()
              : ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: CustomPaint(
                    painter: SixthCrossPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
    }
  }
}
