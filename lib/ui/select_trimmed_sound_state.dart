import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/detected_non_silent_segments.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/ui/model/player_choice.dart';

part 'select_trimmed_sound_state.freezed.dart';

@freezed
class SelectTrimmedSoundState with _$SelectTrimmedSoundState {
  const factory SelectTrimmedSoundState({
    required String fileName,
    required List<PlayerChoiceTrimmedMovie> choices,
    required List<String?> splitThumbnails,
    required int durationMilliseconds,
    @Default(false) bool isUploading,
  }) = _SelectTrimmedSoundState;
}

@freezed
class SelectTrimmedSoundArgs with _$SelectTrimmedSoundArgs {
  const factory SelectTrimmedSoundArgs({
    required String soundPath,
    required DetectedNonSilentSegments detected,
  }) = _SelectTrimmedSoundArgs;
}

@freezed
class SelectTrimmedSoundResult with _$SelectTrimmedSoundResult {
  const factory SelectTrimmedSoundResult({
    required UploadedSound uploaded,
    required String displayName,
    required String thumbnailPath,
  }) = _SelectTrimmedSoundResult;
}

@freezed
class TrimmedSoundChoice with _$TrimmedSoundChoice {
  const factory TrimmedSoundChoice({
    required NonSilentSegment segment,
    @Default(null) String? thumbnailPath,
  }) = _TrimmedSoundChoice;
}
