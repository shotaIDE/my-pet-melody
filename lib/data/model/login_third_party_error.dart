import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_third_party_error.freezed.dart';

@freezed
sealed class LoginThirdPartyError with _$LoginThirdPartyError {
  const factory LoginThirdPartyError.cancelledByUser() =
      LoginThirdPartyErrorCancelledByUser;
  const factory LoginThirdPartyError.unrecoverable() =
      LoginThirdPartyErrorUnrecoverable;
}
