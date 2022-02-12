import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/api/my_dio.dart';

part 'submission_api.freezed.dart';
part 'submission_api.g.dart';

class SubmissionApi {
  SubmissionApi({required MyDio dio}) : _dio = dio;

  final MyDio _dio;

  Future<void> upload(
    File file, {
    required String fileName,
  }) async {
    return _dio.postFile(
      path: '/upload',
      file: file,
      fileName: fileName,
      responseParser: (json) => null,
    );
  }

  Future<void> submit(SubmitRequest request) async {
    return _dio.post(
      path: '/',
      responseParser: (json) => null,
      data: request.toJson(),
    );
  }
}

@freezed
class SubmitRequest with _$SubmitRequest {
  const factory SubmitRequest({
    required String userId,
  }) = _SubmitRequest;

  factory SubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitRequestFromJson(json);
}
