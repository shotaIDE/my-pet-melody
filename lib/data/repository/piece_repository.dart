import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/repository/local/piece_local_data_source.dart';
import 'package:rxdart/rxdart.dart';

class PieceRepository {
  PieceRepository({
    required PieceLocalDataSource localDataSource,
  }) : _local = localDataSource;

  final PieceLocalDataSource _local;
  final _pieces = BehaviorSubject<List<Piece>>();

  Future<void> dispose() async {
    await _pieces.close();
  }

  Future<Stream<List<Piece>>> getPiecesStream() async {
    if (_pieces.hasValue) {
      return _pieces.stream;
    }

    final storedPieces = await _local.getPieces();

    _pieces.add(storedPieces);

    return _pieces.stream;
  }

  Future<void> add(Piece piece) async {
    final pieces = _pieces.value..add(piece);

    await _local.setPieces(pieces);

    _pieces.add(pieces);
  }

  Future<void> replace(Piece replacedPiece) async {
    final pieces = _pieces.value;

    final index = pieces.indexWhere((piece) => piece.id == replacedPiece.id);

    pieces[index] = replacedPiece;

    await _local.setPieces(pieces);

    _pieces.add(pieces);
  }
}
