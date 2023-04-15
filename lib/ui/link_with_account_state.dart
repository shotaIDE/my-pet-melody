import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_with_account_state.freezed.dart';

@freezed
class LinkWithAccountState with _$LinkWithAccountState {
  const factory LinkWithAccountState({
    @Default(false) bool isProcessing,
  }) = _LinkWithAccountState;
}
