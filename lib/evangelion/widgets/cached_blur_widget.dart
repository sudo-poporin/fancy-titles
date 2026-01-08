import 'dart:async';
import 'dart:ui' as ui;

import 'package:fancy_titles/core/animation_timings.dart';
import 'package:fancy_titles/core/cancelable_timers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Widget que pre-renderiza cualquier widget hijo con blur a una imagen.
///
/// Usa RepaintBoundary.toImage() para capturar el widget renderizado
/// y lo cachea para evitar recalcular el blur en cada frame.
class CachedBlurWidget extends StatefulWidget {
  /// Crea un [CachedBlurWidget] con el hijo y blur especificados.
  const CachedBlurWidget({
    required this.child,
    required this.size,
    this.sigmaX = 10,
    this.sigmaY = 10,
    super.key,
  });

  /// El widget hijo a renderizar con blur.
  final Widget child;

  /// Tamaño del área a renderizar.
  final Size size;

  /// Sigma X para el blur.
  final double sigmaX;

  /// Sigma Y para el blur.
  final double sigmaY;

  @override
  State<CachedBlurWidget> createState() => _CachedBlurWidgetState();
}

class _CachedBlurWidgetState extends State<CachedBlurWidget>
    with CancelableTimersMixin {
  final GlobalKey _boundaryKey = GlobalKey();
  ui.Image? _cachedImage;
  bool _isCapturing = false;
  bool _hasTriedCapture = false;

  @override
  void initState() {
    super.initState();
    // Capturar después de que el widget se renderice
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleCapture();
    });
  }

  @override
  void didUpdateWidget(CachedBlurWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size ||
        oldWidget.sigmaX != widget.sigmaX ||
        oldWidget.sigmaY != widget.sigmaY) {
      _disposeImage();
      _hasTriedCapture = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scheduleCapture();
      });
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

  /// Schedules the capture after a frame delay using cancelable timer
  void _scheduleCapture() {
    if (_isCapturing) return;
    if (_hasTriedCapture) return;
    _hasTriedCapture = true;

    // Use cancelable timer to wait for next frame
    delayed(EvangelionTiming.blurCacheDelay, () {
      unawaited(_captureToImage());
    });
  }

  Future<void> _captureToImage() async {
    if (_isCapturing || !mounted) return;
    _isCapturing = true;

    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null || !boundary.hasSize) {
        _isCapturing = false;
        return;
      }

      // Capturar el widget renderizado como imagen
      final image = await boundary.toImage();

      if (mounted) {
        setState(() {
          _cachedImage = image;
        });
      } else {
        image.dispose();
      }
    } on Exception {
      // Silenciar errores de captura - usar fallback
    } finally {
      _isCapturing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si tenemos imagen cacheada, mostrarla directamente
    if (_cachedImage != null) {
      return SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: RawImage(
          image: _cachedImage,
          fit: BoxFit.fill,
        ),
      );
    }

    // Renderizar el widget con blur y capturarlo
    return RepaintBoundary(
      key: _boundaryKey,
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: widget.sigmaX,
          sigmaY: widget.sigmaY,
        ),
        child: SizedBox(
          width: widget.size.width,
          height: widget.size.height,
          child: widget.child,
        ),
      ),
    );
  }
}
