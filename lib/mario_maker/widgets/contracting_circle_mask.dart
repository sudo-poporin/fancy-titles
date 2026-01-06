import 'dart:async';
import 'dart:math' as math;

import 'package:fancy_titles/mario_maker/clippers/circle_mask_clipper.dart';
import 'package:flutter/material.dart';

/// A widget that clips its child with a contracting circle (iris-out effect).
///
/// The circle starts large (covering the entire screen) and contracts
/// to the specified alignment point, progressively hiding the child content
/// and revealing whatever is beneath the widget.
class ContractingCircleMask extends StatefulWidget {
  /// Creates a contracting circle mask widget.
  ///
  /// [child] - The content to clip with the contracting circle
  /// [alignment] - Where the circle contracts to (default: center)
  /// [edgePadding] - Minimum distance from screen edges (default: 50)
  /// [delay] - Time to wait before starting the contraction
  /// [duration] - How long the contraction animation takes
  /// [curve] - Animation curve for the contraction
  const ContractingCircleMask({
    required Widget child,
    Alignment alignment = Alignment.center,
    double edgePadding = 50,
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInCubic,
    super.key,
  })  : _child = child,
        _alignment = alignment,
        _edgePadding = edgePadding,
        _delay = delay,
        _duration = duration,
        _curve = curve;

  final Widget _child;
  final Alignment _alignment;
  final double _edgePadding;
  final Duration _delay;
  final Duration _duration;
  final Curve _curve;

  @override
  State<ContractingCircleMask> createState() => _ContractingCircleMaskState();
}

class _ContractingCircleMaskState extends State<ContractingCircleMask>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isAnimating = false;
  double _maxRadius = double.infinity;
  Offset _center = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget._duration,
    );

    _startAnimationAfterDelay();
  }

  void _startAnimationAfterDelay() {
    if (widget._delay == Duration.zero) {
      _startAnimation();
    } else {
      unawaited(
        Future<void>.delayed(widget._delay, () {
          if (mounted) {
            _startAnimation();
          }
        }),
      );
    }
  }

  void _startAnimation() {
    _isAnimating = true;
    unawaited(_controller.forward());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCenterAndRadius();
  }

  void _updateCenterAndRadius() {
    final screenSize = MediaQuery.sizeOf(context);
    final padding = widget._edgePadding;

    // Calculate the usable area (screen minus padding on all sides)
    final usableWidth = screenSize.width - (padding * 2);
    final usableHeight = screenSize.height - (padding * 2);

    // Convert alignment (-1 to 1) to screen coordinates with padding
    final rawX = (widget._alignment.x + 1) / 2 * usableWidth + padding;
    final rawY = (widget._alignment.y + 1) / 2 * usableHeight + padding;

    // Clamp to ensure we stay within padded bounds
    _center = Offset(
      math.max(padding, math.min(screenSize.width - padding, rawX)),
      math.max(padding, math.min(screenSize.height - padding, rawY)),
    );

    _maxRadius = _calculateMaxRadius(screenSize, _center);
  }

  double _calculateMaxRadius(Size screenSize, Offset center) {
    final corners = [
      Offset.zero,
      Offset(screenSize.width, 0),
      Offset(0, screenSize.height),
      Offset(screenSize.width, screenSize.height),
    ];

    var maxDistance = 0.0;
    for (final corner in corners) {
      final distance = (corner - center).distance;
      if (distance > maxDistance) {
        maxDistance = distance;
      }
    }

    return maxDistance + 50;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getCurrentRadius() {
    if (!_isAnimating) {
      return _maxRadius;
    }
    final curved = widget._curve.transform(_controller.value);
    return _maxRadius * (1 - curved);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final radius = _getCurrentRadius();

        return IgnorePointer(
          ignoring: _isAnimating,
          child: ClipPath(
            clipper: CircleMaskClipper(
              radius: radius,
              center: _center,
            ),
            child: child,
          ),
        );
      },
      child: widget._child,
    );
  }
}
