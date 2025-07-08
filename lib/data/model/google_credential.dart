import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_credential.freezed.dart';

@freezed
class GoogleCredential with _$GoogleCredential {
  const factory GoogleCredential({
    required String idToken,
  }) = _GoogleCredential;
}
