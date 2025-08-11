import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/ui/model/player_choice.dart';

part 'select_template_state.freezed.dart';

@freezed
abstract class SelectTemplateState with _$SelectTemplateState {
  const factory SelectTemplateState({
    @Default(null) List<PlayerChoiceTemplate>? templates,
  }) = _SelectTemplateState;
}
