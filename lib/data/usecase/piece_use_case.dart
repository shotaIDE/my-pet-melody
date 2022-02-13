import 'package:collection/collection.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/repository/piece_repository.dart';

class PieceUseCase {
  const PieceUseCase({required PieceRepository repository})
      : _repository = repository;

  final PieceRepository _repository;

  Future<Stream<List<Piece>>> getPiecesStream() async {
    final stream = await _repository.getPiecesStream();

    return stream.map(
      (pieces) => pieces.sorted(
        (a, b) {
          final dateTimeA = a.status.when(
            generating: (generating) => generating,
            generated: (generated) => generated,
          );

          final dateTimeB = b.status.when(
            generating: (generating) => generating,
            generated: (generated) => generated,
          );

          return dateTimeB.compareTo(dateTimeA);
        },
      ),
    );
  }
}
