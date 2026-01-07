import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/persona_5/consts/const.dart';
import 'package:fancy_titles/persona_5/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Persona 5 title screen
class Persona5Title extends StatefulWidget {
  /// Shows a title screen with a red background and a black spiral
  const Persona5Title({
    required String text,
    String? imagePath,
    bool withImageBlendMode = false,
    Duration delay = Persona5Timing.initialDelay,
    Duration duration = Persona5Timing.mainDuration,
    super.key,
  }) : _text = text,
       _imagePath = imagePath,
       _delay = delay,
       _duration = duration,
       _withImageBlendMode = withImageBlendMode;

  final Duration _delay;
  final Duration _duration;
  final String _text;
  final String? _imagePath;
  final bool _withImageBlendMode;

  @override
  State<Persona5Title> createState() => _Persona5TitleState();
}

class _Persona5TitleState extends State<Persona5Title>
    with SingleTickerProviderStateMixin {
  late bool _animationCompleted = false;
  bool _showBackground = true;
  bool _showText = false;
  bool _imagePrecached = false;

  @override
  void initState() {
    _showBackground = true;
    _showText = false;

    unawaited(
      Future<void>.delayed(
        widget._delay,
        () => setState(() => _showBackground = false),
      ).then(
        (_) => Future<void>.delayed(
          widget._duration,
          () => setState(() => _showBackground = true),
        ),
      ),
    );

    unawaited(
      Future<void>.delayed(
        Persona5Timing.textAppearDelay,
        () => setState(() => _showText = true),
      ).then(
        (_) => Future<void>.delayed(
          widget._duration,
          () => setState(() => _showText = false),
        ),
      ),
    );

    _initWidgetAutoDestructionSecuence();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImageIfNeeded();
  }

  void _precacheImageIfNeeded() {
    if (!_imagePrecached && widget._imagePath != null) {
      _imagePrecached = true;
      unawaited(
        precacheImage(AssetImage(widget._imagePath!), context),
      );
    }
  }

  /// Inicializa la secuencia de autodestrucción del widget
  void _initWidgetAutoDestructionSecuence() {
    Future.delayed(Persona5Timing.totalDuration, () {
      setState(() {
        _animationCompleted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final height = MediaQuery.sizeOf(context).height;
    final padding = orientation == Orientation.portrait
        ? height * 0.3
        : height * 0.5;

    final canShowText = height > 600;

    return AnimatedSwitcher(
      duration: Duration.zero,
      reverseDuration: Persona5Timing.fadeTransitionReverse,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _animationCompleted
          ? const SizedBox.shrink()
          : Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox.expand(child: ColoredBox(color: redColor)),
                AnimatedSwitcher(
                  reverseDuration: Persona5Timing.circleTransitionDuration,
                  duration: Persona5Timing.circleTransitionDuration,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _showBackground
                      ? const SizedBox.shrink()
                      : const BackgroundCircle(),
                ),
                AnimatedSwitcher(
                  duration: Persona5Timing.fadeTransitionReverse,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, -0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _showText
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  top: 0,
                                  child: Persona5Image(
                                    imagePath: widget._imagePath,
                                    withImageBlendMode:
                                        widget._withImageBlendMode,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: padding,
                                    right: 20,
                                    left: 20,
                                  ),
                                  child: canShowText
                                      ? Persona5Text(text: widget._text)
                                      : const SizedBox(width: 250),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
    );
  }
}
