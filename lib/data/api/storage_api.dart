import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/api/my_dio.dart';

part 'storage_api.freezed.dart';
part 'storage_api.g.dart';

class StorageApi {
  StorageApi({required MyDio dio}) : _dio = dio;

  final MyDio _dio;

  Future<UploadResponse?> upload(
    File file, {
    required String fileName,
  }) async {
    return _dio.postFile(
      path: '/upload',
      file: file,
      fileName: fileName,
      responseParser: UploadResponse.fromJson,
    );
  }
}

@freezed
class UploadResponse with _$UploadResponse {
  const factory UploadResponse({
    required String id,
    required String extension,
  }) = _UploadResponse;

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseFromJson(json);
}
