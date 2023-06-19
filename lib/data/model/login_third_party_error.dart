import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_third_party_error.freezed.dart';

@freezed
class LoginThirdPartyError with _$LoginThirdPartyError {
  const factory LoginThirdPartyError.cancelledByUser() =
      _LoginThirdPartyErrorCancelledByUser;
  const factory LoginThirdPartyError.unrecoverable() =
      _LoginThirdPartyErrorUnrecoverable;
}
