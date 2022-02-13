import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/ui/play_status.dart';

part 'playable.freezed.dart';

@freezed
class Playable with _$Playable {
  const factory Playable.piece({
    required PlayStatus status,
    required Piece piece,
  }) = PlayablePiece;

  const factory Playable.template({
    required PlayStatus status,
    required Template template,
  }) = PlayableTemplate;
}

extension PlayableGetter on Playable {
  String get id {
    return when(
      piece: (_, piece) => piece.id,
      template: (_, template) => template.id,
    );
  }

  String get url {
    return when(
      piece: (_, piece) => piece.url,
      template: (_, template) => template.url,
    );
  }
}

extension PlayableConverter on Playable {
  static List<Playable> getReplacedPlayablesToStopped({
    required List<Playable> originalPieces,
    required String id,
  }) {
    final target = originalPieces.firstWhere((piece) => piece.id == id);

    final newPiece = target.copyWith(status: const PlayStatus.stop());

    return getReplacedPlayables(
      originalPieces: originalPieces,
      id: id,
      newPiece: newPiece,
    );
  }

  static List<Playable> getReplacedPlayables({
    required List<Playable> originalPieces,
    required String id,
    required Playable newPiece,
  }) {
    final index = originalPieces.indexWhere((piece) => piece.id == id);

    final pieces = [...originalPieces];

    pieces[index] = newPiece;

    return pieces;
  }
}
