import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_pet_melody/data/model/login_session.dart';
import 'package:my_pet_melody/data/model/uploaded_media.dart';
import 'package:my_pet_melody/data/service/auth_service.dart';
import 'package:my_pet_melody/data/service/storage_service.dart';
import 'package:path/path.dart';

final storageServiceProvider = FutureProvider<StorageService>(
  (ref) async {
    final session = await ref.watch(sessionStreamProvider.future);

    return StorageServiceFirebase(session: session);
  },
);

class StorageServiceFirebase implements StorageService {
  StorageServiceFirebase({
    required LoginSession session,
  }) : _session = session;

  final format = DateFormat('yyyyMMddHHmmss');

  final LoginSession _session;

  @override
  Future<String> templateMusicUrl({required String id}) async {
    final storageRef = FirebaseStorage.instance.ref();

    final pathRef = storageRef.child('systemMedia/templates/$id/bgm.m4a');

    return pathRef.getDownloadURL();
  }

  @override
  Future<String> templateThumbnailUrl({required String id}) async {
    final storageRef = FirebaseStorage.instance.ref();

    final pathRef = storageRef.child('systemMedia/templates/$id/thumbnail.png');

    return pathRef.getDownloadURL();
  }

  @override
  Future<String> pieceMovieDownloadUrl({
    required String fileName,
  }) async {
    final userId = _session.userId;

    final storageRef = FirebaseStorage.instance.ref();

    final pathRef =
        storageRef.child('userMedia/$userId/generatedPieces/$fileName');

    return pathRef.getDownloadURL();
  }

  @override
  Future<String> generatingPieceThumbnailDownloadUrl({
    required String fileName,
  }) async {
    final userId = _session.userId;

    final storageRef = FirebaseStorage.instance.ref();

    final pathRef =
        storageRef.child('userTemporaryMedia/edited/$userId/$fileName');

    return pathRef.getDownloadURL();
  }

  @override
  Future<String> generatedPieceThumbnailDownloadUrl({
    required String fileName,
  }) async {
    final userId = _session.userId;

    final storageRef = FirebaseStorage.instance.ref();

    final pathRef =
        storageRef.child('userMedia/$userId/generatedThumbnail/$fileName');

    return pathRef.getDownloadURL();
  }

  @override
  Future<UploadedMedia?> uploadUnedited(
    File file, {
    required String fileName,
  }) async {
    final userId = _session.userId;

    final storageRef = FirebaseStorage.instance.ref();

    final current = DateTime.now();
    final uploadFileId = format.format(current);

    final fileExtension = extension(fileName);

    final path =
        '/userTemporaryMedia/unedited/$userId/$uploadFileId$fileExtension';

    final pathRef = storageRef.child(path);

    try {
      await pathRef.putFile(file);
    } on FirebaseException catch (error) {
      if (error.code == 'unauthorized') {
        // ファイルサイズが制限よりも大きい
        return null;
      }

      rethrow;
    }

    final url = await pathRef.getDownloadURL();

    return UploadedMedia(id: uploadFileId, extension: fileExtension, url: url);
  }

  @override
  Future<UploadedMedia?> uploadEdited(
    File file, {
    required String fileName,
  }) async {
    final userId = _session.userId;

    final storageRef = FirebaseStorage.instance.ref();

    final current = DateTime.now();
    final uploadFileId = format.format(current);

    final fileExtension = extension(fileName);

    final path =
        '/userTemporaryMedia/edited/$userId/$uploadFileId$fileExtension';

    final pathRef = storageRef.child(path);

    try {
      await pathRef.putFile(file);
    } on FirebaseException catch (error) {
      if (error.code == 'unauthorized') {
        // ファイルサイズが制限よりも大きい
        return null;
      }

      rethrow;
    }

    final url = await pathRef.getDownloadURL();

    return UploadedMedia(id: uploadFileId, extension: fileExtension, url: url);
  }
}
