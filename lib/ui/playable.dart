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

extension PlayableListConverter on Playable {
  static List<Playable>? getStoppedOrNull({
    required List<Playable> originalList,
  }) {
    final playing = originalList.firstWhereOrNull(
      (playable) =>
          playable.status.map(stop: (_) => false, playing: (_) => true),
    );

    if (playing == null) {
      return null;
    }

    return getTargetStopped(
      originalList: originalList,
      targetId: playing.id,
    );
  }

  static List<Playable> getTargetStopped({
    required List<Playable> originalList,
    required String targetId,
  }) {
    final target = originalList.firstWhere((piece) => piece.id == targetId);

    final newPlayable = target.copyWith(status: const PlayStatus.stop());

    return getTargetReplaced(
      originalList: originalList,
      targetId: targetId,
      newPlayable: newPlayable,
    );
  }

  static List<Playable> getTargetReplaced({
    required List<Playable> originalList,
    required String targetId,
    required Playable newPlayable,
  }) {
    final index = originalList.indexWhere((piece) => piece.id == targetId);

    final list = [...originalList];

    list[index] = newPlayable;

    return list;
  }
}
