import 'dart:io';

import 'package:meow_music/data/model/uploaded_media.dart';

abstract class StorageService {
  Future<String> templateMusicUrl({required String id});

  Future<String> pieceMovieDownloadUrl({
    required String fileName,
  });

  Future<String> pieceThumbnailDownloadUrl({
    required String fileName,
  });

  Future<UploadedMedia?> uploadUnedited(
    File file, {
    required String fileName,
  });

  Future<UploadedMedia?> uploadEdited(
    File file, {
    required String fileName,
  });
}
