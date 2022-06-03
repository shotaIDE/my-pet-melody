class AudioPositionHelper {
  static double getPositionRatio({
    required Duration duration,
    required Duration position,
  }) {
    final durationSeconds = duration.inMilliseconds;
    final positionSeconds = position.inMilliseconds;

    return positionSeconds / durationSeconds;
  }

  static String generateFormattedPosition(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    final milliseconds2 = duration.inMilliseconds % 1000;

    final paddedHours = hours.toString().padLeft(2, '0');
    final paddedMinutes = minutes.toString().padLeft(2, '0');
    final paddedSeconds = seconds.toString().padLeft(2, '0');
    final paddedMilliseconds = milliseconds2.toString().padLeft(3, '0');

    return '$paddedHours:$paddedMinutes:$paddedSeconds.$paddedMilliseconds';
  }
}
