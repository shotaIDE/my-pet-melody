import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/repository/piece_repository.dart';

class PieceUseCase {
  const PieceUseCase({required PieceRepository repository})
      : _repository = repository;

  final PieceRepository _repository;

  Stream<List<Piece>> getPiecesStream() {
    return _repository.getPiecesStream();
  }
}
