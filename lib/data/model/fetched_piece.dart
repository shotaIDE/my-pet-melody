import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetched_piece.freezed.dart';

@freezed
abstract class FetchedPiece with _$FetchedPiece {
  const factory FetchedPiece({
    required String id,
    required String url,
  }) = _FetchedPiece;
}
