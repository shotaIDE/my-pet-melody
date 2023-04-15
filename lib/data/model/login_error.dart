import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_error.freezed.dart';

@freezed
class LoginError with _$LoginError {
  const factory LoginError.cancelledByUser() = _LoginErrorCancelledByUser;
  const factory LoginError.alreadyInUse() = _LoginErrorAlreadyInUse;
  const factory LoginError.unrecoverable() = _LoginErrorUnrecoverable;
}
