import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/piece.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(null) List<PlayablePiece>? pieces,
    @Default(false) bool isProcessing,
  }) = _HomeState;
}

@freezed
class PlayablePiece with _$PlayablePiece {
  const factory PlayablePiece({
    required Piece piece,
    required PlayStatus playStatus,
  }) = _PlayablePiece;
}

@freezed
class PlayStatus with _$PlayStatus {
  const factory PlayStatus.stop() = _PlayStatusStop;

  const factory PlayStatus.playing({
    required double position,
  }) = _PlayStatusPlaying;
}
