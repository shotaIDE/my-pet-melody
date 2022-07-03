import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/detected_non_silent_segments.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/ui/model/play_status.dart';
import 'package:meow_music/ui/select_sounds_state.dart';

part 'player_choice.freezed.dart';

@freezed
class PlayerChoice with _$PlayerChoice {
  const factory PlayerChoice.piece({
    required PlayStatus status,
    required Piece piece,
  }) = PlayerChoicePiece;

  const factory PlayerChoice.template({
    required PlayStatus status,
    required Template template,
  }) = PlayerChoiceTemplate;

  const factory PlayerChoice.sound({
    required PlayStatus status,
    required SelectedSound sound,
  }) = PlayerChoiceSound;

  const factory PlayerChoice.trimmedMovie({
    required PlayStatus status,
    required int index,
    required NonSilentSegment segment,
    @Default(null) String? path,
    @Default(null) String? thumbnailPath,
  }) = PlayerChoiceTrimmedMovie;
}

extension PlayerChoiceGetter on PlayerChoice {
  String get id {
    return when(
      piece: (_, piece) => piece.id,
      template: (_, template) => template.id,
      sound: (_, sound) => sound.id,
      trimmedMovie: (_, index, __, ___, ____) => '$index',
    );
  }

  String? get uri {
    return when(
      piece: (_, piece) =>
          piece.mapOrNull(generated: (generated) => generated.url),
      template: (_, template) => template.url,
      sound: (_, sound) => sound.whenOrNull(
        uploaded: (_, __, ___, remoteFileName) => remoteFileName,
      ),
      trimmedMovie: (_, __, ___, path, ____) => path,
    );
  }
}

extension PlayerChoiceConverter on PlayerChoice {
  static List<PlayerChoice>? getStoppedOrNull({
    required List<PlayerChoice> originalList,
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

  static List<PlayerChoice>? getPositionUpdatedOrNull({
    required List<PlayerChoice> originalList,
    required double position,
  }) {
    final playing = originalList.firstWhereOrNull(
      (template) =>
          template.status.map(stop: (_) => false, playing: (_) => true),
    );
    if (playing == null) {
      return null;
    }

    return getTargetStatusReplaced(
      originalList: originalList,
      targetId: playing.id,
      newStatus: PlayStatus.playing(position: position),
    );
  }

  static List<PlayerChoice> getTargetStopped({
    required List<PlayerChoice> originalList,
    required String targetId,
  }) {
    return getTargetStatusReplaced(
      originalList: originalList,
      targetId: targetId,
      newStatus: const PlayStatus.stop(),
    );
  }

  static List<PlayerChoice> getTargetStatusReplaced({
    required List<PlayerChoice> originalList,
    required String targetId,
    required PlayStatus newStatus,
  }) {
    final index = originalList.indexWhere((piece) => piece.id == targetId);

    final choice = originalList[index];

    final replacedChoice = choice.copyWith(status: newStatus);

    final list = [...originalList];

    list[index] = replacedChoice;

    return list;
  }
}
