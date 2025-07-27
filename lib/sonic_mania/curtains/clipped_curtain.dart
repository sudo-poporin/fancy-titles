import 'package:fancy_titles/sonic_mania/animations/diagonal_slide_animation.dart';
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late Offset _beginOffset;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 325),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);

    _beginOffset = widget.beginOffset;

    Future<void>.delayed(
      const Duration(milliseconds: 500),
      () => _controller.forward().whenComplete(_slideOut),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _slideOut() {
    Future<void>.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        _beginOffset = widget.endOffset;
      });
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DiagonalSlideTransition(
      animation: _animation,
      beginOffset: _beginOffset,
      child: ClipPath(
        clipper: widget.customClipper,
        child: const ColoredBox(color: Color(0xFFF7C700)),
      ),
    );
  }
}
