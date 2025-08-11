import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/data/model/movie_segmentation.dart';
import 'package:my_pet_melody/data/model/uploaded_media.dart';
import 'package:my_pet_melody/ui/model/localized_template.dart';
import 'package:my_pet_melody/ui/model/player_choice.dart';

part 'select_trimmed_sound_state.freezed.dart';

@freezed
abstract class SelectTrimmedSoundState with _$SelectTrimmedSoundState {
  const factory SelectTrimmedSoundState({
    required String displayName,
    required List<PlayerChoiceTrimmedMovie> choices,
    required List<String?> equallyDividedThumbnailPaths,
    required int durationMilliseconds,
    @Default(null) int? selectedIndex,
    @Default(false) bool isUploading,
    @Default(false) bool isAvailableGoNext,
  }) = _SelectTrimmedSoundState;
}

@freezed
abstract class SelectTrimmedSoundArgs with _$SelectTrimmedSoundArgs {
  const factory SelectTrimmedSoundArgs({
    required LocalizedTemplate template,
    required String displayName,
    required String soundPath,
    required MovieSegmentation movieSegmentation,
  }) = _SelectTrimmedSoundArgs;
}

@freezed
abstract class SelectTrimmedSoundResult with _$SelectTrimmedSoundResult {
  const factory SelectTrimmedSoundResult({
    required UploadedMedia uploaded,
    required String displayName,
    required String thumbnailLocalPath,
  }) = _SelectTrimmedSoundResult;
}

@freezed
abstract class TrimmedSoundChoice with _$TrimmedSoundChoice {
  const factory TrimmedSoundChoice({
    required NonSilentSegment segment,
    @Default(null) String? thumbnailPath,
  }) = _TrimmedSoundChoice;
}
