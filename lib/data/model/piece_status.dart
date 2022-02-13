import 'package:freezed_annotation/freezed_annotation.dart';

part 'piece_status.freezed.dart';

@freezed
class PieceStatus with _$PieceStatus {
  const factory PieceStatus.generating({
    required DateTime submitted,
  }) = _PieceStatusGenerating;

  const factory PieceStatus.generated({
    required DateTime generated,
  }) = _PieceStatusGenerated;
}
