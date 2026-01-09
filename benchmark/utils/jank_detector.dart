/// Jank detection utilities for performance benchmarking.
///
/// Provides tools to detect and measure jank frames during animations.
/// Uses Flutter's SchedulerBinding for accurate frame timing measurement.
library;

import 'package:flutter/scheduler.dart';

/// Detector for jank frames based on SchedulerBinding timings.
///
/// Captures real frame timings using [SchedulerBinding.addTimingsCallback]
/// which provides accurate build and raster durations for each frame.
///
/// Usage:
/// ```dart
/// final detector = JankDetector();
/// detector.startRecording();
/// // ... run animations ...
/// detector.stopRecording();
/// final stats = detector.getStats();
/// print('Jank: ${stats.jankPercentage}%');
/// ```
class JankDetector {
  final List<FrameTiming> _frameTimings = [];
  bool _isRecording = false;

  /// Whether the detector is currently recording frame timings.
  bool get isRecording => _isRecording;

  /// Number of frames recorded so far.
  int get frameCount => _frameTimings.length;

  /// Starts recording frame timings.
  ///
  /// Clears any previously recorded data before starting.
  /// Call [stopRecording] when done to prevent memory leaks.
  void startRecording() {
    _frameTimings.clear();
    _isRecording = true;
    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);
  }

  /// Stops recording frame timings.
  ///
  /// After stopping, call [getStats] or [getJankPercentage] to analyze
  /// the recorded data.
  void stopRecording() {
    _isRecording = false;
    SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);
  }

  void _onFrameTimings(List<FrameTiming> timings) {
    if (_isRecording) {
      _frameTimings.addAll(timings);
    }
  }

  /// Returns the percentage of frames that exceeded the target duration.
  ///
  /// [target] defaults to 16ms for 60fps. Use 8ms for 120fps devices.
  double getJankPercentage({
    Duration target = const Duration(milliseconds: 16),
  }) {
    if (_frameTimings.isEmpty) return 0;

    final jankCount = _frameTimings.where((timing) {
      final totalDuration = timing.totalSpan;
      return totalDuration > target;
    }).length;

    return (jankCount / _frameTimings.length) * 100;
  }

  /// Returns detailed statistics about recorded frames.
  JankStats getStats({
    Duration jankThreshold = const Duration(milliseconds: 16),
  }) {
    if (_frameTimings.isEmpty) {
      return JankStats.empty();
    }

    final buildTimes = _frameTimings.map((t) => t.buildDuration).toList();
    final rasterTimes = _frameTimings.map((t) => t.rasterDuration).toList();
    final totalTimes = _frameTimings.map((t) => t.totalSpan).toList();

    final jankFrames = _frameTimings.where(
      (t) => t.totalSpan > jankThreshold,
    );

    return JankStats(
      totalFrames: _frameTimings.length,
      jankFrames: jankFrames.length,
      averageBuildTime: _average(buildTimes),
      averageRasterTime: _average(rasterTimes),
      averageTotalTime: _average(totalTimes),
      maxTotalTime: totalTimes.reduce((a, b) => a > b ? a : b),
      minTotalTime: totalTimes.reduce((a, b) => a < b ? a : b),
      p95TotalTime: _percentile(totalTimes, 0.95),
      worstFrames: _getWorstFrames(5),
    );
  }

  /// Returns the raw frame timings for detailed analysis.
  List<FrameTiming> get rawTimings => List.unmodifiable(_frameTimings);

  /// Clears all recorded data without stopping recording.
  void clear() {
    _frameTimings.clear();
  }

  Duration _average(List<Duration> durations) {
    if (durations.isEmpty) return Duration.zero;
    final total = durations.fold<int>(
      0,
      (sum, d) => sum + d.inMicroseconds,
    );
    return Duration(microseconds: total ~/ durations.length);
  }

  Duration _percentile(List<Duration> durations, double percentile) {
    if (durations.isEmpty) return Duration.zero;
    final sorted = List<Duration>.from(durations)
      ..sort((a, b) => a.compareTo(b));
    final index = (sorted.length * percentile).floor();
    return sorted[index.clamp(0, sorted.length - 1)];
  }

  List<FrameInfo> _getWorstFrames(int count) {
    if (_frameTimings.isEmpty) return [];

    final indexed = _frameTimings.asMap().entries.toList()
      ..sort((a, b) => b.value.totalSpan.compareTo(a.value.totalSpan));

    return indexed.take(count).map((e) {
      return FrameInfo(
        index: e.key,
        buildDuration: e.value.buildDuration,
        rasterDuration: e.value.rasterDuration,
        totalDuration: e.value.totalSpan,
      );
    }).toList();
  }
}

