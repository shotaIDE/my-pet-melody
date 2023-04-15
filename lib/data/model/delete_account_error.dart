import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/account_provider.dart';

part 'delete_account_error.freezed.dart';

@freezed
class DeleteAccountError with _$DeleteAccountError {
  const factory DeleteAccountError.needReauthenticate({
    required AccountProvider provider,
  }) = _DeleteAccountErrorNeedReauthenticate;
  const factory DeleteAccountError.unrecoverable() =
      _DeleteAccountErrorUnrecoverable;
}
