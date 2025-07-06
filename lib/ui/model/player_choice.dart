import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/data/model/movie_segmentation.dart';
import 'package:my_pet_melody/data/model/piece.dart';
import 'package:my_pet_melody/ui/model/localized_template.dart';
import 'package:my_pet_melody/ui/model/play_status.dart';
import 'package:my_pet_melody/ui/select_sounds_state.dart';

part 'player_choice.freezed.dart';

@freezed
class PlayerChoice with _$PlayerChoice {
  const factory PlayerChoice.piece({
    required PlayStatus status,
    required Piece piece,
  }) = PlayerChoicePiece;

  const factory PlayerChoice.template({
    required PlayStatus status,
    required LocalizedTemplate template,
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
      trimmedMovie: (_, index, _, _, _) => '$index',
    );
  }

  String? get uri {
    return when(
      piece: (_, piece) =>
          piece.mapOrNull(generated: (generated) => generated.movieUrl),
      template: (_, template) => template.musicUrl,
      sound: (_, sound) => sound.whenOrNull(
        uploaded: (_, _, _, remoteFileName) => remoteFileName,
      ),
      trimmedMovie: (_, _, _, path, _) => path,
    );
  }
}

extension PlayerChoiceConverter on PlayerChoice {
  static List<PlayerChoice>? getStoppedOrNull({
    required List<PlayerChoice> originalList,
  }) {
    final playing = originalList.firstWhereOrNull(
      (playable) => playable.status.map(
        stop: (_) => false,
        loadingMedia: (_) => true,
        playing: (_) => true,
      ),
    );

    if (playing == null) {
      return null;
    }

    return getTargetStopped(originalList: originalList, targetId: playing.id);
  }

  static List<PlayerChoice>? getPositionUpdatedOrNull({
    required List<PlayerChoice> originalList,
    required double position,
  }) {
    final playing = originalList.firstWhereOrNull(
      (template) => template.status.map(
        stop: (_) => false,
        loadingMedia: (_) => true,
        playing: (_) => true,
      ),
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
