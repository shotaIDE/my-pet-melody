import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/ui/model/player_choice.dart';

part 'select_sounds_state.freezed.dart';

@freezed
class SelectSoundsState with _$SelectSoundsState {
  const factory SelectSoundsState({
    required PlayerChoiceTemplate template,
    required List<PlayerChoiceSound> sounds,
    @Default(false) bool isAvailableSubmission,
    @Default(false) bool isProcessing,
  }) = _SelectSoundsState;
}

@freezed
class SelectedSound with _$SelectedSound {
  const factory SelectedSound.none({
    required String id,
  }) = SelectedSoundNone;

  const factory SelectedSound.uploading({
    required String id,
    required String localFileName,
  }) = SelectedSoundUploading;

  const factory SelectedSound.uploaded({
    required String id,
    required String localFileName,
    required String remoteFileName,
  }) = SelectedSoundUploaded;
}
