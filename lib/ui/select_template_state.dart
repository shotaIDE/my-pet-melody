import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/ui/model/playable.dart';

part 'select_template_state.freezed.dart';

@freezed
class SelectTemplateState with _$SelectTemplateState {
  const factory SelectTemplateState({
    @Default(null) List<PlayableTemplate>? templates,
  }) = _SelectTemplateState;
}
