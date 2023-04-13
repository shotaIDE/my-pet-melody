import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/profile.dart';

part 'login_session.freezed.dart';

@freezed
class LoginSession with _$LoginSession {
  const factory LoginSession({
    required String userId,
    required String token,
    required Profile? profile,
  }) = _LoginSession;
}
