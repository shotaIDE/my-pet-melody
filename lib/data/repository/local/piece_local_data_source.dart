import 'dart:convert';

import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/preference_key.dart';
import 'package:meow_music/data/service/preference_service.dart';

class PieceLocalDataSource {
  Future<List<Piece>> getPieces() async {
    final piecesJsonString = await PreferenceService.getString(
      PreferenceKey.temporaryPiecesJsonString,
    );

    if (piecesJsonString == null) {
      return [];
    }

    final dynamic pieces = jsonDecode(piecesJsonString);
    if (pieces is! List<dynamic>) {
      return [];
    }

    return pieces
        .whereType<Map<String, dynamic>>()
        .map(Piece.fromJson)
        .toList();
  }

  Future<void> setPieces(List<Piece> pieces) async {
    final jsonString = jsonEncode(pieces);

    await PreferenceService.setString(
      PreferenceKey.temporaryPiecesJsonString,
      value: jsonString,
    );
  }
}
