import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/service/database_service.dart';

final templatesProvider = FutureProvider((ref) async {
  final templateDrafts = await ref.watch(templateDraftsProvider.future);
  final storageService = await ref.watch(storageServiceProvider.future);

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

final piecesProvider = FutureProvider(
  (ref) async {
    final pieceDrafts = await ref.watch(pieceDraftsProvider.future);
    final storageService = await ref.read(storageServiceProvider.future);

    final converted = await Future.wait(
      pieceDrafts.map(
        (piece) => piece.map(
          generating: (piece) async => Piece.generating(
            id: piece.id,
            name: piece.name,
            submittedAt: piece.submittedAt,
          ),
          generated: (piece) async {
            final movieUrl = await storageService.pieceMovieDownloadUrl(
              fileName: piece.movieFileName,
            );

            final thumbnailUrl = await storageService.pieceThumbnailDownloadUrl(
              fileName: piece.thumbnailFileName,
            );

            return Piece.generated(
              id: piece.id,
              name: piece.name,
              generatedAt: piece.generatedAt,
              movieUrl: movieUrl,
              thumbnailUrl: thumbnailUrl,
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
