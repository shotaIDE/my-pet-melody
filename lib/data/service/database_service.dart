import 'package:meow_music/data/model/template.dart';

abstract class DatabaseService {
  Future<List<TemplateDraft>> getTemplates();

  Future<void> sendRegistrationTokenIfNeeded(
    String registrationToken, {
    required String userId,
  });
}
