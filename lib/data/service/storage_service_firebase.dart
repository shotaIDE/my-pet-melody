import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/data/service/storage_service.dart';
import 'package:path/path.dart';

class StorageServiceFirebase implements StorageService {
  final format = DateFormat('yyyyMMddHHmmss');

  @override
  Future<String> getDownloadUrl({required String path}) async {
    return _getDownloadUrl(path: path);
  }

  @override
  Future<UploadedSound?> uploadOriginal(
    File file, {
    required String fileName,
    required String userId,
  }) async {
    final storageRef = FirebaseStorage.instance.ref();

    final current = DateTime.now();
    final uploadFileId = format.format(current);

    final fileExtension = extension(fileName);

    final path =
        '/userMedia/$userId/originalMovies/$uploadFileId$fileExtension';

    final pathRef = storageRef.child(path);

    await pathRef.putFile(file);

    final url = await _getDownloadUrl(path: path);

    return UploadedSound(id: uploadFileId, extension: fileExtension, url: url);
  }

  @override
  Future<UploadedSound?> uploadTrimmed(
    File file, {
    required String fileName,
    required String userId,
  }) async {
    final storageRef = FirebaseStorage.instance.ref();

    final current = DateTime.now();
    final uploadFileId = format.format(current);

    final fileExtension = extension(fileName);

    final path =
        '/userMedia/$userId/uploadedMovies/$uploadFileId$fileExtension';

    final pathRef = storageRef.child(path);

    await pathRef.putFile(file);

    final url = await _getDownloadUrl(path: path);

    return UploadedSound(id: uploadFileId, extension: fileExtension, url: url);
  }

  Future<String> _getDownloadUrl({required String path}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final pathRef = storageRef.child(path);
    return pathRef.getDownloadURL();
  }
}
