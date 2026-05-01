import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/cancelable_timers.dart';
import 'package:fancy_titles/evangelion/widgets/sparks/sparks.dart';
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
    this.duration = EvangelionTiming.sparkDefaultDuration,
    this.curve = Curves.easeInOut,
    this.delay = EvangelionTiming.sparkFirstDelay,
    super.key,
  }) : _order = order;

  /// Shows the first flash light of Evangelion title
  const Spark.first({super.key})
    : _order = SparkOrder.first,
      duration = EvangelionTiming.crossFlashDuration,
      curve = Curves.easeInOut,
      delay = EvangelionTiming.sparkFirstDelay;

  /// Shows the second flash light of Evangelion title
  const Spark.second({super.key})
    : _order = SparkOrder.second,
      duration = EvangelionTiming.crossFlashDuration,
      curve = Curves.easeInOut,
      delay = EvangelionTiming.sparkSecondDelay;

  /// Shows the third flash light of Evangelion title
  const Spark.third({super.key})
    : _order = SparkOrder.third,
      duration = EvangelionTiming.crossFlashDuration,
      curve = Curves.easeInOut,
      delay = EvangelionTiming.sparkThirdDelay;

  /// Shows the fourth flash light of Evangelion title
  const Spark.fourth({super.key})
    : _order = SparkOrder.fourth,
      duration = EvangelionTiming.crossFlashDuration,
      curve = Curves.easeInOut,
      delay = EvangelionTiming.sparkFourthDelay;

  /// Shows the fifth flash light of Evangelion title
  const Spark.fifth({super.key})
    : _order = SparkOrder.fifth,
      duration = EvangelionTiming.crossFlashDuration,
      curve = Curves.easeInOut,
      delay = EvangelionTiming.sparkFifthDelay;

  /// Shows the sixth flash light of Evangelion title
  const Spark.sixth({super.key})
    : _order = SparkOrder.sixth,
      duration = EvangelionTiming.crossFlashDuration,
      curve = Curves.easeInOut,
      delay = EvangelionTiming.sparkSixthDelay;

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

class _SparkState extends State<Spark> with CancelableTimersMixin {
  bool _fadeOut = true;

  @override
  void initState() {
    super.initState();

    // Show spark after delay
    delayed(widget.delay, () {
      setState(() => _fadeOut = false);
    });

    // Hide spark after delay + duration
    delayed(widget.delay + widget.duration, () {
      setState(() => _fadeOut = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    switch (widget._order) {
      case SparkOrder.first:
        return FirstSpark(
          duration: widget.duration,
          curve: widget.curve,
          fadeOut: _fadeOut,
          screenSize: screenSize,
        );
      case SparkOrder.second:
        return SecondSpark(
          duration: widget.duration,
          curve: widget.curve,
          fadeOut: _fadeOut,
          screenSize: screenSize,
        );
      case SparkOrder.third:
        return ThirdSpark(
          duration: widget.duration,
          curve: widget.curve,
          fadeOut: _fadeOut,
          screenSize: screenSize,
        );
      case SparkOrder.fourth:
        return FourthSpark(
          duration: widget.duration,
          curve: widget.curve,
          fadeOut: _fadeOut,
          screenSize: screenSize,
        );
      case SparkOrder.fifth:
        return FifthSpark(
          duration: widget.duration,
          curve: widget.curve,
          fadeOut: _fadeOut,
          screenSize: screenSize,
        );
      case SparkOrder.sixth:
        return SixthSpark(
          duration: widget.duration,
          curve: widget.curve,
          fadeOut: _fadeOut,
          screenSize: screenSize,
        );
    }
  }
}
