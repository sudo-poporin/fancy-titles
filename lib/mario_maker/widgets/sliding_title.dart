import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:flutter/material.dart';

/// A title that slides in from the top and fades out with scale effect.
///
/// Used in the Mario Maker title animation to show the title text
/// after the circle has expanded.
class SlidingTitle extends StatefulWidget {
  /// Creates a sliding title widget.
  ///
  /// [text] - The title text to display
  /// [delay] - Time to wait before sliding in (default: 3.5s)
  /// [slideDuration] - How long the slide animation takes (default: 500ms)
  /// [exitDelay] - Time to wait before fading out (from animation start)
  /// [textStyle] - Optional custom text style
  const SlidingTitle({
    required String text,
    Duration delay = MarioMakerTiming.slideDelayDefault,
    Duration slideDuration = MarioMakerTiming.slideDuration,
    Duration? exitDelay,
    TextStyle? textStyle,
    super.key,
  }) : _text = text,
       _delay = delay,
       _slideDuration = slideDuration,
       _exitDelay = exitDelay,
       _textStyle = textStyle;

  final String _text;
  final Duration _delay;
  final Duration _slideDuration;
  final Duration? _exitDelay;
  final TextStyle? _textStyle;

  @override
  State<SlidingTitle> createState() => _SlidingTitleState();
}

class _SlidingTitleState extends State<SlidingTitle>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _exitController;
  late final Animation<Offset> _entrySlideAnimation;
  late final Animation<double> _exitFadeAnimation;
  late final Animation<double> _exitScaleAnimation;
  bool _shouldShow = false;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: widget._slideDuration,
    );

    _exitController = AnimationController(
      vsync: this,
      duration: widget._slideDuration,
    );

    // Slide in from top (y = -1) to center (y = 0)
    _entrySlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _entryController,
            curve: Curves.easeOutBack,
          ),
        );

    // Fade out from 1.0 to 0.0 during exit
    _exitFadeAnimation =
        Tween<double>(
          begin: 1,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: _exitController,
            curve: Curves.easeIn,
          ),
        );

    // Scale down during exit
    _exitScaleAnimation =
        Tween<double>(
          begin: 1,
          end: 0.2,
        ).animate(
          CurvedAnimation(
            parent: _exitController,
            curve: Curves.easeIn,
          ),
        );

    _startDelayedSlide();
  }

  void _startDelayedSlide() {
    unawaited(
      Future<void>.delayed(widget._delay, () {
        if (mounted) {
          setState(() => _shouldShow = true);
          unawaited(_entryController.forward());
        }
      }),
    );

    // Schedule exit animation if exitDelay is provided
    if (widget._exitDelay != null) {
      unawaited(
        Future<void>.delayed(widget._exitDelay!, () {
          if (mounted) {
            setState(() => _isExiting = true);
            unawaited(_exitController.forward());
          }
        }),
      );
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final defaultTextStyle = TextStyle(
      fontFamily: 'BouCollege',
      package: 'fancy_titles',
      fontSize: screenWidth * 0.1,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      decoration: TextDecoration.none,
    );

    final textWidget = Text(
      widget._text,
      textAlign: TextAlign.center,
      style: widget._textStyle ?? defaultTextStyle,
    );

    if (_isExiting) {
      return Center(
        child: RepaintBoundary(
          child: FadeTransition(
            opacity: _exitFadeAnimation,
            child: ScaleTransition(
              scale: _exitScaleAnimation,
              child: textWidget,
            ),
          ),
        ),
      );
    }

    return Center(
      child: RepaintBoundary(
        child: SlideTransition(
          position: _entrySlideAnimation,
          child: textWidget,
        ),
      ),
    );
  }
}
