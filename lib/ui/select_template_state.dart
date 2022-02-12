import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/template.dart';

part 'select_template_state.freezed.dart';

@freezed
class SelectTemplateState with _$SelectTemplateState {
  factory SelectTemplateState({
    @Default(null) List<Template>? templates,
  }) = _SelectTemplateState;
}
