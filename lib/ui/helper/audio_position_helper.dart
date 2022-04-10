class AudioPositionHelper {
  static double getPositionRatio({
    required Duration duration,
    required Duration position,
  }) {
    final durationSeconds = duration.inMilliseconds;
    final positionSeconds = position.inMilliseconds;

    return positionSeconds / durationSeconds;
  }
}
