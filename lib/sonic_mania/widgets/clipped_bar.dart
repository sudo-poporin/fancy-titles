import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/pausable_animation_mixin.dart';
import 'package:fancy_titles/sonic_mania/animations/diagonal_slide_animation.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme_scope.dart';
import 'package:flutter/material.dart';

/// Tipo de barra para resolver colores del tema.
enum _ClippedBarType {
  /// Barra roja.
  red,

  /// Barra naranja.
  orange,

  /// Barra azul.
  blue,

  /// Barra verde.
  green,

  /// Barra con color personalizado.
  custom,
}

/// Barra diagonal animada del splash de Sonic Mania.
///
/// Las barras se deslizan diagonalmente desde fuera de la pantalla
/// hacia el centro, y luego salen en dirección opuesta.
///
/// Los colores pueden ser personalizados usando [SonicManiaTheme].
class ClippedBar extends StatefulWidget {
  /// Barra diagonal con color personalizado.
  const ClippedBar({
    required this.color,
    required this.customClipper,
    this.duration = SonicManiaTiming.clippedBarDefaultDuration,
    this.curve = Curves.easeInOut,
    this.delay = SonicManiaTiming.clippedBarDefaultDelay,
    super.key,
  }) : _barType = _ClippedBarType.custom;

  /// Barra roja.
  ///
  /// El color puede ser personalizado con [SonicManiaTheme.redBarColor].
  const ClippedBar.red({
    required this.customClipper,
    this.color = SonicManiaBarColors.red,
    this.duration = SonicManiaTiming.clippedBarRedDuration,
    this.curve = Curves.easeInOut,
    this.delay = SonicManiaTiming.clippedBarRedDelay,
    super.key,
  }) : _barType = _ClippedBarType.red;

  /// Barra naranja.
  ///
  /// El color puede ser personalizado con [SonicManiaTheme.orangeBarColor].
  const ClippedBar.orange({
    required this.customClipper,
    this.color = SonicManiaBarColors.orange,
    this.duration = SonicManiaTiming.clippedBarOrangeDuration,
    this.curve = Curves.easeInOut,
    this.delay = SonicManiaTiming.clippedBarOrangeDelay,
    super.key,
  }) : _barType = _ClippedBarType.orange;

  /// Barra azul.
  ///
  /// El color puede ser personalizado con [SonicManiaTheme.blueBarColor].
  const ClippedBar.blue({
    required this.customClipper,
    this.color = SonicManiaBarColors.blue,
    this.duration = SonicManiaTiming.clippedBarBlueDuration,
    this.curve = Curves.easeInOut,
    this.delay = SonicManiaTiming.clippedBarBlueDelay,
    super.key,
  }) : _barType = _ClippedBarType.blue;

  /// Barra verde.
  ///
  /// El color puede ser personalizado con [SonicManiaTheme.greenBarColor].
  const ClippedBar.green({
    required this.customClipper,
    this.color = SonicManiaBarColors.green,
    this.duration = SonicManiaTiming.clippedBarGreenDuration,
    this.curve = Curves.easeInOut,
    this.delay = SonicManiaTiming.clippedBarGreenDelay,
    super.key,
  }) : _barType = _ClippedBarType.green;

  /// Tipo interno de barra para resolución de colores del tema.
  final _ClippedBarType _barType;

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
    with SingleTickerProviderStateMixin, PausableAnimationMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late Offset _beginOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    registerAnimationController(_controller);

    _beginOffset = const Offset(0.5, 1);

    delayedPausable(SonicManiaTiming.clippedBarInitialDelay, () {
      unawaited(_controller.forward().whenComplete(_slideOut));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _slideOut() {
    delayedPausable(widget.delay, () {
      setState(() {
        _beginOffset = const Offset(-0.5, -1);
      });
      unawaited(_controller.reverse());
    });
  }

  /// Resuelve el color de la barra basándose en el tema o el color por defecto.
  Color _resolveColor(BuildContext context) {
    final theme = SonicManiaThemeScope.maybeOf(context);
    if (theme == null) return widget.color;

    return switch (widget._barType) {
      _ClippedBarType.red => theme.redBarColor ?? widget.color,
      _ClippedBarType.orange => theme.orangeBarColor ?? widget.color,
      _ClippedBarType.blue => theme.blueBarColor ?? widget.color,
      _ClippedBarType.green => theme.greenBarColor ?? widget.color,
      _ClippedBarType.custom => widget.color,
    };
  }

  @override
  Widget build(BuildContext context) {
    return DiagonalSlideTransition(
      animation: _animation,
      beginOffset: _beginOffset,
      child: ClipPath(
        clipper: widget.customClipper,
        child: ColoredBox(color: _resolveColor(context)),
      ),
    );
  }
}
