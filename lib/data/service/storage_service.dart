import 'dart:io';

import 'package:meow_music/data/model/uploaded_sound.dart';

abstract class StorageService {
  Future<String> templateUrl({required String id});

  Future<String> pieceDownloadUrl({
    required String fileName,
  });

  Future<UploadedSound?> uploadUnedited(
    File file, {
    required String fileName,
  });

  Future<UploadedSound?> uploadEdited(
    File file, {
    required String fileName,
  });
}
