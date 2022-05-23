import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploaded_sound.freezed.dart';

@freezed
class UploadedSound with _$UploadedSound {
  const factory UploadedSound({
    required String id,
    required String extension,
    required String url,
  }) = _UploadedSound;
}

@freezed
class UploadedSoundDraft with _$UploadedSoundDraft {
  const factory UploadedSoundDraft({
    required String id,
    required String extension,
    required String path,
  }) = _UploadedSoundDraft;
}
