import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/account_provider.dart';

part 'delete_account_with_current_session_error.freezed.dart';

@freezed
class DeleteAccountWithCurrentSessionError
    with _$DeleteAccountWithCurrentSessionError {
  const factory DeleteAccountWithCurrentSessionError.needReauthenticate({
    required AccountProvider provider,
  }) = _DeleteAccountWithCurrentSessionErrorNeedReauthenticate;
  const factory DeleteAccountWithCurrentSessionError.unrecoverable() =
      _DeleteAccountWithCurrentSessionErrorUnrecoverable;
}
