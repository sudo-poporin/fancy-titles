import 'package:fancy_titles/core/animation_phase.dart';
import 'package:fancy_titles/core/base_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseTitleWidget', () {
    test('can be subclassed with all callbacks', () {
      var startCalled = false;
      var completeCalled = false;
      AnimationPhase? lastPhase;

      final widget = _TestTitleWidget(
        onAnimationStart: () => startCalled = true,
        onAnimationComplete: () => completeCalled = true,
        onPhaseChange: (phase) => lastPhase = phase,
      );

      expect(widget.onAnimationStart, isNotNull);
      expect(widget.onAnimationComplete, isNotNull);
      expect(widget.onPhaseChange, isNotNull);
      expect(startCalled, isFalse);
      expect(completeCalled, isFalse);
      expect(lastPhase, isNull);
    });

    test('can be subclassed with no callbacks', () {
      const widget = _TestTitleWidget();

      expect(widget.onAnimationStart, isNull);
      expect(widget.onAnimationComplete, isNull);
      expect(widget.onPhaseChange, isNull);
    });

    testWidgets('provides callbacks to state', (tester) async {
      var startCalled = false;
      var completeCalled = false;
      final phases = <AnimationPhase>[];

      await tester.pumpWidget(
        MaterialApp(
          home: _TestTitleWidget(
            onAnimationStart: () => startCalled = true,
            onAnimationComplete: () => completeCalled = true,
            onPhaseChange: phases.add,
          ),
        ),
      );

      // Callbacks are accessible via widget property in state
      expect(startCalled, isFalse);
      expect(completeCalled, isFalse);
      expect(phases, isEmpty);
    });
  });

  group('AnimationPhaseMixin', () {
    testWidgets('starts with idle phase', (tester) async {
      late AnimationPhase initialPhase;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestTitleWidget(
            reportInitialPhase: (phase) => initialPhase = phase,
          ),
        ),
      );

      expect(initialPhase, AnimationPhase.idle);
    });

    testWidgets('currentPhase returns current phase', (tester) async {
      late _TestTitleWidgetState capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestTitleWidget(
            captureState: (state) => capturedState = state,
          ),
        ),
      );

      expect(capturedState.currentPhase, AnimationPhase.idle);

      capturedState.testUpdatePhase(AnimationPhase.entering);
      expect(capturedState.currentPhase, AnimationPhase.entering);

      capturedState.testUpdatePhase(AnimationPhase.active);
      expect(capturedState.currentPhase, AnimationPhase.active);
    });

    testWidgets('updatePhase triggers onPhaseChange', (tester) async {
      final phases = <AnimationPhase>[];
      late _TestTitleWidgetState capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestTitleWidget(
            onPhaseChange: phases.add,
            captureState: (state) => capturedState = state,
          ),
        ),
      );

      capturedState.testUpdatePhase(AnimationPhase.entering);
      expect(phases, [AnimationPhase.entering]);

      capturedState.testUpdatePhase(AnimationPhase.active);
      expect(phases, [AnimationPhase.entering, AnimationPhase.active]);
    });

    testWidgets(
      'updatePhase triggers onAnimationStart for entering phase',
      (tester) async {
        var startCalled = false;
        late _TestTitleWidgetState capturedState;

        await tester.pumpWidget(
          MaterialApp(
            home: _TestTitleWidget(
              onAnimationStart: () => startCalled = true,
              captureState: (state) => capturedState = state,
            ),
          ),
        );

        expect(startCalled, isFalse);

        capturedState.testUpdatePhase(AnimationPhase.entering);
        expect(startCalled, isTrue);
      },
    );

    testWidgets(
      'updatePhase triggers onAnimationComplete for completed phase',
      (tester) async {
        var completeCalled = false;
        late _TestTitleWidgetState capturedState;

        await tester.pumpWidget(
          MaterialApp(
            home: _TestTitleWidget(
              onAnimationComplete: () => completeCalled = true,
              captureState: (state) => capturedState = state,
            ),
          ),
        );

        expect(completeCalled, isFalse);

        capturedState.testUpdatePhase(AnimationPhase.completed);
        expect(completeCalled, isTrue);
      },
    );

    testWidgets('updatePhase ignores duplicate phases', (tester) async {
      var callCount = 0;
      late _TestTitleWidgetState capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestTitleWidget(
            onPhaseChange: (_) => callCount++,
            captureState: (state) => capturedState = state,
          ),
        ),
      );

      capturedState.testUpdatePhase(AnimationPhase.entering);
      expect(callCount, 1);

      // Duplicate phase - should be ignored
      capturedState.testUpdatePhase(AnimationPhase.entering);
      expect(callCount, 1);

      capturedState.testUpdatePhase(AnimationPhase.active);
      expect(callCount, 2);

      // Another duplicate
      capturedState.testUpdatePhase(AnimationPhase.active);
      expect(callCount, 2);
    });

    testWidgets(
      'onAnimationStart only triggers once for entering',
      (tester) async {
        var startCallCount = 0;
        late _TestTitleWidgetState capturedState;

        await tester.pumpWidget(
          MaterialApp(
            home: _TestTitleWidget(
              onAnimationStart: () => startCallCount++,
              captureState: (state) => capturedState = state,
            ),
          ),
        );

        capturedState.testUpdatePhase(AnimationPhase.entering);
        expect(startCallCount, 1);

        // Try entering again (should be ignored)
        capturedState.testUpdatePhase(AnimationPhase.entering);
        expect(startCallCount, 1);
      },
    );

    testWidgets('safeSetState does nothing when not mounted', (tester) async {
      late _TestTitleWidgetState capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestTitleWidget(
            captureState: (state) => capturedState = state,
          ),
        ),
      );

      // Dispose the widget
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

      // Should not throw even though widget is disposed
      expect(
        () => capturedState.testSafeSetState(() {}),
        returnsNormally,
      );
    });

    testWidgets('safeSetState updates state when mounted', (tester) async {
      late _TestTitleWidgetState capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestTitleWidget(
            captureState: (state) => capturedState = state,
          ),
        ),
      );

      expect(capturedState.testCounter, 0);

      capturedState.testSafeSetState(() {
        capturedState.testCounter++;
      });
      await tester.pump();

      expect(capturedState.testCounter, 1);
    });

    testWidgets('full lifecycle progression', (tester) async {
      final phases = <AnimationPhase>[];
      var startCalled = false;
      var completeCalled = false;
      late _TestTitleWidgetState capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestTitleWidget(
            onAnimationStart: () => startCalled = true,
            onAnimationComplete: () => completeCalled = true,
            onPhaseChange: phases.add,
            captureState: (state) => capturedState = state,
          ),
        ),
      );

      // Start at idle
      expect(capturedState.currentPhase, AnimationPhase.idle);
      expect(phases, isEmpty);

      // Enter
      capturedState.testUpdatePhase(AnimationPhase.entering);
      expect(startCalled, isTrue);
      expect(phases, [AnimationPhase.entering]);

      // Active
      capturedState.testUpdatePhase(AnimationPhase.active);
      expect(phases, [AnimationPhase.entering, AnimationPhase.active]);

      // Exiting
      capturedState.testUpdatePhase(AnimationPhase.exiting);
      expect(phases, [
        AnimationPhase.entering,
        AnimationPhase.active,
        AnimationPhase.exiting,
      ]);

      // Complete
      capturedState.testUpdatePhase(AnimationPhase.completed);
      expect(completeCalled, isTrue);
      expect(phases, [
        AnimationPhase.entering,
        AnimationPhase.active,
        AnimationPhase.exiting,
        AnimationPhase.completed,
      ]);
    });

    testWidgets('handles null callbacks gracefully', (tester) async {
      late _TestTitleWidgetState capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestTitleWidget(
            captureState: (state) => capturedState = state,
          ),
        ),
      );

      // These should not throw even with null callbacks
      expect(
        () => capturedState.testUpdatePhase(AnimationPhase.entering),
        returnsNormally,
      );
      expect(
        () => capturedState.testUpdatePhase(AnimationPhase.completed),
        returnsNormally,
      );
    });
  });
}

/// Test implementation of BaseTitleWidget.
class _TestTitleWidget extends BaseTitleWidget {
  const _TestTitleWidget({
    super.onAnimationStart,
    super.onAnimationComplete,
    super.onPhaseChange,
    this.reportInitialPhase,
    this.captureState,
  });

  final void Function(AnimationPhase)? reportInitialPhase;
  final void Function(_TestTitleWidgetState)? captureState;

  @override
  State<_TestTitleWidget> createState() => _TestTitleWidgetState();
}

class _TestTitleWidgetState extends State<_TestTitleWidget>
    with AnimationPhaseMixin {
  int testCounter = 0;

  @override
  void initState() {
    super.initState();
    widget.reportInitialPhase?.call(currentPhase);
    widget.captureState?.call(this);
  }

  /// Exposes [updatePhase] for testing (bypasses @protected).
  void testUpdatePhase(AnimationPhase phase) {
    updatePhase(phase);
  }

  /// Exposes [safeSetState] for testing (bypasses @protected).
  void testSafeSetState(VoidCallback fn) {
    safeSetState(fn);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
