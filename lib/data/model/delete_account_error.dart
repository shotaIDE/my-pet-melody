import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_error.freezed.dart';

@freezed
sealed class DeleteAccountError with _$DeleteAccountError {
  const factory DeleteAccountError.cancelledByUser() =
      DeleteAccountErrorCancelledByUser;
  const factory DeleteAccountError.unrecoverable() =
      DeleteAccountErrorUnrecoverable;
}
