import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_trimmer/video_trimmer.dart';

part 'trim_sound_state.freezed.dart';

@freezed
class TrimSoundState with _$TrimSoundState {
  const factory TrimSoundState({
    required Trimmer trimmer,
    @Default(0.0) double startValue,
    @Default(0.0) double endValue,
    @Default(false) bool isPlaying,
    @Default(false) bool progressVisibility,
  }) = _TrimSoundState;
}
