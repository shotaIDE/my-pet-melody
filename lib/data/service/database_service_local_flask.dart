import 'package:meow_music/data/service/database_service.dart';

class DatabaseServiceLocalFlask implements DatabaseService {
  @override
  Future<void> sendRegistrationTokenIfNeeded(
    String registrationToken, {
    required String userId,
  }) async {}
}
