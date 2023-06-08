import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/data/model/profile.dart';

part 'login_session.freezed.dart';

@freezed
class LoginSession with _$LoginSession {
  const factory LoginSession({
    required String userId,
    required String token,
    required Profile? nonAnonymousProfile,
  }) = _LoginSession;
}
