import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(true) bool isCreateMode,
    @Default(false) bool isProcessing,
  }) = _LoginState;
}