/// Statistics about jank frames.
class JankStats {
  /// Creates jank statistics.
  const JankStats({
    required this.totalFrames,
    required this.jankFrames,
    required this.averageBuildTime,
    required this.averageRasterTime,
    required this.averageTotalTime,
    required this.maxTotalTime,
    required this.minTotalTime,
    required this.p95TotalTime,
    required this.worstFrames,
  });

  /// Creates empty statistics.
  factory JankStats.empty() => const JankStats(
        totalFrames: 0,
        jankFrames: 0,
        averageBuildTime: Duration.zero,
        averageRasterTime: Duration.zero,
        averageTotalTime: Duration.zero,
        maxTotalTime: Duration.zero,
        minTotalTime: Duration.zero,
        p95TotalTime: Duration.zero,
        worstFrames: [],
      );

  /// Total number of frames recorded.
  final int totalFrames;

  /// Number of frames that exceeded the jank threshold.
  final int jankFrames;

  /// Average time spent in the build phase.
  final Duration averageBuildTime;

  /// Average time spent in the raster phase.
  final Duration averageRasterTime;

  /// Average total frame time.
  final Duration averageTotalTime;

  /// Maximum total frame time.
  final Duration maxTotalTime;

  /// Minimum total frame time.
  final Duration minTotalTime;

  /// 95th percentile total frame time.
  final Duration p95TotalTime;

  /// Information about the worst (slowest) frames.
  final List<FrameInfo> worstFrames;

  /// Percentage of frames that were jank.
  double get jankPercentage =>
      totalFrames == 0 ? 0 : (jankFrames / totalFrames) * 100;

  /// Whether the jank percentage is below the given threshold.
  bool passesThreshold(double maxJankPercent) =>
      jankPercentage <= maxJankPercent;

  /// Converts to a JSON-serializable map.
  Map<String, dynamic> toJson() => {
        'totalFrames': totalFrames,
        'jankFrames': jankFrames,
        'jankPercentage': jankPercentage,
        'averageBuildTimeUs': averageBuildTime.inMicroseconds,
        'averageRasterTimeUs': averageRasterTime.inMicroseconds,
        'averageTotalTimeUs': averageTotalTime.inMicroseconds,
        'maxTotalTimeMs': maxTotalTime.inMilliseconds,
        'minTotalTimeUs': minTotalTime.inMicroseconds,
        'p95TotalTimeUs': p95TotalTime.inMicroseconds,
        'worstFrames': worstFrames.map((f) => f.toJson()).toList(),
      };

  @override
  String toString() => '''
JankStats:
  Total frames: $totalFrames
  Jank frames: $jankFrames (${jankPercentage.toStringAsFixed(2)}%)
  Avg build: ${averageBuildTime.inMicroseconds}us
  Avg raster: ${averageRasterTime.inMicroseconds}us
  Avg total: ${averageTotalTime.inMicroseconds}us (${(averageTotalTime.inMicroseconds / 1000).toStringAsFixed(2)}ms)
  Max total: ${maxTotalTime.inMilliseconds}ms
  Min total: ${minTotalTime.inMicroseconds}us
  P95 total: ${p95TotalTime.inMicroseconds}us
  Worst frames: ${worstFrames.isNotEmpty ? worstFrames.map((f) => '${f.totalDuration.inMilliseconds}ms').join(', ') : 'none'}
''';
}

/// Information about a single frame.
class FrameInfo {
  /// Creates frame information.
  const FrameInfo({
    required this.index,
    required this.buildDuration,
    required this.rasterDuration,
    required this.totalDuration,
  });

  /// Index of this frame in the recording.
  final int index;

  /// Time spent in the build phase.
  final Duration buildDuration;

