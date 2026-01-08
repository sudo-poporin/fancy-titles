import 'dart:async';
import 'dart:math';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/cancelable_timers.dart';
import 'package:flutter/material.dart';

/// Class [BounceVertically]: Bounce animation vertically using sin function.
/// [child]: mandatory, widget to animate
/// [duration]: how much time the animation should take
/// [key]: optional widget key reference
class BounceVertically extends StatefulWidget {
  /// Constructor
  const BounceVertically({
    required Widget child,
    Duration delay = Duration.zero,
    bool bounceUp = true,
    super.key,
  }) : _delay = delay,
       _child = child,
       _bounceUp = bounceUp;

  final Widget _child;

  final Duration _delay;

  final bool _bounceUp;

  @override
  BounceVerticallyState createState() => BounceVerticallyState();
}

/// State class,
/// Controls the animations flow
class BounceVerticallyState extends State<BounceVertically>
    with SingleTickerProviderStateMixin, CancelableTimersMixin {
  /// The controller of the animation
  late AnimationController _controller;

  /// Animation controller
  late Animation<double> _animation;

  /// Animation opacity
  late Animation<double> opacity;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: SonicManiaTiming.bounceVerticallyDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.4)),
    );

    _buildAnimation(widget._delay);

    super.initState();
  }

  /// This method is used to build the animation
  void _buildAnimation(Duration delay) {
    // Start animation after bounceVerticallyDelay + custom delay
    final totalDelay = SonicManiaTiming.bounceVerticallyDelay + delay;
    delayed(totalDelay, () {
      unawaited(_controller.forward());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget._child,
      builder: (context, child) {
        // FadeTransition es más eficiente que Opacity widget
        // porque no fuerza un saveLayer costoso
        return FadeTransition(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(
              0,
              sin(2 * pi * _animation.value) * (widget._bounceUp ? 40 : -40),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
