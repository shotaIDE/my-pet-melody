import 'package:freezed_annotation/freezed_annotation.dart';

part 'piece_status.freezed.dart';
part 'piece_status.g.dart';

@freezed
sealed class PieceStatus with _$PieceStatus {
  const factory PieceStatus.generating({
    required DateTime submitted,
  }) = PieceStatusGenerating;

  const factory PieceStatus.generated({
    required DateTime generated,
  }) = PieceStatusGenerated;

  factory PieceStatus.fromJson(Map<String, dynamic> json) =>
      _$PieceStatusFromJson(json);
}
