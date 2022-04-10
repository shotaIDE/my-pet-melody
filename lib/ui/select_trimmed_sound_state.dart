import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/non_silence_segment.dart';
import 'package:meow_music/ui/model/player_choice.dart';

part 'select_trimmed_sound_state.freezed.dart';

@freezed
class SelectTrimmedSoundState with _$SelectTrimmedSoundState {
  const factory SelectTrimmedSoundState({
    required List<PlayerChoiceTrimmedMovie> choices,
    @Default(null) int? lengthMilliseconds,
    @Default(null) List<String>? splitThumbnails,
  }) = _SelectTrimmedSoundState;
}

@freezed
class SelectTrimmedSoundArgs with _$SelectTrimmedSoundArgs {
  const factory SelectTrimmedSoundArgs({
    required String soundPath,
    required List<NonSilenceSegment> segments,
  }) = _SelectTrimmedSoundArgs;
}

@freezed
class TrimmedSoundChoice with _$TrimmedSoundChoice {
  const factory TrimmedSoundChoice({
    required NonSilenceSegment segment,
    @Default(null) String? thumbnailPath,
  }) = _TrimmedSoundChoice;
}
