import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/data/api/my_dio.dart';

part 'storage_api.freezed.dart';
part 'storage_api.g.dart';

final storageApiProvider = Provider(
  (ref) => StorageApi(
    dio: ref.watch(dioProvider),
  ),
);

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
