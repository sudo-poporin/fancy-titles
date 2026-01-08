import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FancyTitleController', () {
    group('SonicManiaSplashController', () {
      test('can be instantiated', () {
        expect(SonicManiaSplashController(), isNotNull);
      });

      test('starts in idle phase', () {
        final controller = SonicManiaSplashController();
        expect(controller.currentPhase, equals(AnimationPhase.idle));
      });

      test('starts not paused', () {
        final controller = SonicManiaSplashController();
        expect(controller.isPaused, isFalse);
      });

      test('starts not disposed', () {
        final controller = SonicManiaSplashController();
        expect(controller.isDisposed, isFalse);
      });

      test('starts not completed', () {
        final controller = SonicManiaSplashController();
        expect(controller.isCompleted, isFalse);
      });

      group('pause()', () {
        test('sets isPaused to true', () {
          final controller = SonicManiaSplashController()..pause();
          expect(controller.isPaused, isTrue);
        });

        test('notifies listeners', () {
          final controller = SonicManiaSplashController();
          var notified = false;
          controller
            ..addListener(() => notified = true)
            ..pause();
          expect(notified, isTrue);
        });

        test('does nothing if already paused', () {
          final controller = SonicManiaSplashController()..pause();
          var notifyCount = 0;
          controller
            ..addListener(() => notifyCount++)
            ..pause();
          expect(notifyCount, isZero);
        });

        test('does nothing if disposed', () {
          final controller = SonicManiaSplashController()
            ..dispose()
            ..pause();
          expect(controller.isPaused, isFalse);
        });
      });

      group('resume()', () {
        test('sets isPaused to false when paused', () {
          final controller = SonicManiaSplashController()..pause();
          expect(controller.isPaused, isTrue);
          controller.resume();
          expect(controller.isPaused, isFalse);
        });

        test('notifies listeners', () {
          final controller = SonicManiaSplashController()..pause();
          var notified = false;
          controller
            ..addListener(() => notified = true)
            ..resume();
          expect(notified, isTrue);
        });

        test('does nothing if not paused', () {
          final controller = SonicManiaSplashController();
          var notifyCount = 0;
          controller
            ..addListener(() => notifyCount++)
            ..resume();
          expect(notifyCount, isZero);
        });

        test('does nothing if disposed', () {
          final controller = SonicManiaSplashController()
            ..pause()
            ..dispose()
            ..resume();
          expect(controller.isPaused, isTrue);
        });
      });

      group('skipToEnd()', () {
        test('sets phase to completed', () {
          final controller = SonicManiaSplashController()..skipToEnd();
          expect(controller.currentPhase, equals(AnimationPhase.completed));
        });

        test('sets isCompleted to true', () {
          final controller = SonicManiaSplashController()..skipToEnd();
          expect(controller.isCompleted, isTrue);
        });

        test('clears isPaused', () {
          final controller = SonicManiaSplashController()
            ..pause()
            ..skipToEnd();
          expect(controller.isPaused, isFalse);
        });

        test('notifies listeners', () {
          final controller = SonicManiaSplashController();
          var notified = false;
          controller
            ..addListener(() => notified = true)
            ..skipToEnd();
          expect(notified, isTrue);
        });

        test('does nothing if disposed', () {
          final controller = SonicManiaSplashController()
            ..dispose()
            ..skipToEnd();
          expect(controller.currentPhase, equals(AnimationPhase.idle));
        });
      });

      group('reset()', () {
        test('sets phase to idle', () {
          final controller = SonicManiaSplashController()..skipToEnd();
          expect(controller.currentPhase, equals(AnimationPhase.completed));
          controller.reset();
          expect(controller.currentPhase, equals(AnimationPhase.idle));
        });

        test('clears isPaused', () {
          final controller = SonicManiaSplashController()
            ..pause()
            ..reset();
          expect(controller.isPaused, isFalse);
        });

        test('notifies listeners', () {
          final controller = SonicManiaSplashController();
          var notified = false;
          controller
            ..addListener(() => notified = true)
            ..reset();
          expect(notified, isTrue);
        });

        test('does nothing if disposed', () {
          final controller = SonicManiaSplashController()
            ..skipToEnd()
            ..dispose()
            ..reset();
          expect(controller.currentPhase, equals(AnimationPhase.completed));
        });
      });

      group('updatePhase()', () {
        test('updates currentPhase', () {
          final controller = SonicManiaSplashController()
            ..updatePhase(AnimationPhase.active);
          expect(controller.currentPhase, equals(AnimationPhase.active));
        });

        test('does nothing if disposed', () {
          final controller = SonicManiaSplashController()
            ..dispose()
            ..updatePhase(AnimationPhase.active);
          expect(controller.currentPhase, equals(AnimationPhase.idle));
        });
      });

      group('dispose()', () {
        test('sets isDisposed to true', () {
          final controller = SonicManiaSplashController()..dispose();
          expect(controller.isDisposed, isTrue);
        });
      });
    });
  });
}
