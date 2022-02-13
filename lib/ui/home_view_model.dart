import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/usecase/piece_use_case.dart';
import 'package:meow_music/ui/home_state.dart';
import 'package:meow_music/ui/play_status.dart';
import 'package:meow_music/ui/playable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel({
    required PieceUseCase pieceUseCase,
  })  : _pieceUseCase = pieceUseCase,
        super(const HomeState()) {
    _setup();
  }

  final PieceUseCase _pieceUseCase;
  final _player = AudioPlayer();

  Duration? _currentAudioLength;
  StreamSubscription<List<Piece>>? _piecesSubscription;
  StreamSubscription<Duration>? _audioLengthSubscription;
  StreamSubscription<Duration>? _audioPositionSubscription;
  StreamSubscription<void>? _audioStoppedSubscription;

  @override
  Future<void> dispose() async {
    final tasks = [
      _piecesSubscription?.cancel(),
      _audioLengthSubscription?.cancel(),
      _audioPositionSubscription?.cancel(),
      _audioStoppedSubscription?.cancel(),
    ].whereType<Future<void>>().toList();

    await Future.wait<void>(tasks);

    super.dispose();
  }

  Future<void> play({required Playable piece}) async {
    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final currentPlayingPiece = pieces.firstWhereOrNull(
      (playablePiece) =>
          playablePiece.status.map(stop: (_) => false, playing: (_) => true),
    );
    final List<Playable> stoppedPieces;
    if (currentPlayingPiece != null) {
      stoppedPieces = PlayableConverter.getReplacedPlayablesToStopped(
        originalPieces: pieces,
        id: currentPlayingPiece.id,
      );
    } else {
      stoppedPieces = [...pieces];
    }

    final replacedPieces = PlayableConverter.getReplacedPlayables(
      originalPieces: stoppedPieces,
      id: piece.id,
      newPiece: piece.copyWith(status: const PlayStatus.playing(position: 0)),
    ).whereType<PlayablePiece>().toList();

    state = state.copyWith(pieces: replacedPieces);

    await _player.play(piece.url);
  }

  Future<void> stop({required PlayablePiece piece}) async {
    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final replaced = PlayableConverter.getReplacedPlayablesToStopped(
      originalPieces: pieces,
      id: piece.piece.id,
    ).whereType<PlayablePiece>().toList();

    state = state.copyWith(pieces: replaced);

    await _player.stop();
  }

  Future<void> share({required Piece piece}) async {
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

  Future<void> _setup() async {
    final piecesStream = await _pieceUseCase.getPiecesStream();
    _piecesSubscription = piecesStream.listen((pieces) {
      final playablePieces = pieces
          .map(
            (piece) => Playable.piece(
              status: const PlayStatus.stop(),
              piece: piece,
            ),
          )
          .whereType<PlayablePiece>()
          .toList();
      state = state.copyWith(pieces: playablePieces);
    });

    _audioLengthSubscription = _player.onDurationChanged.listen((duration) {
      _currentAudioLength = duration;
    });

    _audioPositionSubscription =
        _player.onAudioPositionChanged.listen(_onAudioPositionReceived);

    _audioStoppedSubscription = _player.onPlayerCompletion.listen((_) {
      _onAudioFinished();
    });
  }

  void _onAudioPositionReceived(Duration position) {
    final length = _currentAudioLength;
    if (length == null) {
      return;
    }

    final lengthSeconds = length.inMilliseconds;
    final positionSeconds = position.inMilliseconds;

    final positionRatio = positionSeconds / lengthSeconds;

    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final currentPlayingPiece = pieces.firstWhereOrNull(
      (playablePiece) =>
          playablePiece.status.map(stop: (_) => false, playing: (_) => true),
    );
    if (currentPlayingPiece == null) {
      return;
    }

    final newPiece = currentPlayingPiece.copyWith(
      status: PlayStatus.playing(position: positionRatio),
    );

    final replaced = PlayableConverter.getReplacedPlayables(
      originalPieces: pieces,
      id: currentPlayingPiece.piece.id,
      newPiece: newPiece,
    ).whereType<PlayablePiece>().toList();

    state = state.copyWith(pieces: replaced);
  }

  void _onAudioFinished() {
    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final currentPlayingPiece = pieces.firstWhereOrNull(
      (playablePiece) =>
          playablePiece.status.map(stop: (_) => false, playing: (_) => true),
    );
    if (currentPlayingPiece == null) {
      return;
    }

    final replaced = PlayableConverter.getReplacedPlayablesToStopped(
      originalPieces: pieces,
      id: currentPlayingPiece.piece.id,
    ).whereType<PlayablePiece>().toList();

    state = state.copyWith(pieces: replaced);
  }
}
