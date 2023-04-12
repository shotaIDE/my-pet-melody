import 'package:freezed_annotation/freezed_annotation.dart';

part 'root_state.freezed.dart';

@freezed
class RootState with _$RootState {
  const factory RootState({
    @Default(null) bool? showHomeScreen,
  }) = _RootState;
}
