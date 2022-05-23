import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/service/database_service.dart';

class DatabaseServiceFirebase implements DatabaseService {
  @override
  Future<List<TemplateDraft>> getTemplates() async {
    return [
      const TemplateDraft(
        id: 'happy_birthday',
        name: 'Happy Birthday',
        path: 'temp/systemMedia/happy_birthday/template.wav',
      ),
    ];
  }
}
