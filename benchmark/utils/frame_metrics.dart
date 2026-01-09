/// Utilities for measuring frame performance in benchmarks.
library;

/// Metrics collected during benchmark execution.
///
/// Tracks frame durations, calculates averages, and detects jank frames
/// (frames exceeding the 16ms threshold for 60fps).
class FrameMetrics {
  /// List of recorded frame durations.
  final List<Duration> frameDurations = [];

  /// List of recorded build phase durations.
  final List<Duration> buildDurations = [];

  /// List of recorded paint phase durations.
  final List<Duration> paintDurations = [];

  /// Total number of recorded frames.
  int get totalFrames => frameDurations.length;

  /// Average frame time across all recorded frames.
  Duration get averageFrameTime {
    if (frameDurations.isEmpty) return Duration.zero;
    final total = frameDurations.fold<int>(
      0,
      (sum, d) => sum + d.inMicroseconds,
    );
    return Duration(microseconds: total ~/ frameDurations.length);
  }

  /// Percentage of frames that exceeded the 16ms jank threshold.
  double get jankPercentage {
    if (frameDurations.isEmpty) return 0;
    final jankFrames = frameDurations.where(
      (d) => d.inMilliseconds > 16,
    ).length;
    return (jankFrames / totalFrames) * 100;
  }

  /// Number of frames that exceeded the 16ms jank threshold.
  int get jankFrameCount => frameDurations.where(
        (d) => d.inMilliseconds > 16,
      ).length;

  /// Maximum frame duration recorded.
  Duration get maxFrameTime => frameDurations.isEmpty
      ? Duration.zero
      : frameDurations.reduce((a, b) => a > b ? a : b);

  /// Minimum frame duration recorded.
  Duration get minFrameTime => frameDurations.isEmpty
      ? Duration.zero
      : frameDurations.reduce((a, b) => a < b ? a : b);

  /// 95th percentile frame time (useful for detecting outliers).
  Duration get p95FrameTime {
    if (frameDurations.isEmpty) return Duration.zero;
    final sorted = List<Duration>.from(frameDurations)
      ..sort((a, b) => a.compareTo(b));
    final index = (sorted.length * 0.95).floor();
    return sorted[index.clamp(0, sorted.length - 1)];
  }

  /// Standard deviation of frame times in microseconds.
  double get standardDeviationUs {
    if (frameDurations.length < 2) return 0;
    final avgUs = averageFrameTime.inMicroseconds;
    final sumSquaredDiff = frameDurations.fold<double>(
      0,
      (sum, d) {
        final diff = d.inMicroseconds - avgUs;
        return sum + (diff * diff);
      },
    );
    return _sqrt(sumSquaredDiff / frameDurations.length);
  }

  /// Records a frame duration.
  void recordFrame(Duration duration) {
    frameDurations.add(duration);
  }

  /// Records a build phase duration.
  void recordBuild(Duration duration) {
    buildDurations.add(duration);
  }

  /// Records a paint phase duration.
  void recordPaint(Duration duration) {
    paintDurations.add(duration);
  }

  /// Resets all recorded metrics.
  void reset() {
    frameDurations.clear();
    buildDurations.clear();
    paintDurations.clear();
  }

  /// Converts metrics to a JSON-serializable map.
  Map<String, dynamic> toJson() => {
        'totalFrames': totalFrames,
        'averageFrameTimeUs': averageFrameTime.inMicroseconds,
        'jankPercentage': jankPercentage,
        'jankFrameCount': jankFrameCount,
        'maxFrameTimeMs': maxFrameTime.inMilliseconds,
        'minFrameTimeUs': minFrameTime.inMicroseconds,
        'p95FrameTimeUs': p95FrameTime.inMicroseconds,
        'standardDeviationUs': standardDeviationUs,
      };

  @override
  String toString() {
    return '''
FrameMetrics:
  Total frames: $totalFrames
  Average frame time: ${averageFrameTime.inMicroseconds}us (${(averageFrameTime.inMicroseconds / 1000).toStringAsFixed(2)}ms)
  Jank percentage: ${jankPercentage.toStringAsFixed(2)}%
  Jank frames: $jankFrameCount
  Max frame time: ${maxFrameTime.inMilliseconds}ms
  Min frame time: ${minFrameTime.inMicroseconds}us
  P95 frame time: ${p95FrameTime.inMicroseconds}us
  Std deviation: ${standardDeviationUs.toStringAsFixed(2)}us
''';
  }

