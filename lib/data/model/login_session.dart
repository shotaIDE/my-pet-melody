import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_session.freezed.dart';

@freezed
class LoginSession with _$LoginSession {
  const factory LoginSession({
    required String userId,
    required String token,
  }) = _LoginSession;
}
