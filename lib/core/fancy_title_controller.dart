import 'package:fancy_titles/core/animation_phase.dart';
import 'package:flutter/foundation.dart';

/// Controller base para widgets de título que permite control programático
/// de las animaciones.
///
/// Los controllers permiten pausar, reanudar, saltar al final y reiniciar
/// las animaciones de los widgets de título desde código externo.
///
/// ## Ejemplo de uso
///
/// ```dart
/// final controller = SonicManiaSplashController();
///
/// // En el widget
/// SonicManiaSplash(
///   baseText: 'TEST',
///   controller: controller,
/// )
///
/// // Controlar la animación
/// controller.pause();
/// controller.resume();
/// controller.skipToEnd();
/// controller.reset();
/// ```
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
/// Ver también:
/// - `SonicManiaSplashController` para control de `SonicManiaSplash`
/// - `Persona5TitleController` para control de `Persona5Title`
/// - `EvangelionTitleController` para control de `EvangelionTitle`
/// - `MarioMakerTitleController` para control de `MarioMakerTitle`
abstract class FancyTitleController extends ChangeNotifier {
  AnimationPhase _currentPhase = AnimationPhase.idle;
  bool _isPaused = false;
  bool _isDisposed = false;

  /// La fase actual de la animación.
  AnimationPhase get currentPhase => _currentPhase;

  /// Si la animación está actualmente pausada.
  bool get isPaused => _isPaused;

  /// Si el controller ha sido disposed.
  bool get isDisposed => _isDisposed;

  /// Si la animación ha completado su ciclo.
  bool get isCompleted => _currentPhase == AnimationPhase.completed;

  /// Pausa la animación en el frame actual.
  ///
  /// Mientras está pausada, ningún timer avanzará y los
  /// AnimationControllers internos se detendrán.
  ///
  /// No hace nada si ya está pausada o si el controller fue disposed.
  ///
  /// Llama a [resume] para continuar la animación.
  void pause() {
    if (_isPaused || _isDisposed) return;
    _isPaused = true;
    notifyListeners();
  }

  /// Reanuda la animación desde donde fue pausada.
  ///
  /// No hace nada si no está pausada o si el controller fue disposed.
  void resume() {
    if (!_isPaused || _isDisposed) return;
    _isPaused = false;
    notifyListeners();
  }

  /// Salta directamente al final de la animación.
  ///
  /// La fase cambiará a [AnimationPhase.completed] y se disparará
  /// el callback `onAnimationComplete`.
  ///
  /// No hace nada si el controller fue disposed.
  void skipToEnd() {
    if (_isDisposed) return;
    _isPaused = false;
    _currentPhase = AnimationPhase.completed;
    notifyListeners();
  }

  /// Reinicia la animación desde el principio.
  ///
  /// La fase volverá a [AnimationPhase.idle] y la animación
  /// comenzará de nuevo desde el inicio.
  ///
  /// No hace nada si el controller fue disposed.
  void reset() {
    if (_isDisposed) return;
    _isPaused = false;
    _currentPhase = AnimationPhase.idle;
    notifyListeners();
  }

  /// Actualiza la fase actual.
  ///
  /// **Nota:** Este método es principalmente para uso interno por los
  /// widgets de título. No debería ser llamado directamente por el
  /// código de la aplicación. El widget llama a este método para mantener
  /// sincronizada la fase del controller con la animación actual.
  ///
  /// Si deseas cambiar la fase programáticamente, usa [skipToEnd] o [reset].
  void updatePhase(AnimationPhase phase) {
    if (_isDisposed) return;
    _currentPhase = phase;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
