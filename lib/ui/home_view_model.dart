import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/usecase/piece_use_case.dart';
import 'package:meow_music/ui/helper/audio_position_helper.dart';
import 'package:meow_music/ui/home_screen.dart';
import 'package:meow_music/ui/home_state.dart';
import 'package:meow_music/ui/model/play_status.dart';
import 'package:meow_music/ui/model/player_choice.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

final homePlayerChoicesProvider =
    FutureProvider.autoDispose<List<PlayerChoicePiece>?>((ref) async {
  final pieces = await ref.watch(piecesProvider.future);
  final homeState = ref.watch(homeViewModelProvider);

  final originalList = pieces
      .map(
        (piece) => PlayerChoicePiece(
          status: const PlayStatus.stop(),
          piece: piece,
        ),
      )
      .toList();

  final playing = homeState.playing;
  if (playing == null) {
    return originalList;
  }

  return PlayerChoiceConverter.getTargetReplaced(
    originalList: originalList,
    targetId: playing.id,
    newPlayable: playing.copyWith(
      status: const PlayStatus.playing(position: 0),
    ),
  ).whereType<PlayerChoicePiece>().toList();
});

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(const HomeState()) {
    _setup();
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

    state = state.copyWith(
      playing: piece.copyWith(
        status: const PlayStatus.playing(position: 0),
      ),
    );

    await _player.play(url);
  }

  Future<void> stop() async {
    state = state.copyWith(
      playing: null,
    );

    await _player.stop();
  }

  Future<void> beforeHideScreen() async {
    await stop();
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

  Future<void> _setup() async {
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

    final piece = state.playing;
    if (piece == null) {
      return;
    }

    final newPlayable = piece.copyWith(
      status: PlayStatus.playing(position: positionRatio),
    );

    state = state.copyWith(
      playing: newPlayable,
    );
  }

  void _onAudioFinished() {
    state = state.copyWith(
      playing: null,
    );
  }
}
