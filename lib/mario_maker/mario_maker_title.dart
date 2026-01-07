import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/mario_maker/consts/consts.dart';
import 'package:fancy_titles/mario_maker/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Mario Maker style title screen.
///
/// Displays a bouncing circle with an image that expands to reveal
/// a yellow background, then shows a title sliding from the top.
///
/// Timeline (4 seconds total):
/// - 0s-1.2s: Circle bounces (jelly effect)
/// - 1.2s-1.5s: Image scales out
/// - 1.2s-2s: Circle expands to reveal yellow background
/// - 1.4s-1.9s: Title slides in from top
/// - 3.5s-4s: Title fades out + Iris-out effect (simultaneous)
/// - 4s: Widget auto-destructs
class MarioMakerTitle extends StatefulWidget {
  /// Creates a Mario Maker style title animation.
  ///
  /// [title] - The text to display after the circle expands
  /// [imagePath] - Asset path for the image inside the circle (supports GIFs)
  /// [onAnimationStart] - Optional callback executed when animation starts
  ///   (useful for playing sounds)
  /// [duration] - Total animation duration (default: 6 seconds)
  /// [circleRadius] - Base radius of the circle (default: 80)
  /// [bottomMargin] - Distance from bottom of screen to circle center
  ///   (default: 100)
  /// [titleStyle] - Optional custom style for the title text
  /// [irisOutAlignment] - Where the iris-out effect contracts to
  ///   (default: center). Use Alignment constants like Alignment.bottomRight,
  ///   Alignment.topLeft, etc.
  /// [irisOutEdgePadding] - Minimum distance from screen edges for iris-out
  ///   (default: 50)
  const MarioMakerTitle({
    required String title,
    required String imagePath,
    VoidCallback? onAnimationStart,
    Duration duration = MarioMakerTiming.defaultTotalDuration,
    double circleRadius = 80,
    double bottomMargin = 100,
    TextStyle? titleStyle,
    Alignment irisOutAlignment = Alignment.center,
    double irisOutEdgePadding = 50,
    super.key,
  })  : _title = title,
        _imagePath = imagePath,
        _onAnimationStart = onAnimationStart,
        _duration = duration,
        _circleRadius = circleRadius,
        _bottomMargin = bottomMargin,
        _titleStyle = titleStyle,
        _irisOutAlignment = irisOutAlignment,
        _irisOutEdgePadding = irisOutEdgePadding;

  final String _title;
  final String _imagePath;
  final VoidCallback? _onAnimationStart;
  final Duration _duration;
  final double _circleRadius;
  final double _bottomMargin;
  final TextStyle? _titleStyle;
  final Alignment _irisOutAlignment;
  final double _irisOutEdgePadding;

  @override
  State<MarioMakerTitle> createState() => _MarioMakerTitleState();
}

class _MarioMakerTitleState extends State<MarioMakerTitle>
    with SingleTickerProviderStateMixin {
  bool _animationCompleted = false;
  bool _imagePrecached = false;

  static const Duration _irisOutDuration = MarioMakerTiming.irisOutDuration;
  static const Duration _titleEntryDelay = MarioMakerTiming.titleEntryDelay;
  static const Duration _bounceDuration = MarioMakerTiming.bounceDuration;
  static const Duration _expandDelay = MarioMakerTiming.expandDelay;
  static const Duration _expandDuration = MarioMakerTiming.expandDuration;

  @override
  void initState() {
    super.initState();
    _executeCallback();
    _initAutoDestruction();
  }

  void _executeCallback() {
    try {
      widget._onAnimationStart?.call();
    } on Exception catch (_) {
      // Silently handle callback errors to prevent crashes
    }
  }

  void _initAutoDestruction() {
    // Auto-destruct at end of duration
    unawaited(
      Future<void>.delayed(widget._duration, () {
        if (mounted) {
          setState(() => _animationCompleted = true);
        }
      }),
    );
  }

  /// Calculates when the iris-out effect should start
  Duration get _irisOutDelay => widget._duration - _irisOutDuration;

  /// Calculates when the title should start its exit animation
  /// Title exits at the same time as the iris-out effect
  Duration get _titleExitDelay => _irisOutDelay;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImageIfNeeded();
  }

  void _precacheImageIfNeeded() {
    if (!_imagePrecached) {
      _imagePrecached = true;
      unawaited(
        precacheImage(AssetImage(widget._imagePath), context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    if (_animationCompleted) {
      return const SizedBox.shrink();
    }

    return ContractingCircleMask(
      delay: _irisOutDelay,
      alignment: widget._irisOutAlignment,
      edgePadding: widget._irisOutEdgePadding,
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Black background (initial state)
            const SizedBox.expand(
              child: ColoredBox(color: marioMakerBlack),
            ),

            // Expanding circle mask that reveals yellow background
            ExpandingCircleMask(
              initialRadius: widget._circleRadius,
              bottomMargin: widget._bottomMargin,
              delay: _expandDelay,
              expandDuration: _expandDuration,
              background: const SizedBox.expand(
                child: ColoredBox(color: marioMakerYellow),
              ),
            ),

            // Bouncing circle with image (positioned at bottom center)
            Positioned(
              bottom: widget._bottomMargin - widget._circleRadius,
              left: (screenSize.width / 2) - widget._circleRadius,
              child: BouncingCircle(
                circleRadius: widget._circleRadius,
                bounceDuration: _bounceDuration,
                child: MarioMakerImage(
                  imagePath: widget._imagePath,
                  size: widget._circleRadius * 1.5,
                ),
              ),
            ),

            // Title layer - stays visible and exits with reverse animation
            SlidingTitle(
              text: widget._title,
              textStyle: widget._titleStyle,
              delay: _titleEntryDelay,
              exitDelay: _titleExitDelay,
            ),
          ],
        ),
      ),
    );
  }
}
