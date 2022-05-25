import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/service/database_service.dart';

class DatabaseServiceFirebase implements DatabaseService {
  @override
  Future<List<TemplateDraft>> getTemplates() async {
    final db = FirebaseFirestore.instance;

    final template = <String, dynamic>{
      'name': 'Happy Birthday',
    };

    final collection = db.collection('systemMedia');
    await collection.add(template);

    return [
      const TemplateDraft(
        id: 'happy_birthday',
        name: 'Happy Birthday',
        path: 'systemMedia/templates/happy_birthday/template.wav',
      ),
    ];
  }
}
