import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/data/model/account_provider.dart';

part 'delete_account_with_current_session_error.freezed.dart';

@freezed
abstract class DeleteAccountWithCurrentSessionError
    with _$DeleteAccountWithCurrentSessionError {
  const factory DeleteAccountWithCurrentSessionError.needReauthenticate({
    required AccountProvider provider,
  }) = _DeleteAccountWithCurrentSessionErrorNeedReauthenticate;
  const factory DeleteAccountWithCurrentSessionError.unrecoverable() =
      _DeleteAccountWithCurrentSessionErrorUnrecoverable;
}
