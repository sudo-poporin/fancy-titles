import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:flutter/material.dart';

/// A circle that bounces (scales up and down) during animation.
///
/// Used to create the bounce effect in the Mario Maker title animation
/// during the first 2 seconds. The image inside scales out after bounce.
class BouncingCircle extends StatefulWidget {
  /// Creates a bouncing circle widget.
  ///
  /// [child] - The widget to display inside the circle (usually an image)
  /// [circleRadius] - The base radius of the circle
  /// [circleColor] - Background color of the circle (default: transparent)
  /// [bounceDuration] - How long the bounce animation lasts (default: 2s)
  /// [imageScaleOutDuration] - How long the image scale-out takes
  ///   (default: 300ms)
  const BouncingCircle({
    required Widget child,
    required double circleRadius,
    Color circleColor = Colors.transparent,
    Duration bounceDuration = MarioMakerTiming.bounceDurationDefault,
    Duration imageScaleOutDuration = MarioMakerTiming.imageScaleOutDuration,
    super.key,
  })  : _child = child,
        _circleRadius = circleRadius,
        _circleColor = circleColor,
        _bounceDuration = bounceDuration,
        _imageScaleOutDuration = imageScaleOutDuration;

  final Widget _child;
  final double _circleRadius;
  final Color _circleColor;
  final Duration _bounceDuration;
  final Duration _imageScaleOutDuration;

  @override
  State<BouncingCircle> createState() => _BouncingCircleState();
}

class _BouncingCircleState extends State<BouncingCircle>
    with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final AnimationController _imageScaleController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _imageScaleAnimation;

  // Static TweenSequence to avoid recreation on each widget initialization.
  // Creates bounce effect:
  // 1. Scale 1.0 → 0.85 (shrink)
  // 2. Scale 0.85 → 1.15 (grow bigger)
  // 3. Scale 1.15 → 0.92 (shrink slightly)
  // 4. Scale 0.92 → 1.05 (grow slightly)
  // 5. Scale 1.05 → 1.0 (settle)
  static final _bounceTweenSequence = TweenSequence<double>([
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
  ]);

  @override
  void initState() {
    super.initState();

    // Controller for circle bounce
    _bounceController = AnimationController(
      vsync: this,
      duration: widget._bounceDuration,
    );

    // Controller for image scale-out
    _imageScaleController = AnimationController(
      vsync: this,
      duration: widget._imageScaleOutDuration,
    );

    // Use static TweenSequence reference
    _scaleAnimation = _bounceTweenSequence.animate(_bounceController);

    // Image scales from 1.0 to 0.0 (disappears)
    _imageScaleAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _imageScaleController,
        curve: Curves.easeInBack,
      ),
    );

    // Start bounce, then scale out image when bounce completes
    unawaited(
      _bounceController.forward().then((_) {
        if (mounted) {
          unawaited(_imageScaleController.forward());
        }
      }),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _imageScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseSize = widget._circleRadius * 2;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _imageScaleAnimation]),
        builder: (context, child) {
          final animatedSize = baseSize * _scaleAnimation.value;

          return SizedBox(
            width: baseSize,
            height: baseSize,
            child: Center(
              child: Container(
                width: animatedSize,
                height: animatedSize,
                decoration: BoxDecoration(
                  color: widget._circleColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: _imageScaleAnimation.value,
                  child: child,
                ),
              ),
            ),
          );
        },
        child: widget._child,
      ),
    );
  }
}
