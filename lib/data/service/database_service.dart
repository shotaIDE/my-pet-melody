// ignore_for_file: prefer-match-file-name

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/login_session.dart';
import 'package:my_pet_melody/data/model/piece.dart';
import 'package:my_pet_melody/data/model/template.dart';
import 'package:my_pet_melody/data/service/auth_service.dart';

final StreamProvider<List<TemplateDraft>> templateDraftsProvider =
    StreamProvider(
  (_) {
    return FirebaseFirestore.instance.collection('systemMedia').snapshots().map(
          (snapshot) => snapshot.docs.map(
            (documentSnapshot) {
              final id = documentSnapshot.id;
              final data = documentSnapshot.data();
              final name = data['name'] as String;
              final publishedAtTimestamp = data['publishedAt'] as Timestamp;
              final publishedAt = publishedAtTimestamp.toDate();

              return TemplateDraft(
                id: id,
                name: name,
                publishedAt: publishedAt,
              );
            },
          ).toList(),
        );
  },
);

final StreamProviderFamily<List<LocalizedTemplateMetadata>, Locale>
    localizedTemplateMetadataListProvider =
    StreamProvider.family<List<LocalizedTemplateMetadata>, Locale>(
  (_, locale) {
    // Currently, we only care about the language code.
    // When we need to support languages varies by region,
    // we should consider the country code as well.
    final languageCode = locale.languageCode;

    return FirebaseFirestore.instance
        .collection('localized')
        .doc(languageCode)
        .collection('systemMedia')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (documentSnapshot) {
              final id = documentSnapshot.id;
              final data = documentSnapshot.data();
              final name = data['name'] as String;

              return LocalizedTemplateMetadata(
                id: id,
                name: name,
              );
            },
          ).toList(),
        );
  },
);

final StreamProvider<List<PieceDraft>> pieceDraftsProvider =
    StreamProvider((ref) {
  final session = ref.watch(sessionProvider);
  if (session == null) {
    return const Stream<List<PieceDraft>>.empty();
  }

  return FirebaseFirestore.instance
      .collection('userMedia')
      .doc(session.userId)
      .collection('generatedPieces')
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs.map(
          (snapshot) {
            final id = snapshot.id;
            final data = snapshot.data();
            final name = data['name'] as String;
            final thumbnailFileName = data['thumbnailFileName'] as String;
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
                movieFileName: movieFileName,
                thumbnailFileName: thumbnailFileName,
              );
            }
            return PieceDraft.generating(
              id: id,
              name: name,
              submittedAt: submittedAt,
              thumbnailFileName: thumbnailFileName,
            );
          },
        ).toList(),
      );
});

final FutureProvider<DatabaseActions> databaseActionsProvider = FutureProvider(
  (ref) async {
    final session = await ref.watch(sessionStreamProvider.future);

    return DatabaseActions(session: session);
  },
);

class DatabaseActions {
  const DatabaseActions({required LoginSession session}) : _session = session;

  final LoginSession _session;

  Future<void> sendRegistrationTokenIfNeeded(
    String registrationToken,
  ) async {
    final userId = _session.userId;

    final document = FirebaseFirestore.instance.collection('users').doc(userId);
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
