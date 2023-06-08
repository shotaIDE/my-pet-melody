import 'dart:io';

import 'package:my_pet_melody/data/model/uploaded_media.dart';

abstract class StorageService {
  Future<String> templateMusicUrl({required String id});

  Future<String> templateThumbnailUrl({required String id});

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
