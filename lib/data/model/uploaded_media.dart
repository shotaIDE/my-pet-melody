import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploaded_media.freezed.dart';

@freezed
abstract class UploadedMedia with _$UploadedMedia {
  const factory UploadedMedia({
    required String id,
    required String extension,
    required String url,
  }) = _UploadedMedia;
}

@freezed
abstract class UploadedMediaDraft with _$UploadedMediaDraft {
  const factory UploadedMediaDraft({
    required String id,
    required String extension,
    required String path,
  }) = _UploadedMediaDraft;
}
