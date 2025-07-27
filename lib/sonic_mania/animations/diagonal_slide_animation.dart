import 'package:flutter/material.dart';

/// Diagonal slide transition
class DiagonalSlideTransition extends StatelessWidget {
  /// Diagonal slide transition
  const DiagonalSlideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset? beginOffset =
        const Offset(1, 1), // Empieza en la esquina inferior derecha
    Offset? endOffset = Offset.zero, // Termina en la esquina superior izquierda
    super.key,
  })  : _endOffset = endOffset,
        _beginOffset = beginOffset,
        _animation = animation,
        _child = child;

  final Widget _child;
  final Animation<double> _animation;
  final Offset? _beginOffset;
  final Offset? _endOffset;

  @override
  Widget build(BuildContext context) {
    final offsetTween = Tween<Offset>(
      begin: _beginOffset,
      end: _endOffset,
    );

    return SlideTransition(
      position: _animation.drive(offsetTween),
      child: _child,
    );
  }
}

/// Animación de deslizamiento horizontal
class HorizontalSlideTransition extends StatelessWidget {
  /// Animación de deslizamiento horizontal que se puede personalizar
  /// con un offset de inicio y un offset de fin.
  const HorizontalSlideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset? beginOffset =
        const Offset(-2, 0), // Empieza en la esquina inferior derecha
    Offset? endOffset = Offset.zero, // Termina en la esquina superior izquierda
    super.key,
  })  : _endOffset = endOffset,
        _beginOffset = beginOffset,
        _animation = animation,
        _child = child;

  final Widget _child;
  final Animation<double> _animation;
  final Offset? _beginOffset;
  final Offset? _endOffset;

  @override
  Widget build(BuildContext context) {
    final offsetTween = Tween<Offset>(
      begin: _beginOffset,
      end: _endOffset,
    );

    return SlideTransition(
      position: _animation.drive(offsetTween),
      child: _child,
    );
  }
}
