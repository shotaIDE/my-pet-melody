class AudioPositionHelper {
  static double getPositionRatio({
    required Duration length,
    required Duration position,
  }) {
    final lengthSeconds = length.inMilliseconds;
    final positionSeconds = position.inMilliseconds;

    return positionSeconds / lengthSeconds;
  }
}
