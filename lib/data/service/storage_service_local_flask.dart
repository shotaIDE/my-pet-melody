import 'dart:io';

import 'package:meow_music/data/definitions/app_definitions.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/data/service/storage_service.dart';

class StorageServiceLocalFlask implements StorageService {
  @override
  Future<String> getDownloadUrl({required String path}) async {
    return '${AppDefinitions.serverOrigin}$path';
  }

  @override
  Future<UploadedSound?> uploadOriginal(
    File file, {
    required String fileName,
    required String userId,
  }) async {
    return null;
  }

  @override
  Future<UploadedSound?> uploadTrimmed(
    File file, {
    required String fileName,
    required String userId,
  }) async {
    return null;
  }
}
