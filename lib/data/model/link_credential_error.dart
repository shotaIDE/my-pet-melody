import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_credential_error.freezed.dart';

@freezed
class LinkCredentialError with _$LinkCredentialError {
  const factory LinkCredentialError.alreadyInUse() =
      _LinkCredentialErrorAlreadyInUse;
  const factory LinkCredentialError.unrecoverable() =
      _LinkCredentialErrorUnrecoverable;
}
