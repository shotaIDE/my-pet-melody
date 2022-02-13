import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/api/my_dio.dart';

part 'submission_api.freezed.dart';
part 'submission_api.g.dart';

class SubmissionApi {
  SubmissionApi({required MyDio dio}) : _dio = dio;

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

  Future<SubmitResponse?> submit(SubmitRequest request) async {
    return _dio.post(
      path: '/',
      responseParser: SubmitResponse.fromJson,
      data: request.toJson(),
    );
  }
}

@freezed
class UploadResponse with _$UploadResponse {
  const factory UploadResponse({
    required String fileName,
    required String path,
  }) = _UploadResponse;

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseFromJson(json);
}

@freezed
class SubmitRequest with _$SubmitRequest {
  const factory SubmitRequest({
    required String userId,
    required String templateId,
    required List<String> fileNames,
  }) = _SubmitRequest;

  factory SubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitRequestFromJson(json);
}

@freezed
class SubmitResponse with _$SubmitResponse {
  const factory SubmitResponse({
    required String id,
    required String path,
  }) = _SubmitResponse;

  factory SubmitResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitResponseFromJson(json);
}

@freezed
class FetchedPiece with _$FetchedPiece {
  const factory FetchedPiece({
    required String id,
    required String path,
  }) = _FetchedPiece;
}
