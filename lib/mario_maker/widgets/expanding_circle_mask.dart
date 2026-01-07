import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/mario_maker/clippers/circle_mask_clipper.dart';
import 'package:flutter/material.dart';

/// A widget that expands a circular mask to reveal the background.
///
/// The circle starts small at the bottom center and expands to cover
/// the entire screen, revealing the background content.
class ExpandingCircleMask extends StatefulWidget {
  /// Creates an expanding circle mask widget.
  ///
  /// [background] - The widget to reveal (usually a colored background)
  /// [initialRadius] - Starting radius of the circle
  /// [delay] - Time to wait before starting the expansion
  /// [expandDuration] - How long the expansion animation takes
  /// [bottomMargin] - Distance from bottom of screen to circle center
  const ExpandingCircleMask({
    required Widget background,
    double initialRadius = 80,
    Duration delay = MarioMakerTiming.expandDelayDefault,
    Duration expandDuration = MarioMakerTiming.expandDurationDefault,
    double bottomMargin = 100,
    super.key,
  })  : _background = background,
        _initialRadius = initialRadius,
        _delay = delay,
        _expandDuration = expandDuration,
        _bottomMargin = bottomMargin;

  final Widget _background;
  final double _initialRadius;
  final Duration _delay;
  final Duration _expandDuration;
  final double _bottomMargin;

  @override
  State<ExpandingCircleMask> createState() => _ExpandingCircleMaskState();
}

class _ExpandingCircleMaskState extends State<ExpandingCircleMask>
    with TickerProviderStateMixin {
  late final AnimationController _expandController;
  late final AnimationController _bounceController;
  late Animation<double> _radiusAnimation;
  late Animation<double> _bounceAnimation;
  bool _shouldExpand = false;

  @override
  void initState() {
    super.initState();

    // Controller for the expansion animation
    _expandController = AnimationController(
      vsync: this,
      duration: widget._expandDuration,
    );

    // Controller for the bounce/jelly effect during delay
    _bounceController = AnimationController(
      vsync: this,
      duration: widget._delay,
    );

    // Bounce effect using TweenSequence
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0.85)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 0.92)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.92, end: 1.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 22,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
    ]).animate(_bounceController);

    _startAnimations();
  }

  void _startAnimations() {
    // Start bounce animation immediately
    unawaited(_bounceController.forward());

    // Start expansion after delay
    unawaited(
      Future<void>.delayed(widget._delay, () {
        if (mounted) {
          setState(() => _shouldExpand = true);
          unawaited(_expandController.forward());
        }
      }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateRadiusAnimation();
  }

  void _updateRadiusAnimation() {
    final screenSize = MediaQuery.sizeOf(context);
    final circleCenter = Offset(
      screenSize.width / 2,
      screenSize.height - widget._bottomMargin,
    );

    // Calculate max radius to cover entire screen from the circle center
    final maxRadius = _calculateMaxRadius(screenSize, circleCenter);

    _radiusAnimation = Tween<double>(
      begin: widget._initialRadius,
      end: maxRadius,
    ).animate(
      CurvedAnimation(
        parent: _expandController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  double _calculateMaxRadius(Size screenSize, Offset center) {
    // Calculate distance to all 4 corners and use the maximum
    final corners = [
      Offset.zero, // top-left
      Offset(screenSize.width, 0), // top-right
      Offset(0, screenSize.height), // bottom-left
      Offset(screenSize.width, screenSize.height), // bottom-right
    ];

    var maxDistance = 0.0;
    for (final corner in corners) {
      final distance = (corner - center).distance;
      if (distance > maxDistance) {
        maxDistance = distance;
      }
    }

    // Add a small buffer to ensure complete coverage
    return maxDistance + 50;
  }

  @override
  void dispose() {
    _expandController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final circleCenter = Offset(
      screenSize.width / 2,
      screenSize.height - widget._bottomMargin,
    );

    if (!_shouldExpand) {
      // During bounce phase: animate radius with jelly effect
      return RepaintBoundary(
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            final bouncedRadius =
                widget._initialRadius * _bounceAnimation.value;
            return ClipPath(
              clipper: CircleMaskClipper(
                radius: bouncedRadius,
                center: circleCenter,
              ),
              child: child,
            );
          },
          child: widget._background,
        ),
      );
    }

    // During expansion phase: animate radius to cover screen
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _radiusAnimation,
        builder: (context, child) {
          return ClipPath(
            clipper: CircleMaskClipper(
              radius: _radiusAnimation.value,
              center: circleCenter,
            ),
            child: child,
          );
        },
        child: widget._background,
      ),
    );
  }
}
