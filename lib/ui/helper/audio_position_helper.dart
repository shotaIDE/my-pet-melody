double getAudioPositionRatio({
  required Duration duration,
  required Duration position,
}) {
  final durationSeconds = duration.inMilliseconds;
  final positionSeconds = position.inMilliseconds;

  return positionSeconds / durationSeconds;
}
