import 'package:fancy_titles/core/fancy_title_controller.dart';
import 'package:flutter/widgets.dart';

/// InheritedNotifier que propaga el estado del [FancyTitleController]
/// a los widgets descendientes.
///
/// Este widget permite que los widgets internos de las animaciones
/// escuchen cambios en el estado del controller (pause/resume)
/// sin necesidad de modificar sus firmas.
///
/// ## Uso interno
///
/// Este widget es usado internamente por los widgets de título
/// como `SonicManiaSplash`, `Persona5Title`, etc. Los usuarios
/// no necesitan interactuar con él directamente.
///
/// ## Cómo funciona
///
/// Cuando el controller notifica un cambio (por ejemplo, pause()),
/// todos los widgets que dependen de este scope se reconstruirán
/// y podrán reaccionar al nuevo estado.
///
/// ```dart
/// // En un widget interno
/// final controller = FancyTitleControllerScope.maybeOf(context);
/// if (controller?.isPaused ?? false) {
///   _animationController.stop();
/// }
/// ```
class FancyTitleControllerScope
    extends InheritedNotifier<FancyTitleController> {
  /// Crea un scope que propaga el controller a los widgets descendientes.
  const FancyTitleControllerScope({
    required FancyTitleController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  /// Obtiene el controller del scope más cercano, si existe.
  ///
  /// Retorna null si no hay un [FancyTitleControllerScope] ancestro.
  ///
  /// Este método registra una dependencia, por lo que el widget
  /// se reconstruirá cuando el controller notifique cambios.
  static FancyTitleController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FancyTitleControllerScope>()
        ?.notifier;
  }

  /// Obtiene el controller del scope más cercano.
  ///
  /// Lanza una excepción si no hay un [FancyTitleControllerScope] ancestro.
  ///
  /// Este método registra una dependencia, por lo que el widget
  /// se reconstruirá cuando el controller notifique cambios.
  static FancyTitleController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(
      controller != null,
      'No FancyTitleControllerScope found in context. '
      'Make sure the widget is a descendant of a FancyTitleControllerScope.',
    );
    return controller!;
  }
}
