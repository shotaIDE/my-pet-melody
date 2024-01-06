import 'package:freezed_annotation/freezed_annotation.dart';

part 'piece.freezed.dart';
part 'piece.g.dart';

@freezed
class Piece with _$Piece {
  const factory Piece.generating({
    required String id,
    required String name,
    required DateTime submittedAt,
    required String thumbnailUrl,
  }) = PieceGenerating;

  const factory Piece.generated({
    required String id,
    required String name,
    required DateTime generatedAt,
    required DateTime? availableUntil,
    required String movieUrl,
    required String movieExtension,
    required String thumbnailUrl,
  }) = PieceGenerated;

  const factory Piece.expired({
    required String id,
    required String name,
    required DateTime generatedAt,
    required DateTime? availableUntil,
    required String thumbnailUrl,
  }) = PieceExpired;

  factory Piece.fromJson(Map<String, dynamic> json) => _$PieceFromJson(json);
}

@freezed
class PieceDraft with _$PieceDraft {
  const factory PieceDraft.generating({
    required String id,
    required String name,
    required DateTime submittedAt,
    required String thumbnailFileName,
  }) = _PieceDraftGenerating;

  const factory PieceDraft.generated({
    required String id,
    required String name,
    required DateTime generatedAt,
    required String movieFileName,
    required String thumbnailFileName,
  }) = _PieceDraftGenerated;
}
