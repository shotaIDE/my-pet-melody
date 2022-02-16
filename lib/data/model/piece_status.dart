import 'package:freezed_annotation/freezed_annotation.dart';

part 'piece_status.freezed.dart';
part 'piece_status.g.dart';

@freezed
class PieceStatus with _$PieceStatus {
  const factory PieceStatus.generating({
    required DateTime submitted,
  }) = _PieceStatusGenerating;

  const factory PieceStatus.generated({
    required DateTime generated,
  }) = _PieceStatusGenerated;

  factory PieceStatus.fromJson(Map<String, dynamic> json) =>
      _$PieceStatusFromJson(json);
}
