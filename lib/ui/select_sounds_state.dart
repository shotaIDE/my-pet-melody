import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/template.dart';

part 'select_sounds_state.freezed.dart';

@freezed
class SelectSoundsState with _$SelectSoundsState {
  factory SelectSoundsState({
    required Template template,
  }) = _SelectSoundsState;
}
