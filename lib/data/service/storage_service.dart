import 'dart:io';

import 'package:meow_music/data/model/uploaded_sound.dart';

abstract class StorageService {
  Future<String> getDownloadUrl({required String path});

  Future<UploadedSound?> upload(
    File file, {
    required String fileName,
    required String userId,
  });
}
