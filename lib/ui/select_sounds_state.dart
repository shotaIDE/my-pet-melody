import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/template.dart';

part 'select_sounds_state.freezed.dart';

@freezed
class SelectSoundsState with _$SelectSoundsState {
  const factory SelectSoundsState({
    required Template template,
    required List<SelectedSound?> sounds,
    @Default(false) bool isAvailableSubmission,
    @Default(false) bool isProcessing,
  }) = _SelectSoundsState;
}

@freezed
class SelectedSound with _$SelectedSound {
  const factory SelectedSound.uploading({
    required String localFileName,
  }) = SelectedSoundUploading;

  const factory SelectedSound.uploaded({
    required String localFileName,
    required String remoteFileName,
  }) = SelectedSoundUploaded;
}
