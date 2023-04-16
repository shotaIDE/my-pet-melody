import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/ui/model/player_choice.dart';

part 'select_sounds_state.freezed.dart';

@freezed
class SelectSoundsState with _$SelectSoundsState {
  const factory SelectSoundsState({
    required PlayerChoiceTemplate template,
    required List<PlayerChoiceSound> sounds,
    @Default(false) bool isAvailableSubmission,
    @Default(false) bool isPicking,
  }) = _SelectSoundsState;
}

@freezed
class SelectedSound with _$SelectedSound {
  const factory SelectedSound.none({
    required String id,
  }) = SelectedSoundNone;

  const factory SelectedSound.uploaded({
    required String id,
    required String extension,
    required String localFileName,
    required String remoteUrl,
  }) = SelectedSoundUploaded;
}

enum SelectSoundsScreenProcess {
  /// 動画の選択中
  pick,

  /// 非無音部分の検知対象のトリミング中
  trim,
}
