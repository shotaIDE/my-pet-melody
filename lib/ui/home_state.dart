import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/ui/model/playable.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(null) List<PlayablePiece>? pieces,
    @Default(false) bool isProcessing,
  }) = _HomeState;
}
