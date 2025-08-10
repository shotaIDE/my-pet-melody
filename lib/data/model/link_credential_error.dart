import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_credential_error.freezed.dart';

@freezed
sealed class LinkCredentialError with _$LinkCredentialError {
  const factory LinkCredentialError.alreadyInUse() =
      LinkCredentialErrorAlreadyInUse;
  const factory LinkCredentialError.unrecoverable() =
      LinkCredentialErrorUnrecoverable;
}
