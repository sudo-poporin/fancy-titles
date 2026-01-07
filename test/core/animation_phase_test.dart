import 'package:fancy_titles/fancy_titles.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimationPhase', () {
    test('has all expected values', () {
      expect(AnimationPhase.values, hasLength(5));
      expect(
        AnimationPhase.values,
        containsAll([
          AnimationPhase.idle,
          AnimationPhase.entering,
          AnimationPhase.active,
          AnimationPhase.exiting,
          AnimationPhase.completed,
        ]),
      );
    });

    test('idle is the first value', () {
      expect(AnimationPhase.values.first, AnimationPhase.idle);
    });

    test('completed is the last value', () {
      expect(AnimationPhase.values.last, AnimationPhase.completed);
    });

    test('values follow lifecycle order', () {
      const values = AnimationPhase.values;
      expect(values[0], AnimationPhase.idle);
      expect(values[1], AnimationPhase.entering);
      expect(values[2], AnimationPhase.active);
      expect(values[3], AnimationPhase.exiting);
      expect(values[4], AnimationPhase.completed);
    });

    test('can be compared for equality', () {
      expect(AnimationPhase.idle == AnimationPhase.idle, isTrue);
      expect(AnimationPhase.idle == AnimationPhase.active, isFalse);
    });

    test('has correct string representation', () {
      expect(AnimationPhase.idle.name, 'idle');
      expect(AnimationPhase.entering.name, 'entering');
      expect(AnimationPhase.active.name, 'active');
      expect(AnimationPhase.exiting.name, 'exiting');
      expect(AnimationPhase.completed.name, 'completed');
    });
  });
}
