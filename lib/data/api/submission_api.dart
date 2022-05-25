import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/api/my_dio.dart';
import 'package:meow_music/flavor.dart';

part 'submission_api.freezed.dart';
part 'submission_api.g.dart';

class SubmissionApi {
  SubmissionApi({required MyDio dio}) : _dio = dio;

  final MyDio _dio;

  Future<DetectResponse?> detect(
    File file, {
    required String fileName,
    required String token,
  }) async {
    return _dio.postFile(
      path: '/detect',
      file: file,
      fileName: fileName,
      responseParser: DetectResponse.fromJson,
      token: token,
    );
  }

  Future<SubmitResponse?> submit(
    SubmitRequest request, {
    required String token,
  }) async {
    final path = F.flavor == Flavor.local ? '/piece' : '/submit';

    return _dio.post(
      path: path,
      responseParser: SubmitResponse.fromJson,
      token: token,
      data: request.toJson(),
    );
  }
}

@freezed
class DetectResponse with _$DetectResponse {
  const factory DetectResponse({
    required List<List<int>> segments,
    required int durationMilliseconds,
  }) = _DetectResponse;

  factory DetectResponse.fromJson(Map<String, dynamic> json) =>
      _$DetectResponseFromJson(json);
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
    required String? id,
    required String? path,
  }) = _SubmitResponse;

  factory SubmitResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitResponseFromJson(json);
}
