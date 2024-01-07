import 'dart:io';

import 'package:my_pet_melody/data/api/storage_api.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';
import 'package:my_pet_melody/data/model/uploaded_media.dart';
import 'package:my_pet_melody/data/service/storage_service.dart';

class StorageServiceLocalFlask implements StorageService {
  const StorageServiceLocalFlask({
    required StorageApi api,
  }) : _api = api;

  final StorageApi _api;

  @override
  Future<String> templateMusicUrl({required String id}) async {
    return '$serverOrigin/static/templates/$id/bgm.m4a';
  }

  @override
  Future<String> templateThumbnailUrl({required String id}) async {
    return '$serverOrigin/static/templates/$id/thumbnail.png';
  }

  @override
  Future<String> pieceMovieDownloadUrl({
    required String fileName,
  }) async {
    return '$serverOrigin/static/exports/$fileName';
  }

  @override
  Future<String?> generatingPieceThumbnailDownloadUrl({
    required String fileName,
  }) async {
    return '$serverOrigin/static/uploads/$fileName';
  }

  @override
  Future<String> generatedPieceThumbnailDownloadUrl({
    required String fileName,
  }) async {
    return '$serverOrigin/static/exports/$fileName';
  }

  @override
  Future<UploadedMedia?> uploadUnedited(
    File file, {
    required String fileName,
  }) async {
    return _upload(file, fileName: fileName);
  }

  @override
  Future<UploadedMedia?> uploadEdited(
    File file, {
    required String fileName,
  }) async {
    return _upload(file, fileName: fileName);
  }

  Future<UploadedMedia?> _upload(
    File file, {
    required String fileName,
  }) async {
    final response = await _api.upload(file, fileName: fileName);
    if (response == null) {
      return null;
    }

    final id = response.id;
    final extension = response.extension;
    final uploadedFileName = '$id$extension';
    final url = '$serverOrigin/static/uploads/$uploadedFileName';

    return UploadedMedia(
      id: response.id,
      extension: response.extension,
      url: url,
    );
  }
}
