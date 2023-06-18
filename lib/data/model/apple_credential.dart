import 'package:freezed_annotation/freezed_annotation.dart';

part 'apple_credential.freezed.dart';

@freezed
class AppleCredential with _$AppleCredential {
  const factory AppleCredential({
    required String idToken,
    required String accessToken,
  }) = _AppleCredential;
}
