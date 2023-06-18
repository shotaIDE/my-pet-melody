import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_credential.freezed.dart';

@freezed
class GoogleCredential with _$GoogleCredential {
  const factory GoogleCredential({
    required String idToken,
    required String accessToken,
  }) = _GoogleCredential;
}
