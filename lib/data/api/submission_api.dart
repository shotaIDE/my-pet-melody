import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/api/my_dio.dart';
import 'package:meow_music/flavor.dart';

part 'submission_api.freezed.dart';
part 'submission_api.g.dart';

class SubmissionApi {
  SubmissionApi({required MyDio dio}) : _dio = dio;

  final MyDio _dio;

  Future<DetectResponse?> detect(
    DetectRequest request, {
    required String token,
  }) async {
    return _dio.post(
      path: '/detect',
      responseParser: DetectResponse.fromJson,
      token: token,
      data: request.toJson(),
    );
  }

  Future<SubmitResponse?> submit(
    SubmitRequest request, {
    required String token,
  }) async {
    // Cloud Tasks が対応していない環境では、直接作品生成のエンドポイントを叩く
    final path = F.flavor == Flavor.emulator ? '/piece' : '/submit';

    return _dio.post(
      path: path,
      responseParser: SubmitResponse.fromJson,
      token: token,
      data: request.toJson(),
    );
  }
}

@freezed
class DetectRequest with _$DetectRequest {
  const factory DetectRequest({
    required String fileName,
  }) = _DetectRequest;

  factory DetectRequest.fromJson(Map<String, dynamic> json) =>
      _$DetectRequestFromJson(json);
}

@freezed
class DetectResponse with _$DetectResponse {
  const factory DetectResponse({
    required List<DetectedSegment> detectedSegments,
    required List<EquallyDividedSegment> equallyDividedSegments,
    required int durationMilliseconds,
  }) = _DetectResponse;

  factory DetectResponse.fromJson(Map<String, dynamic> json) =>
      _$DetectResponseFromJson(json);
}

@freezed
class DetectedSegment with _$DetectedSegment {
  const factory DetectedSegment({
    required String thumbnailBase64,
    required int startMilliseconds,
    required int endMilliseconds,
  }) = _DetectedSegment;

  factory DetectedSegment.fromJson(Map<String, dynamic> json) =>
      _$DetectedSegmentFromJson(json);
}

@freezed
class EquallyDividedSegment with _$EquallyDividedSegment {
  const factory EquallyDividedSegment({
    required String thumbnailBase64,
  }) = _EquallyDividedSegment;

  factory EquallyDividedSegment.fromJson(Map<String, dynamic> json) =>
      _$EquallyDividedSegmentFromJson(json);
}

@freezed
class SubmitRequest with _$SubmitRequest {
  const factory SubmitRequest({
    required String templateId,
    required List<String> soundFileNames,
    required String displayName,
    required String thumbnailFileName,
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
