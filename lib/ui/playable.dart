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
  static List<Playable> getReplacedPlayableListToStopped({
    required List<Playable> originalList,
    required String id,
  }) {
    final target = originalList.firstWhere((piece) => piece.id == id);

    final newPlayable = target.copyWith(status: const PlayStatus.stop());

    return getReplacedPlayableList(
      originalList: originalList,
      id: id,
      newPlayable: newPlayable,
    );
  }

  static List<Playable> getReplacedPlayableList({
    required List<Playable> originalList,
    required String id,
    required Playable newPlayable,
  }) {
    final index = originalList.indexWhere((piece) => piece.id == id);

    final list = [...originalList];

    list[index] = newPlayable;

    return list;
  }
}
