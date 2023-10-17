import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/ui/model/player_choice.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(null) List<PlayerChoicePiece>? pieces,
  }) = _HomeState;
}

@freezed
class ConfirmToMakePieceResult with _$ConfirmToMakePieceResult {
  const factory ConfirmToMakePieceResult.continued({
    required bool requestedDoNotShowAgain,
  }) = _ConfirmToMakePieceResultContinued;
  const factory ConfirmToMakePieceResult.canceled() =
      _ConfirmToMakePieceResultCanceled;
}
