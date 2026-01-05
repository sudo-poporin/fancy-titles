import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Widget que pre-renderiza un CustomPainter con blur a una imagen.
///
/// Esto evita recalcular el blur costoso en cada frame,
/// renderizando el efecto una sola vez y mostrando la imagen cacheada.
class CachedBlurPainter extends StatefulWidget {
  /// Crea un [CachedBlurPainter] con el painter y blur especificados.
  const CachedBlurPainter({
    required this.painter,
    required this.size,
    this.sigmaX = 10,
    this.sigmaY = 10,
    super.key,
  });

  /// El CustomPainter a renderizar.
  final CustomPainter painter;

  /// Tamaño del área a renderizar.
  final Size size;

  /// Sigma X para el blur.
  final double sigmaX;

  /// Sigma Y para el blur.
  final double sigmaY;

  @override
  State<CachedBlurPainter> createState() => _CachedBlurPainterState();
}

class _CachedBlurPainterState extends State<CachedBlurPainter> {
  ui.Image? _cachedImage;
  bool _isRendering = false;

  @override
  void initState() {
    super.initState();
    // Renderizar en el siguiente frame para asegurar que el widget está montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_renderToImage());
    });
  }

  @override
  void didUpdateWidget(CachedBlurPainter oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-renderizar si cambia el tamaño
    if (oldWidget.size != widget.size ||
        oldWidget.sigmaX != widget.sigmaX ||
        oldWidget.sigmaY != widget.sigmaY) {
      _disposeImage();
      unawaited(_renderToImage());
    }
  }

  @override
  void dispose() {
    _disposeImage();
    super.dispose();
  }

  void _disposeImage() {
    _cachedImage?.dispose();
    _cachedImage = null;
  }

  Future<void> _renderToImage() async {
    if (_isRendering || !mounted) return;
    _isRendering = true;

    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final rect = Rect.fromLTWH(0, 0, widget.size.width, widget.size.height);

      // Aplicar blur al canvas
      canvas.saveLayer(
        rect,
        Paint()
          ..imageFilter = ui.ImageFilter.blur(
            sigmaX: widget.sigmaX,
            sigmaY: widget.sigmaY,
          ),
      );

      // Pintar el contenido del CustomPainter
      widget.painter.paint(canvas, widget.size);

      canvas.restore();

      final picture = recorder.endRecording();
      final image = await picture.toImage(
        widget.size.width.toInt(),
        widget.size.height.toInt(),
      );

      if (mounted) {
        setState(() {
          _cachedImage = image;
        });
      } else {
        image.dispose();
      }
    } finally {
      _isRendering = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cachedImage != null) {
      // Mostrar imagen cacheada (sin recalcular blur)
      return RawImage(
        image: _cachedImage,
        width: widget.size.width,
        height: widget.size.height,
        fit: BoxFit.fill,
      );
    }

    // Fallback: mostrar el painter original con blur mientras se cachea
    // Esto solo ocurre en el primer frame
    return RepaintBoundary(
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: widget.sigmaX,
          sigmaY: widget.sigmaY,
        ),
        child: CustomPaint(
          painter: widget.painter,
          size: widget.size,
        ),
      ),
    );
  }
}
