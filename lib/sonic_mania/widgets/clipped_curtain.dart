import 'dart:async';

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/pausable_animation_mixin.dart';
import 'package:fancy_titles/sonic_mania/animations/diagonal_slide_animation.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme.dart';
import 'package:fancy_titles/sonic_mania/sonic_mania_theme_scope.dart';
import 'package:flutter/material.dart';

/// Cortina clippeada
class ClippedCurtain extends StatefulWidget {
  /// Muestra una cortina clippeada con una animación de deslizamiento
  /// personalizada.
  ///
  /// [customClipper] es el clipper personalizado.
  /// [endOffset] es el offset final de la animación.
  const ClippedCurtain({
    required this.customClipper,
    required this.beginOffset,
    required this.endOffset,
    super.key,
  });

  /// Barra clippeada personalizada a la izquierda
  const ClippedCurtain.left({
    required this.customClipper,
    this.beginOffset = const Offset(-1, 0),
    this.endOffset = const Offset(-1, 0),
    super.key,
  });

  /// Barra clippeada personalizada a la derecha
  const ClippedCurtain.right({
    required this.customClipper,
    this.beginOffset = const Offset(1, 0),
    this.endOffset = const Offset(1, 0),
    super.key,
  });

  /// Barra clippeada personalizada
  final CustomClipper<Path> customClipper;

  /// Offset inicial de la animación
  final Offset beginOffset;

  /// Offset final de la animación
  final Offset endOffset;

  @override
  State<ClippedCurtain> createState() => _ClippedCurtainState();
}

class _ClippedCurtainState extends State<ClippedCurtain>
    with SingleTickerProviderStateMixin, PausableAnimationMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late Offset _beginOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: SonicManiaTiming.clippedCurtainDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);
    registerAnimationController(_controller);

    _beginOffset = widget.beginOffset;

    delayedPausable(SonicManiaTiming.clippedCurtainInitialDelay, () {
      unawaited(_controller.forward().whenComplete(_slideOut));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _slideOut() {
    delayedPausable(SonicManiaTiming.clippedCurtainSlideOutDelay, () {
      setState(() {
        _beginOffset = widget.endOffset;
      });
      unawaited(_controller.reverse());
    });
  }

  /// Resuelve el color de la cortina clippeada basándose en el tema
  /// o el color por defecto.
  Color _resolveColor(BuildContext context) {
    final theme = SonicManiaThemeScope.maybeOf(context);
    return theme?.clippedCurtainColor ?? SonicManiaCurtainColors.yellow;
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
