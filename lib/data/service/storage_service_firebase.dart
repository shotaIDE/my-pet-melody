import 'package:firebase_storage/firebase_storage.dart';
import 'package:meow_music/data/service/storage_service.dart';

class StorageServiceFirebase implements StorageService {
  @override
  Future<String> getDownloadUrl({required String path}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final pathRef = storageRef.child(path);
    return pathRef.getDownloadURL();
  }
}
