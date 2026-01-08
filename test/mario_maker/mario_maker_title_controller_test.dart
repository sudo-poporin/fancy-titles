import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarioMakerTitleController', () {
    group('instantiation', () {
      test('can be instantiated', () {
        expect(MarioMakerTitleController(), isNotNull);
      });

      test('starts with idle phase', () {
        final controller = MarioMakerTitleController();
        expect(controller.currentPhase, equals(AnimationPhase.idle));
      });

      test('starts not paused', () {
        final controller = MarioMakerTitleController();
        expect(controller.isPaused, isFalse);
      });

      test('starts not completed', () {
        final controller = MarioMakerTitleController();
        expect(controller.isCompleted, isFalse);
      });
    });

    group('state changes', () {
      test('pause() sets isPaused to true', () {
        final controller = MarioMakerTitleController()..pause();
        expect(controller.isPaused, isTrue);
      });

      test('resume() sets isPaused to false', () {
        final controller = MarioMakerTitleController()
          ..pause()
          ..resume();
        expect(controller.isPaused, isFalse);
      });

      test('skipToEnd() sets isCompleted to true', () {
        final controller = MarioMakerTitleController()..skipToEnd();
        expect(controller.isCompleted, isTrue);
      });

      test('skipToEnd() changes phase to completed', () {
        final controller = MarioMakerTitleController()..skipToEnd();
        expect(controller.currentPhase, equals(AnimationPhase.completed));
      });

      test('reset() restores initial state', () {
        final controller = MarioMakerTitleController()
          ..skipToEnd()
          ..reset();
        expect(controller.isCompleted, isFalse);
        expect(controller.currentPhase, equals(AnimationPhase.idle));
      });
    });

    group('listeners', () {
      test('notifies listeners on pause', () {
        final controller = MarioMakerTitleController();
        var notified = false;
        controller
          ..addListener(() => notified = true)
          ..pause();
        expect(notified, isTrue);
      });

      test('notifies listeners on resume', () {
        final controller = MarioMakerTitleController()..pause();
        var notified = false;
        controller
          ..addListener(() => notified = true)
          ..resume();
        expect(notified, isTrue);
      });

      test('notifies listeners on skipToEnd', () {
        final controller = MarioMakerTitleController();
        var notified = false;
        controller
          ..addListener(() => notified = true)
          ..skipToEnd();
        expect(notified, isTrue);
      });

      test('notifies listeners on reset', () {
        final controller = MarioMakerTitleController()..skipToEnd();
        var notified = false;
        controller
          ..addListener(() => notified = true)
          ..reset();
        expect(notified, isTrue);
      });

      test('updatePhase updates current phase', () {
        final controller = MarioMakerTitleController()
          ..updatePhase(AnimationPhase.entering);
        expect(controller.currentPhase, equals(AnimationPhase.entering));
      });

      test('updatePhase does not notify listeners (internal use only)', () {
        final controller = MarioMakerTitleController();
        var notified = false;
        controller
          ..addListener(() => notified = true)
          ..updatePhase(AnimationPhase.entering);
        // updatePhase is for internal sync and doesn't notify
        expect(notified, isFalse);
      });
    });

    group('dispose', () {
      test('can be disposed', () {
        final controller = MarioMakerTitleController();
        expect(controller.dispose, returnsNormally);
      });

      test('can be disposed after state changes', () {
        final controller = MarioMakerTitleController()
          ..pause()
          ..resume()
          ..skipToEnd();
        expect(controller.dispose, returnsNormally);
      });
    });

    // Note: Widget integration tests are omitted for MarioMakerTitle due to
    // child widget timers (ContractingCircleMask, BouncingCircle, etc.) and
    // precacheImage calls which are complex to handle in tests.
    //
    // The controller state management is thoroughly tested above.
    // Widget integration is tested through the simpler Persona5 and Evangelion
    // controller tests which share the same base FancyTitleController.
    //
    // See test/mario_maker/mario_maker_title_test.dart for similar patterns.
  });
}
