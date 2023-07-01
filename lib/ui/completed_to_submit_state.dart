import 'package:freezed_annotation/freezed_annotation.dart';

part 'completed_to_submit_state.freezed.dart';

@freezed
class CompletedToSubmitState with _$CompletedToSubmitState {
  const factory CompletedToSubmitState({
    required int? remainTimeMilliseconds,
  }) = _CompletedToSubmitState;
}
