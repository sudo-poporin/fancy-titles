import 'package:fancy_titles/core/fancy_title_controller.dart';

/// Controller para `MarioMakerTitle` que permite control programático
/// de la animación.
///
/// ## Ejemplo de uso
///
/// ```dart
/// final controller = MarioMakerTitleController();
///
/// // En el widget
/// MarioMakerTitle(
///   title: 'WORLD 1-1',
///   imagePath: 'assets/mario.gif',
///   controller: controller,
/// )
///
/// // Pausar la animación
/// controller.pause();
///
/// // Reanudar la animación
/// controller.resume();
///
/// // Saltar al final
/// controller.skipToEnd();
///
/// // Reiniciar desde el principio
/// controller.reset();
/// ```
///
/// ## Estados del controller
///
/// - [isPaused]: true si la animación está pausada
/// - [currentPhase]: la fase actual de la animación
/// - [isCompleted]: true si la animación ha terminado
///
/// ## Ciclo de vida
///
/// El controller debe ser disposed cuando ya no se necesite:
///
/// ```dart
/// @override
/// void dispose() {
///   controller.dispose();
///   super.dispose();
/// }
/// ```
///
/// ## Escuchar cambios
///
/// El controller extiende `ChangeNotifier`, por lo que puedes
/// escuchar cambios de estado:
///
/// ```dart
/// controller.addListener(() {
///   print('Estado: isPaused=${controller.isPaused}');
///   print('Fase: ${controller.currentPhase}');
/// });
/// ```
class MarioMakerTitleController extends FancyTitleController {
  /// Crea un controller para `MarioMakerTitle`.
  MarioMakerTitleController();
}
