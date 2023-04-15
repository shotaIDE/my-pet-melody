import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_error.freezed.dart';

@freezed
class DeleteAccountError with _$DeleteAccountError {
  const factory DeleteAccountError.cancelledByUser() =
      _DeleteAccountErrorCancelledByUser;
  const factory DeleteAccountError.unrecoverable() =
      _DeleteAccountErrorUnrecoverable;
}
