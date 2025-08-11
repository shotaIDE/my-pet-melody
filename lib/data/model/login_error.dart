import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_error.freezed.dart';

@freezed
sealed class LoginError with _$LoginError {
  const factory LoginError.cancelledByUser() = LoginErrorCancelledByUser;
  const factory LoginError.alreadyInUse() = LoginErrorAlreadyInUse;
  const factory LoginError.unrecoverable() = LoginErrorUnrecoverable;
}
