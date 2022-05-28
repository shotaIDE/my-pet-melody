import 'dart:io';

import 'package:meow_music/data/model/uploaded_sound.dart';

abstract class StorageService {
  Future<String> getDownloadUrl({required String path});

  Future<UploadedSound?> uploadOriginal(
    File file, {
    required String fileName,
    required String userId,
  });

  Future<UploadedSound?> uploadTrimmed(
    File file, {
    required String fileName,
    required String userId,
  });
}
