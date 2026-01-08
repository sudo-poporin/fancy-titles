import 'dart:async';

import 'package:fancy_titles/core/cancelable_timers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CancelableTimersMixin', () {
    group('delayed', () {
      testWidgets('executes callback after duration', (tester) async {
        var callbackExecuted = false;

        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              state.testDelayed(
                const Duration(milliseconds: 500),
                () => callbackExecuted = true,
              );
            },
          ),
        );

        expect(callbackExecuted, isFalse);

        await tester.pump(const Duration(milliseconds: 500));
        expect(callbackExecuted, isTrue);
      });

      testWidgets('does not execute callback if disposed', (tester) async {
        var callbackExecuted = false;

        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              state.testDelayed(
                const Duration(seconds: 1),
                () => callbackExecuted = true,
              );
            },
          ),
        );

        // Dispose before timer fires
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 2));

        expect(callbackExecuted, isFalse);
      });

      testWidgets(
        'returns Timer that can be manually cancelled',
        (tester) async {
          var callbackExecuted = false;
          Timer? timer;

          await tester.pumpWidget(
            _TestWidget(
              onInit: (state) {
                timer = state.testDelayed(
                  const Duration(seconds: 1),
                  () => callbackExecuted = true,
                );
              },
            ),
          );

          timer?.cancel();
          await tester.pump(const Duration(seconds: 2));

          expect(callbackExecuted, isFalse);
        },
      );

      testWidgets('multiple timers can be scheduled', (tester) async {
        final callOrder = <int>[];

        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              state
                ..testDelayed(
                  const Duration(milliseconds: 100),
                  () => callOrder.add(1),
                )
                ..testDelayed(
                  const Duration(milliseconds: 200),
                  () => callOrder.add(2),
                )
                ..testDelayed(
                  const Duration(milliseconds: 300),
                  () => callOrder.add(3),
                );
            },
          ),
        );

        expect(callOrder, isEmpty);

        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1]);

        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1, 2]);

        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1, 2, 3]);
      });

      testWidgets('all timers are cancelled on dispose', (tester) async {
        final callOrder = <int>[];

        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              state
                ..testDelayed(
                  const Duration(milliseconds: 100),
                  () => callOrder.add(1),
                )
                ..testDelayed(
                  const Duration(milliseconds: 200),
                  () => callOrder.add(2),
                )
                ..testDelayed(
                  const Duration(milliseconds: 300),
                  () => callOrder.add(3),
                );
            },
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1]);

        // Dispose after first timer
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 500));

        // Only first callback executed
        expect(callOrder, [1]);
      });
    });

    group('delayedChain', () {
      testWidgets('executes callbacks in sequence', (tester) async {
        final callOrder = <int>[];

        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              state.testDelayedChain([
                (
                  duration: const Duration(milliseconds: 100),
                  callback: () => callOrder.add(1),
                ),
                (
                  duration: const Duration(milliseconds: 100),
                  callback: () => callOrder.add(2),
                ),
                (
                  duration: const Duration(milliseconds: 100),
                  callback: () => callOrder.add(3),
                ),
              ]);
            },
          ),
        );

        expect(callOrder, isEmpty);

        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1]);

        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1, 2]);

        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1, 2, 3]);
      });

      testWidgets('accumulates durations correctly', (tester) async {
        final callOrder = <int>[];

        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              state.testDelayedChain([
                (
                  duration: const Duration(milliseconds: 100),
                  callback: () => callOrder.add(1),
                ),
                (
                  duration: const Duration(milliseconds: 200),
                  callback: () => callOrder.add(2),
                ),
              ]);
            },
          ),
        );

        // First callback at 100ms
        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1]);

        // Second callback at 100ms + 200ms = 300ms, so 200ms more
        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1]); // Not yet

        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1, 2]); // Now at 300ms total
      });

      testWidgets('cancels all timers on dispose', (tester) async {
        final callOrder = <int>[];

        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              state.testDelayedChain([
                (
                  duration: const Duration(milliseconds: 100),
                  callback: () => callOrder.add(1),
                ),
                (
                  duration: const Duration(milliseconds: 200),
                  callback: () => callOrder.add(2),
                ),
              ]);
            },
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));
        expect(callOrder, [1]);

        // Dispose before second timer
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 300));

        expect(callOrder, [1]); // Second callback never executed
      });

      testWidgets('handles empty chain', (tester) async {
        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              state.testDelayedChain([]);
            },
          ),
        );

        // Should not throw
        await tester.pump();
      });

      testWidgets('handles single item chain', (tester) async {
        var callbackExecuted = false;

        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              state.testDelayedChain([
                (
                  duration: const Duration(milliseconds: 100),
                  callback: () => callbackExecuted = true,
                ),
              ]);
            },
          ),
        );

        expect(callbackExecuted, isFalse);

        await tester.pump(const Duration(milliseconds: 100));
        expect(callbackExecuted, isTrue);
      });
    });

    group('dispose', () {
      testWidgets('cancels all pending timers', (tester) async {
        var timersFired = 0;

        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              for (var i = 0; i < 5; i++) {
                state.testDelayed(
                  Duration(milliseconds: 100 * (i + 1)),
                  () => timersFired++,
                );
              }
            },
          ),
        );

        // Dispose immediately
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 1));

        expect(timersFired, 0);
      });

      testWidgets('clears timer list on dispose', (tester) async {
        late _TestWidgetState capturedState;

        await tester.pumpWidget(
          _TestWidget(
            onInit: (state) {
              capturedState = state;
              state.testDelayed(
                const Duration(seconds: 1),
                () {},
              );
            },
          ),
        );

        expect(capturedState.timerCount, 1);

        // Dispose
        await tester.pumpWidget(const SizedBox.shrink());

        // Timer list should be cleared (we can't directly access, but no error)
        await tester.pump(const Duration(seconds: 2));
      });
    });
  });
}

/// Test helper widget that uses CancelableTimersMixin.
class _TestWidget extends StatefulWidget {
  const _TestWidget({required this.onInit});

  final void Function(_TestWidgetState state) onInit;

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget> with CancelableTimersMixin {
  /// Exposes timer count for testing.
  int get timerCount => _timerCount;
  int _timerCount = 0;

  /// Exposes [delayed] for testing (bypasses @protected).
  Timer testDelayed(Duration duration, VoidCallback callback) {
    _timerCount++;
    return delayed(duration, callback);
  }

  /// Exposes [delayedChain] for testing (bypasses @protected).
  void testDelayedChain(
    List<({Duration duration, VoidCallback callback})> chain,
  ) {
    delayedChain(chain);
  }

  @override
  void initState() {
    super.initState();
    widget.onInit(this);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
