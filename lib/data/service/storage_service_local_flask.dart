import 'dart:io';

import 'package:meow_music/data/api/storage_api.dart';
import 'package:meow_music/data/definitions/app_definitions.dart';
import 'package:meow_music/data/model/uploaded_media.dart';
import 'package:meow_music/data/service/storage_service.dart';

class StorageServiceLocalFlask implements StorageService {
  const StorageServiceLocalFlask({
    required StorageApi api,
  }) : _api = api;

  final StorageApi _api;

  @override
  Future<String> templateUrl({required String id}) async {
    return '${AppDefinitions.serverOrigin}/static/templates/$id.wav';
  }

  @override
  Future<String> pieceDownloadUrl({
    required String fileName,
  }) async {
    return '${AppDefinitions.serverOrigin}/static/exports/$fileName';
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
    final url =
        '${AppDefinitions.serverOrigin}/static/uploads/$uploadedFileName';

    return UploadedMedia(
      id: response.id,
      extension: response.extension,
      url: url,
    );
  }
}
