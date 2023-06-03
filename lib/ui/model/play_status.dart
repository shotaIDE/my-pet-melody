import 'package:freezed_annotation/freezed_annotation.dart';

part 'play_status.freezed.dart';

@freezed
class PlayStatus with _$PlayStatus {
  const factory PlayStatus.stop() = _PlayStatusStop;

  const factory PlayStatus.loadingMedia() = _PlayStatusLoadingMedia;

  const factory PlayStatus.playing({
    required double position,
  }) = _PlayStatusPlaying;
}
