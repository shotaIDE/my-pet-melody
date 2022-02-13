import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/ui/home_state.dart';

part 'select_template_state.freezed.dart';

@freezed
class SelectTemplateState with _$SelectTemplateState {
  const factory SelectTemplateState({
    @Default(null) List<PlayableTemplate>? templates,
  }) = _SelectTemplateState;
}

@freezed
class PlayableTemplate with _$PlayableTemplate {
  const factory PlayableTemplate({
    required Template template,
    required PlayStatus status,
  }) = _PlayableTemplate;
}
