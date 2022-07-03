import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/definitions/types.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/usecase/piece_use_case.dart';
import 'package:meow_music/ui/helper/audio_position_helper.dart';
import 'package:meow_music/ui/home_state.dart';
import 'package:meow_music/ui/model/play_status.dart';
import 'package:meow_music/ui/model/player_choice.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel({
    required Listener listener,
  }) : super(const HomeState()) {
    _setup(listener: listener);
  }

  final _player = AudioPlayer();

  Duration? _currentAudioDuration;
  StreamSubscription<List<Piece>>? _piecesSubscription;
  StreamSubscription<Duration>? _audioDurationSubscription;
  StreamSubscription<Duration>? _audioPositionSubscription;
  StreamSubscription<void>? _audioStoppedSubscription;

  @override
  Future<void> dispose() async {
    final tasks = [
      _piecesSubscription?.cancel(),
      _audioDurationSubscription?.cancel(),
      _audioPositionSubscription?.cancel(),
      _audioStoppedSubscription?.cancel(),
    ].whereType<Future<void>>().toList();

    await Future.wait<void>(tasks);

    super.dispose();
  }

  Future<void> play({required PlayerChoicePiece piece}) async {
    final url = piece.uri;
    if (url == null) {
      return;
    }

    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final stoppedList =
        PlayerChoiceConverter.getStoppedOrNull(originalList: pieces) ??
            [...pieces];

    final playingList = PlayerChoiceConverter.getTargetReplaced(
      originalList: stoppedList,
      targetId: piece.id,
      newPlayable:
          piece.copyWith(status: const PlayStatus.playing(position: 0)),
    );

    state = state.copyWith(
      pieces: playingList.whereType<PlayerChoicePiece>().toList(),
    );

    await _player.play(url);
  }

  Future<void> stop({required PlayerChoicePiece piece}) async {
    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final stoppedList = PlayerChoiceConverter.getTargetStopped(
      originalList: pieces,
      targetId: piece.id,
    );

    state = state.copyWith(
      pieces: stoppedList.whereType<PlayerChoicePiece>().toList(),
    );

    await _player.stop();
  }

  Future<void> share({required PieceGenerated piece}) async {
    state = state.copyWith(isProcessing: true);

    final dio = Dio();

    final parentDirectory = await getApplicationDocumentsDirectory();
    final parentPath = parentDirectory.path;
    final directory = Directory('$parentPath/${piece.name}');
    await directory.create(recursive: true);

    final path = '${directory.path}/${piece.name}.mp3';

    await dio.download(piece.url, path);

    await Share.shareFiles([path]);

    state = state.copyWith(isProcessing: false);
  }

  Future<void> beforeHideScreen() async {
    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final stoppedList =
        PlayerChoiceConverter.getStoppedOrNull(originalList: pieces);

    if (stoppedList != null) {
      state = state.copyWith(
        pieces: stoppedList.whereType<PlayerChoicePiece>().toList(),
      );
    }

    await _player.stop();
  }

  Future<void> _setup({required Listener listener}) async {
    listener<Future<List<Piece>>>(
      piecesProvider.future,
      (_, next) async {
        final pieceDataList = await next;

        final pieces = pieceDataList
            .map(
              (piece) => PlayerChoicePiece(
                status: const PlayStatus.stop(),
                piece: piece,
              ),
            )
            .toList();

        final previousPlaying = state.pieces?.firstWhereOrNull(
          (piece) => piece.status.map(stop: (_) => false, playing: (_) => true),
        );

        final List<PlayerChoicePiece> fixedPieces;
        if (previousPlaying != null) {
          fixedPieces = PlayerChoiceConverter.getTargetReplaced(
            originalList: pieces,
            targetId: previousPlaying.id,
            // TODO(ide): Use new properties except the `PlayStatus`
            newPlayable: previousPlaying,
          ).whereType<PlayerChoicePiece>().toList();
        } else {
          fixedPieces = pieces;
        }

        state = state.copyWith(
          pieces: fixedPieces,
        );
      },
      fireImmediately: true,
    );

    _audioDurationSubscription = _player.onDurationChanged.listen((duration) {
      _currentAudioDuration = duration;
    });

    _audioPositionSubscription =
        _player.onAudioPositionChanged.listen(_onAudioPositionReceived);

    _audioStoppedSubscription = _player.onPlayerCompletion.listen((_) {
      _onAudioFinished();
    });
  }

  void _onAudioPositionReceived(Duration position) {
    final duration = _currentAudioDuration;
    if (duration == null) {
      return;
    }

    final positionRatio = AudioPositionHelper.getPositionRatio(
      duration: duration,
      position: position,
    );

    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final positionUpdatedList = PlayerChoiceConverter.getPositionUpdatedOrNull(
      originalList: pieces,
      position: positionRatio,
    );
    if (positionUpdatedList == null) {
      return;
    }

    state = state.copyWith(
      pieces: positionUpdatedList.whereType<PlayerChoicePiece>().toList(),
    );
  }

  void _onAudioFinished() {
    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
      originalList: pieces,
    );
    if (stoppedList == null) {
      return;
    }

    state = state.copyWith(
      pieces: stoppedList.whereType<PlayerChoicePiece>().toList(),
    );
  }
}
