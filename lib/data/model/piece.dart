import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/piece_status.dart';

part 'piece.freezed.dart';

@freezed
class Piece with _$Piece {
  const factory Piece({
    required String id,
    required String name,
    required PieceStatus status,
    required String url,
  }) = _Piece;
}
