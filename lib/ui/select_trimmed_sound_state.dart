import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/non_silence_segment.dart';
import 'package:meow_music/ui/model/player_choice.dart';

part 'select_trimmed_sound_state.freezed.dart';

@freezed
class SelectTrimmedSoundState with _$SelectTrimmedSoundState {
  const factory SelectTrimmedSoundState({
    @Default(null) List<PlayerChoiceTemplate>? templates,
  }) = _SelectTrimmedSoundState;
}

@freezed
class SelectTrimmedSoundArgs with _$SelectTrimmedSoundArgs {
  const factory SelectTrimmedSoundArgs({
    required List<NonSilenceSegment> segments,
  }) = _SelectTrimmedSoundArgs;
}
