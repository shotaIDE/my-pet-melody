import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/database_provider.dart';

final templatesProvider = StreamProvider((ref) {
  final templateDraftsStream = ref.watch(templateDraftsProvider.stream);
  final storageService = ref.read(storageServiceProvider);

  return templateDraftsStream.asyncMap((templateDrafts) async {
    return Future.wait(
      templateDrafts.map((templateDraft) async {
        final url = await storageService.templateUrl(id: templateDraft.id);

        return Template(
          id: templateDraft.id,
          name: templateDraft.name,
          url: url,
        );
      }),
    );
  });
});

final piecesProvider = StreamProvider((ref) {
  final storageService = ref.read(storageServiceProvider);
  final session = ref.watch(sessionProvider);
  final pieceDraftsStream = ref.watch(pieceDraftsProvider.stream);

  if (session == null) {
    return const Stream<List<Piece>>.empty();
  }

  return pieceDraftsStream.asyncMap(
    (pieceDrafts) async {
      final converted = await Future.wait(
        pieceDrafts.map(
          (piece) => piece.map(
            generating: (piece) async => Piece.generating(
              id: piece.id,
              name: piece.name,
              submittedAt: piece.submittedAt,
            ),
            generated: (piece) async {
              final url = await storageService.pieceDownloadUrl(
                fileName: piece.fileName,
                userId: session.userId,
              );

              return Piece.generated(
                id: piece.id,
                name: piece.name,
                generatedAt: piece.generatedAt,
                url: url,
              );
            },
          ),
        ),
      );

      return converted.sorted(
        (a, b) {
          final dateTimeA = a.map(
            generating: (generating) => generating.submittedAt,
            generated: (generated) => generated.generatedAt,
          );

          final dateTimeB = b.map(
            generating: (generating) => generating.submittedAt,
            generated: (generated) => generated.generatedAt,
          );

          return dateTimeB.compareTo(dateTimeA);
        },
      );
    },
  );
});
