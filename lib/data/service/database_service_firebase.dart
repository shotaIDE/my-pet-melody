import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/service/database_service.dart';

class DatabaseServiceFirebase implements DatabaseService {
  @override
  Future<List<TemplateDraft>> getTemplates() async {
    final db = FirebaseFirestore.instance;

    final collection = db.collection('systemMedia');

    // await collection.add(<String, String>{
    //   'name': 'Happy Birthday',
    // });

    final collectionSnapshot = await collection.get();

    return collectionSnapshot.docs.map((documentSnapshot) {
      final id = documentSnapshot.id;
      final name = documentSnapshot.get('name') as String;

      return TemplateDraft(
        id: id,
        name: name,
        path: 'systemMedia/templates/$id/template.wav',
      );
    }).toList();
  }
}
