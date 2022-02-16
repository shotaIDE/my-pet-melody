import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploaded_sound.freezed.dart';

@freezed
class UploadedSound with _$UploadedSound {
  const factory UploadedSound({
    required String id,
    required String url,
  }) = _UploadedSound;
}
