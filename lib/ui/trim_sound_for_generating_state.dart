import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_trimmer/video_trimmer.dart';

part 'trim_sound_for_generating_state.freezed.dart';

@freezed
class TrimSoundForGeneratingState with _$TrimSoundForGeneratingState {
  const factory TrimSoundForGeneratingState({
    required Trimmer trimmer,
    @Default(0.0) double startValue,
    @Default(0.0) double endValue,
    @Default(false) bool isPlaying,
    @Default(false) bool progressVisibility,
    @Default(false) bool isUploading,
  }) = _TrimSoundForGeneratingState;
}