  /// Simple square root implementation to avoid dart:math import.
  static double _sqrt(double value) {
    if (value <= 0) return 0;
    var guess = value / 2;
    for (var i = 0; i < 20; i++) {
      guess = (guess + value / guess) / 2;
    }
    return guess;
  }
}

/// Results from a benchmark run.
class BenchmarkResult {
  /// Creates a benchmark result.
  const BenchmarkResult({
    required this.widgetName,
    required this.metrics,
    required this.initialRenderTime,
    required this.passed,
    this.failureReason,
  });

  /// Name of the widget being benchmarked.
  final String widgetName;

  /// Frame metrics collected during the benchmark.
  final FrameMetrics metrics;

  /// Time to render the widget initially.
  final Duration initialRenderTime;

  /// Whether the benchmark passed all thresholds.
  final bool passed;

  /// Reason for failure if [passed] is false.
  final String? failureReason;

  /// Converts result to a JSON-serializable map.
  Map<String, dynamic> toJson() => {
        'widgetName': widgetName,
        'metrics': metrics.toJson(),
        'initialRenderTimeMs': initialRenderTime.inMilliseconds,
        'passed': passed,
        if (failureReason != null) 'failureReason': failureReason,
      };

  @override
  String toString() {
    final status = passed ? 'PASSED' : 'FAILED';
    return '''
=== $widgetName Benchmark [$status] ===
Initial render: ${initialRenderTime.inMilliseconds}ms
$metrics${failureReason != null ? 'Failure: $failureReason\n' : ''}''';
  }
}

/// Thresholds for benchmark validation.
class BenchmarkThresholds {
  /// Creates benchmark thresholds.
  const BenchmarkThresholds({
    this.maxJankPercentage = 1.0,
    this.maxAverageFrameTimeMs = 16,
    this.maxInitialRenderMs = 100,
    this.maxP95FrameTimeMs = 16,
  });

  /// Default thresholds for 60fps target.
  static const fps60 = BenchmarkThresholds();

  /// Stricter thresholds for 120fps target.
  static const fps120 = BenchmarkThresholds(
    maxJankPercentage: 0.5,
    maxAverageFrameTimeMs: 8,
    maxInitialRenderMs: 50,
    maxP95FrameTimeMs: 8,
  );

  /// Maximum allowed jank percentage.
  final double maxJankPercentage;

  /// Maximum allowed average frame time in milliseconds.
  final int maxAverageFrameTimeMs;

  /// Maximum allowed initial render time in milliseconds.
  final int maxInitialRenderMs;

  /// Maximum allowed P95 frame time in milliseconds.
  final int maxP95FrameTimeMs;

  /// Validates metrics against thresholds.
  ///
  /// Returns null if all thresholds pass, or a failure reason string.
  String? validate(FrameMetrics metrics, Duration initialRender) {
    final failures = <String>[];

    if (metrics.jankPercentage > maxJankPercentage) {
      failures.add(
        'Jank ${metrics.jankPercentage.toStringAsFixed(2)}% '
        '> $maxJankPercentage%',
      );
    }

    final avgMs = metrics.averageFrameTime.inMicroseconds / 1000;
    if (avgMs > maxAverageFrameTimeMs) {
      failures.add(
        'Avg frame ${avgMs.toStringAsFixed(2)}ms > ${maxAverageFrameTimeMs}ms',
      );
    }

    if (initialRender.inMilliseconds > maxInitialRenderMs) {
      failures.add(
        'Initial render ${initialRender.inMilliseconds}ms '
        '> ${maxInitialRenderMs}ms',
      );
    }

    final p95Ms = metrics.p95FrameTime.inMicroseconds / 1000;
    if (p95Ms > maxP95FrameTimeMs) {
      failures.add(
        'P95 frame ${p95Ms.toStringAsFixed(2)}ms > ${maxP95FrameTimeMs}ms',
      );
    }

    return failures.isEmpty ? null : failures.join('; ');
  }
}
