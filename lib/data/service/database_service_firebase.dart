import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meow_music/data/model/piece.dart';
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

  @override
  Stream<List<PieceDraft>> piecesStream({required String userId}) {
    final db = FirebaseFirestore.instance;

    return db
        .collection('userMedia')
        .doc(userId)
        .collection('generatedPieces')
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs.map((snapshot) {
            final id = snapshot.id;
            final data = snapshot.data();
            final name = data['name'] as String;
            final movieFileName = data.keys.contains('movieFileName')
                ? data['movieFileName'] as String
                : null;
            final submittedAtTimestamp = data['submittedAt'] as Timestamp;
            final submittedAt = submittedAtTimestamp.toDate();
            final generatedAtTimestamp = data.keys.contains('generatedAt')
                ? data['generatedAt'] as Timestamp
                : null;
            final generatedAt = generatedAtTimestamp?.toDate();

            if (movieFileName != null && generatedAt != null) {
              return PieceDraft.generated(
                id: id,
                name: name,
                generatedAt: generatedAt,
                path: 'userMedia/$userId/generatedPieces/$id/$movieFileName',
              );
            }
            return PieceDraft.generating(
              id: id,
              name: name,
              submittedAt: submittedAt,
            );
          }).toList(),
        );
  }
}
