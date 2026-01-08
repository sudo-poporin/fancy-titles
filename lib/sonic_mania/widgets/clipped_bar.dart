import 'dart:async';

import 'package:fancy_titles/core/cancelable_timers.dart';
import 'package:fancy_titles/sonic_mania/animations/diagonal_slide_animation.dart';
import 'package:flutter/material.dart';

const Color _redBarColor = Color(0xFFD15529);
const Color _orangeBarColor = Color(0xFFFB9B0F);
const Color _blueBarColor = Color(0xFF456EBD);
const Color _greenBarColor = Color(0xFF4E9B89);

/// Barra azul del splash de Sonic Mania
class ClippedBar extends StatefulWidget {
  /// Barra azul del splash de Sonic Mania
  const ClippedBar({
    required this.color,
    required this.customClipper,
    this.duration = const Duration(milliseconds: 325),
    this.curve = Curves.easeInOut,
    this.delay = const Duration(milliseconds: 2400),
    super.key,
  });

  /// Barra roja
  const ClippedBar.red({
    required this.customClipper,
    this.color = _redBarColor,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeInOut,
    this.delay = const Duration(milliseconds: 2200),
    super.key,
  });

  /// Barra naranja
  const ClippedBar.orange({
    required this.customClipper,
    this.color = _orangeBarColor,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeInOut,
    this.delay = const Duration(milliseconds: 2000),
    super.key,
  });

  /// Barra azul
  const ClippedBar.blue({
    required this.customClipper,
    this.color = _blueBarColor,
    this.duration = const Duration(milliseconds: 375),
    this.curve = Curves.easeInOut,
    this.delay = const Duration(milliseconds: 2400),
    super.key,
  });

  /// Barra verde
  const ClippedBar.green({
    required this.customClipper,
    this.color = _greenBarColor,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.delay = const Duration(milliseconds: 2200),
    super.key,
  });

  /// Barra clippeada personalizada
  final CustomClipper<Path> customClipper;

  /// Duración de la animación
  final Duration duration;

  /// Curva de la animación
  final Curve curve;

  /// Retardo de la animación
  final Duration delay;

  /// Color de la barra
  final Color color;

  @override
  State<ClippedBar> createState() => _ClippedBarState();
}

class _ClippedBarState extends State<ClippedBar>
    with SingleTickerProviderStateMixin, CancelableTimersMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late Offset _beginOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    _beginOffset = const Offset(0.5, 1);

    delayed(const Duration(milliseconds: 725), () {
      unawaited(_controller.forward().whenComplete(_slideOut));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _slideOut() {
    delayed(widget.delay, () {
      setState(() {
        _beginOffset = const Offset(-0.5, -1);
      });
      unawaited(_controller.reverse());
    });
  }

  @override
  Widget build(BuildContext context) {
    return DiagonalSlideTransition(
      animation: _animation,
      beginOffset: _beginOffset,
      child: ClipPath(
        clipper: widget.customClipper,
        child: ColoredBox(color: widget.color),
      ),
    );
  }
}
