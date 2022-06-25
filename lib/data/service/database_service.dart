abstract class DatabaseService {
  Future<void> sendRegistrationTokenIfNeeded(
    String registrationToken, {
    required String userId,
  });
}
