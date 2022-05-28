import 'package:collection/collection.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/database_service.dart';
import 'package:meow_music/data/service/storage_service.dart';

class PieceUseCase {
  const PieceUseCase({
    required AuthService authService,
    required DatabaseService databaseService,
    required StorageService storageService,
  })  : _authService = authService,
        _databaseService = databaseService,
        _storageService = storageService;

  final AuthService _authService;
  final DatabaseService _databaseService;
  final StorageService _storageService;

  Future<Stream<List<Piece>>> getPiecesStream() async {
    final session = await _authService.currentSessionWhenLoggedIn();
    final stream = _databaseService.piecesStream(userId: session.userId);

    return stream.asyncMap(
      (pieces) async {
        final converted = await Future.wait(
          pieces.map(
            (piece) => piece.map(
              generating: (piece) async => Piece.generating(
                id: piece.id,
                name: piece.name,
                submittedAt: piece.submittedAt,
              ),
              generated: (piece) async {
                final url = await _storageService.pieceDownloadUrl(
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
  }
}
