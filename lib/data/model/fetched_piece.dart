import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetched_piece.freezed.dart';

@freezed
class FetchedPiece with _$FetchedPiece {
  const factory FetchedPiece({
    required String id,
    required String url,
  }) = _FetchedPiece;
}

@freezed
class FetchedPieceDraft with _$FetchedPieceDraft {
  const factory FetchedPieceDraft({
    required String id,
    required String path,
  }) = _FetchedPieceDraft;
}
