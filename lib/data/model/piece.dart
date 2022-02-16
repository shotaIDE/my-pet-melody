import 'package:freezed_annotation/freezed_annotation.dart';

part 'piece.freezed.dart';
part 'piece.g.dart';

@freezed
class Piece with _$Piece {
  const factory Piece.generating({
    required String id,
    required String name,
    required DateTime submittedAt,
  }) = PieceGenerating;

  const factory Piece.generated({
    required String id,
    required String name,
    required DateTime generatedAt,
    required String url,
  }) = PieceGenerated;

  factory Piece.fromJson(Map<String, dynamic> json) => _$PieceFromJson(json);
}
