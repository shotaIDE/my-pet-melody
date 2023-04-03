import 'package:freezed_annotation/freezed_annotation.dart';

part 'twitter_credential.freezed.dart';

@freezed
class TwitterCredential with _$TwitterCredential {
  const factory TwitterCredential({
    required String authToken,
    required String secret,
  }) = _TwitterCredential;
}
