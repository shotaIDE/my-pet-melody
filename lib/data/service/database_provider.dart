// ignore_for_file: prefer-match-file-name

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:rxdart/rxdart.dart';

final templateDraftsProvider = StreamProvider(
  (_) {
    return FirebaseFirestore.instance.collection('systemMedia').snapshots().map(
          (snapshot) => snapshot.docs.map(
            (documentSnapshot) {
              final id = documentSnapshot.id;
              final name = documentSnapshot.get('name') as String;

              return TemplateDraft(
                id: id,
                name: name,
              );
            },
          ).toList(),
        );
  },
);

final pieceDraftsProvider = StreamProvider((ref) {
  final userIdStream = ref.watch(userIdProvider.stream);

  return userIdStream.switchMap(
    (userId) => FirebaseFirestore.instance
        .collection('userMedia')
        .doc(userId)
        .collection('generatedPieces')
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs.map(
            (snapshot) {
              final id = snapshot.id;
              final data = snapshot.data();
              final name = data['name'] as String;
              final movieFileName = data.containsKey('movieFileName')
                  ? data['movieFileName'] as String
                  : null;
              final submittedAtTimestamp = data['submittedAt'] as Timestamp;
              final submittedAt = submittedAtTimestamp.toDate();
              final generatedAtTimestamp = data.containsKey('generatedAt')
                  ? data['generatedAt'] as Timestamp
                  : null;
              final generatedAt = generatedAtTimestamp?.toDate();

              if (movieFileName != null && generatedAt != null) {
                return PieceDraft.generated(
                  id: id,
                  name: name,
                  generatedAt: generatedAt,
                  fileName: movieFileName,
                );
              }
              return PieceDraft.generating(
                id: id,
                name: name,
                submittedAt: submittedAt,
              );
            },
          ).toList(),
        ),
  );
});

final registrationTokenSenderProvider = Provider(
  (ref) => RegistrationTokenSender(reader: ref.read),
);

class RegistrationTokenSender {
  const RegistrationTokenSender({required Reader reader}) : _reader = reader;

  final Reader _reader;

  Future<void> sendRegistrationTokenIfNeeded(
    String registrationToken,
  ) async {
    final userId = await _reader(userIdProvider.future);

    final db = FirebaseFirestore.instance;

    final document = db.collection('users').doc(userId);
    final snapshot = await document.get();
    final user = snapshot.data();
    if (user != null && user.containsKey('registrationTokens')) {
      final registrationTokens = user['registrationTokens'] as List<dynamic>;
      if (registrationTokens.contains(registrationToken)) {
        return;
      }
    }

    await document.set(<String, dynamic>{
      'registrationTokens': FieldValue.arrayUnion(
        <String>[registrationToken],
      ),
    });
  }
}
