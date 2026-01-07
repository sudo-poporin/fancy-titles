import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/evangelion/painters/painters.dart';
import 'package:flutter/material.dart';

/// Order of the curtain
enum CurtainOrder {
  /// First curtain
  first,

  /// Second curtain
  second,

  /// Third curtain
  third,

  /// Fourth curtain
  fourth,

  /// Fifth curtain
  fifth,

  /// Sixth curtain
  sixth,
}

/// Shows the curtains of Evangelion title
class Curtain extends StatefulWidget {
  /// Shows the first flash light of Evangelion title
  const Curtain({
    required CurtainOrder order,
    Duration duration = EvangelionTiming.sparkDefaultDuration,
    Curve curve = Curves.easeInOut,
    Duration delay = EvangelionTiming.curtainFirstDelay,
    super.key,
  }) : _delay = delay,
       _curve = curve,
       _duration = duration,
       _order = order;

  /// Shows the first curtain of Evangelion title
  const Curtain.first({super.key})
    : _order = CurtainOrder.first,
      _duration = EvangelionTiming.curtainFirstDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainFirstDelay;

  /// Shows the second curtain of Evangelion title
  const Curtain.second({super.key})
    : _order = CurtainOrder.second,
      _duration = EvangelionTiming.curtainSecondaryDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainSecondDelay;

  /// Shows the third curtain of Evangelion title
  const Curtain.third({super.key})
    : _order = CurtainOrder.third,
      _duration = EvangelionTiming.curtainSecondaryDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainThirdDelay;

  /// Shows the fourth curtain of Evangelion title
  const Curtain.fourth({super.key})
    : _order = CurtainOrder.fourth,
      _duration = EvangelionTiming.curtainSecondaryDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainFourthDelay;

  /// Shows the fifth curtain of Evangelion title
  const Curtain.fifth({super.key})
    : _order = CurtainOrder.fifth,
      _duration = EvangelionTiming.curtainSecondaryDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainFifthDelay;

  /// Shows the sixth curtain of Evangelion title
  const Curtain.sixth({super.key})
    : _order = CurtainOrder.sixth,
      _duration = EvangelionTiming.curtainSecondaryDuration,
      _curve = Curves.easeInOut,
      _delay = EvangelionTiming.curtainSixthDelay;

  final CurtainOrder _order;
  final Duration _duration;
  final Curve _curve;
  final Duration _delay;

  @override
  State<Curtain> createState() => _CurtainState();
}

class _CurtainState extends State<Curtain> {
  bool _fadeOut = true;

  @override
  void initState() {
    super.initState();

    unawaited(
      Future<void>.delayed(widget._delay, () {
        if (!mounted) return;
        setState(() => _fadeOut = false);
      }).then((_) {
        return Future<void>.delayed(widget._duration, () {
          if (!mounted) return;
          setState(() => _fadeOut = true);
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    switch (widget._order) {
      case CurtainOrder.first:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _fadeOut
              ? const SizedBox.shrink()
              : const SizedBox.expand(child: ColoredBox(color: Colors.black)),
        );
      case CurtainOrder.second:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: _fadeOut
              ? const SizedBox.shrink()
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: const FirstCurtainPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
      case CurtainOrder.third:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: _fadeOut
              ? const SizedBox.shrink()
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: const SecondCurtainPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
      case CurtainOrder.fourth:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: _fadeOut
              ? const SizedBox.shrink()
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: const ThirdCurtainPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
      case CurtainOrder.fifth:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: _fadeOut
              ? const SizedBox.shrink()
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: const FourthCurtainPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
      case CurtainOrder.sixth:
        return AnimatedSwitcher(
          duration: widget._duration,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation.drive(
              Tween<double>(
                begin: 0.5,
                end: 1,
              ).chain(CurveTween(curve: widget._curve)),
            ),
            child: child,
          ),
          child: _fadeOut
              ? const SizedBox.shrink()
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: const FifthCurtainPainter(),
                    size: Size(screenSize.width, screenSize.height),
                  ),
                ),
        );
    }
  }
}
