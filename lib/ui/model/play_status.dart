import 'package:freezed_annotation/freezed_annotation.dart';

part 'play_status.freezed.dart';

@freezed
sealed class PlayStatus with _$PlayStatus {
  const factory PlayStatus.stop() = PlayStatusStop;

  const factory PlayStatus.loadingMedia() = PlayStatusLoadingMedia;

  const factory PlayStatus.playing({
    required double position,
  }) = PlayStatusPlaying;
}
