import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/ui/model/localized_template.dart';
import 'package:video_trimmer/video_trimmer.dart';

part 'trim_sound_for_detection_state.freezed.dart';

@freezed
abstract class TrimSoundForDetectionState with _$TrimSoundForDetectionState {
  const factory TrimSoundForDetectionState({
    required Trimmer trimmer,
    @Default(0.0) double startValue,
    @Default(0.0) double endValue,
    @Default(false) bool isPlaying,
    @Default(null) TrimSoundForDetectionScreenProcess? process,
  }) = _TrimSoundForDetectionState;
}

enum TrimSoundForDetectionScreenProcess {
  /// 動画の変換中
  convert,

  /// 非無音部分の検知のためのアップロード中
  detect,
}

@freezed
abstract class TrimSoundForDetectionArgs with _$TrimSoundForDetectionArgs {
  const factory TrimSoundForDetectionArgs({
    required LocalizedTemplate template,
    required String moviePath,
  }) = _TrimSoundForDetectionArgs;
}
