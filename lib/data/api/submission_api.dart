import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/data/api/my_dio.dart';
import 'package:my_pet_melody/flavor.dart';

part 'submission_api.freezed.dart';
part 'submission_api.g.dart';

final Provider<SubmissionApi> submissionApiProvider = Provider(
  (ref) => SubmissionApi(
    dio: ref.watch(dioProvider),
  ),
);

class SubmissionApi {
  SubmissionApi({required MyDio dio}) : _dio = dio;

  final MyDio _dio;

  Future<DetectResponse?> detect(
    DetectRequest request, {
    required String token,
  }) {
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
    required String purchaseUserId,
  }) async {
    final response = await _dio.post(
      path: '/submit',
      responseParser: SubmitResponse.fromJson,
      token: token,
      purchaseUserId: purchaseUserId,
      data: request.toJson(),
    );

    if (flavor == Flavor.emulator) {
      // In environments where Cloud Tasks is not supported, reproduce queuing
      // by making asynchronous requests from client to generation endpoint.
      unawaited(() async {
        await Future<void>.delayed(const Duration(seconds: 3));

        final pieceId = response!.pieceId;
        final pieceRequest = PieceRequest(
          pieceId: pieceId,
          templateId: request.templateId,
          soundFileNames: request.soundFileNames,
          displayName: request.displayName,
          thumbnailFileName: request.thumbnailFileName,
        );

        await _dio.post(
          path: '/piece',
          responseParser: PieceResponse.fromJson,
          token: token,
          data: pieceRequest.toJson(),
        );
      }());
    }

    return response;
  }
}

@freezed
abstract class DetectRequest with _$DetectRequest {
  const factory DetectRequest({
    required String fileName,
  }) = _DetectRequest;

  factory DetectRequest.fromJson(Map<String, dynamic> json) =>
      _$DetectRequestFromJson(json);
}

@freezed
abstract class DetectResponse with _$DetectResponse {
  const factory DetectResponse({
    required List<DetectedSegment> detectedSegments,
    required List<EquallyDividedSegment> equallyDividedSegments,
    required int durationMilliseconds,
  }) = _DetectResponse;

  factory DetectResponse.fromJson(Map<String, dynamic> json) =>
      _$DetectResponseFromJson(json);
}

@freezed
abstract class DetectedSegment with _$DetectedSegment {
  const factory DetectedSegment({
    required String thumbnailBase64,
    required int startMilliseconds,
    required int endMilliseconds,
  }) = _DetectedSegment;

  factory DetectedSegment.fromJson(Map<String, dynamic> json) =>
      _$DetectedSegmentFromJson(json);
}

@freezed
abstract class EquallyDividedSegment with _$EquallyDividedSegment {
  const factory EquallyDividedSegment({
    required String thumbnailBase64,
  }) = _EquallyDividedSegment;

  factory EquallyDividedSegment.fromJson(Map<String, dynamic> json) =>
      _$EquallyDividedSegmentFromJson(json);
}

@freezed
abstract class SubmitRequest with _$SubmitRequest {
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
abstract class SubmitResponse with _$SubmitResponse {
  const factory SubmitResponse({
    required String pieceId,
  }) = _SubmitResponse;

  factory SubmitResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitResponseFromJson(json);
}

@freezed
abstract class PieceRequest with _$PieceRequest {
  const factory PieceRequest({
    required String pieceId,
    required String templateId,
    required List<String> soundFileNames,
    required String displayName,
    required String thumbnailFileName,
  }) = _PieceRequest;

  factory PieceRequest.fromJson(Map<String, dynamic> json) =>
      _$PieceRequestFromJson(json);
}

@freezed
abstract class PieceResponse with _$PieceResponse {
  const factory PieceResponse() = _PieceResponse;

  factory PieceResponse.fromJson(Map<String, dynamic> json) =>
      _$PieceResponseFromJson(json);
}
