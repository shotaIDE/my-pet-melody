class AudioPositionHelper {
  static double getPositionRatio({
    required Duration duration,
    required Duration position,
  }) {
    final durationSeconds = duration.inMilliseconds;
    final positionSeconds = position.inMilliseconds;

    return positionSeconds / durationSeconds;
  }

  static String formattedPosition({required int milliseconds}) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours;
    final minutesDigits = duration.inMinutes % 60;
    final secondsDigits = duration.inSeconds % 60;
    final millisecondsDigits = duration.inMilliseconds % 1000;

    final paddedHours = hours.toString().padLeft(2, '0');
    final paddedMinutesDigits = minutesDigits.toString().padLeft(2, '0');
    final paddedSecondsDigits = secondsDigits.toString().padLeft(2, '0');
    final paddedMillisecondsDigits =
        millisecondsDigits.toString().padLeft(3, '0');

    return '$paddedHours:$paddedMinutesDigits:$paddedSecondsDigits'
        '.$paddedMillisecondsDigits';
  }
}