  /// Time spent in the raster phase.
  final Duration rasterDuration;

  /// Total frame time.
  final Duration totalDuration;

  /// Converts to a JSON-serializable map.
  Map<String, dynamic> toJson() => {
        'index': index,
        'buildDurationUs': buildDuration.inMicroseconds,
        'rasterDurationUs': rasterDuration.inMicroseconds,
        'totalDurationUs': totalDuration.inMicroseconds,
      };

  @override
  String toString() =>
      'Frame#$index: build=${buildDuration.inMicroseconds}us, '
      'raster=${rasterDuration.inMicroseconds}us, '
      'total=${totalDuration.inMilliseconds}ms';
}

/// Simplified jank detector for widget tests.
///
/// Since [SchedulerBinding.addTimingsCallback] doesn't provide real frame
/// timings in the test environment, this class uses [Stopwatch] to measure
/// elapsed time between pump() calls.
///
/// This is less accurate than [JankDetector] but works in unit tests.
class TestJankDetector {
  final List<Duration> _frameDurations = [];
  final Stopwatch _stopwatch = Stopwatch();

  /// Number of frames recorded.
  int get frameCount => _frameDurations.length;

  /// Starts timing a frame.
  ///
  /// Call this before each `tester.pump()` call.
  void startFrame() {
    _stopwatch
      ..reset()
      ..start();
  }

  /// Ends timing a frame and records the duration.
  ///
  /// Call this after each `tester.pump()` call.
  void endFrame() {
    _stopwatch.stop();
    _frameDurations.add(_stopwatch.elapsed);
  }

  /// Records a frame with the given duration.
  ///
  /// Alternative to startFrame/endFrame when you measure externally.
  void recordFrame(Duration duration) {
    _frameDurations.add(duration);
  }

  /// Returns the percentage of frames exceeding the threshold.
  double getJankPercentage({
    Duration threshold = const Duration(milliseconds: 16),
  }) {
    if (_frameDurations.isEmpty) return 0;

    final jankCount = _frameDurations.where((d) => d > threshold).length;
    return (jankCount / _frameDurations.length) * 100;
  }

  /// Returns the number of jank frames.
  int getJankCount({
    Duration threshold = const Duration(milliseconds: 16),
  }) {
    return _frameDurations.where((d) => d > threshold).length;
  }

  /// Returns the average frame duration.
  Duration get averageFrameTime {
    if (_frameDurations.isEmpty) return Duration.zero;
    final total = _frameDurations.fold<int>(
      0,
      (sum, d) => sum + d.inMicroseconds,
    );
    return Duration(microseconds: total ~/ _frameDurations.length);
  }

  /// Returns the maximum frame duration.
  Duration get maxFrameTime => _frameDurations.isEmpty
      ? Duration.zero
      : _frameDurations.reduce((a, b) => a > b ? a : b);

  /// Returns the 95th percentile frame time.
  Duration get p95FrameTime {
    if (_frameDurations.isEmpty) return Duration.zero;
    final sorted = List<Duration>.from(_frameDurations)
      ..sort((a, b) => a.compareTo(b));
    final index = (sorted.length * 0.95).floor();
    return sorted[index.clamp(0, sorted.length - 1)];
  }

  /// Clears all recorded data.
  void reset() {
    _frameDurations.clear();
    _stopwatch.reset();
  }

  /// Returns statistics as a simple map.
  Map<String, dynamic> toJson() => {
        'frameCount': frameCount,
        'jankPercentage': getJankPercentage(),
        'jankCount': getJankCount(),
        'averageFrameTimeUs': averageFrameTime.inMicroseconds,
        'maxFrameTimeMs': maxFrameTime.inMilliseconds,
        'p95FrameTimeUs': p95FrameTime.inMicroseconds,
      };

  @override
  String toString() => '''
TestJankDetector:
  Frames: $frameCount
  Jank: ${getJankPercentage().toStringAsFixed(2)}% (${getJankCount()} frames)
  Average: ${averageFrameTime.inMicroseconds}us
  Max: ${maxFrameTime.inMilliseconds}ms
  P95: ${p95FrameTime.inMicroseconds}us
''';
}
