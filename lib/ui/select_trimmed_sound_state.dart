import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/movie_segmentation.dart';
import 'package:meow_music/data/model/uploaded_media.dart';
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
    required String fileName,
    required String soundPath,
    required MovieSegmentation movieSegmentation,
  }) = _SelectTrimmedSoundArgs;
}

@freezed
class SelectTrimmedSoundResult with _$SelectTrimmedSoundResult {
  const factory SelectTrimmedSoundResult({
    required UploadedMedia uploaded,
    required String displayName,
    required String thumbnailLocalPath,
  }) = _SelectTrimmedSoundResult;
}

@freezed
class TrimmedSoundChoice with _$TrimmedSoundChoice {
  const factory TrimmedSoundChoice({
    required NonSilentSegment segment,
    @Default(null) String? thumbnailPath,
  }) = _TrimmedSoundChoice;
}
