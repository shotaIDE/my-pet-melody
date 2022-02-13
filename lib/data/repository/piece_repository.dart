import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/piece_status.dart';
import 'package:rxdart/rxdart.dart';

class PieceRepository {
  final _pieces = BehaviorSubject<List<Piece>>.seeded([
    Piece(
      id: '01',
      name: 'Happy Birthday, その2',
      status: PieceStatus.generated(
        generated: DateTime.now().add(const Duration(days: -3)),
      ),
      url: 'about:blank',
    ),
    Piece(
      id: '01',
      name: 'Happy Birthday, その1',
      status: PieceStatus.generating(
        submitted: DateTime.now().add(const Duration(days: -2)),
      ),
      url: 'about:blank',
    ),
  ]);

  Future<void> dispose() async {
    await _pieces.close();
  }

  Stream<List<Piece>> getPiecesStream() {
    return _pieces.stream;
  }

  Future<void> add(Piece piece) async {
    final pieces = _pieces.value..add(piece);

    _pieces.add(pieces);
  }

  Future<void> replace(Piece replacedPiece) async {
    final pieces = _pieces.value;

    final index = pieces.indexWhere((piece) => piece.id == replacedPiece.id);

    pieces[index] = replacedPiece;

    _pieces.add(pieces);
  }
}
