import 'package:meow_music/data/definitions/app_definitions.dart';
import 'package:meow_music/data/service/storage_service.dart';

class StorageServiceLocalFlask implements StorageService {
  @override
  Future<String> getDownloadUrl({required String path}) async {
    return '${AppDefinitions.serverOrigin}$path';
  }
}
