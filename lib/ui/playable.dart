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
