import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_twitter_error.freezed.dart';

@freezed
class LoginTwitterError with _$LoginTwitterError {
  const factory LoginTwitterError.cancelledByUser() =
      _LoginTwitterErrorCancelledByUser;
  const factory LoginTwitterError.unrecoverable() =
      _LoginTwitterErrorUnrecoverable;
}
