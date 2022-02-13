import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/home_state.dart';
import 'package:meow_music/ui/select_template_state.dart';

class SelectTemplateViewModel extends StateNotifier<SelectTemplateState> {
  SelectTemplateViewModel({
    required SubmissionUseCase submissionUseCase,
  })  : _submissionUseCase = submissionUseCase,
        super(const SelectTemplateState()) {
    _setup();
  }

  final SubmissionUseCase _submissionUseCase;
  final _player = AudioPlayer();

  Duration? _currentAudioLength;
  StreamSubscription<Duration>? _audioLengthSubscription;
  StreamSubscription<Duration>? _audioPositionSubscription;
  StreamSubscription<void>? _audioStoppedSubscription;

  @override
  Future<void> dispose() async {
    final tasks = [
      _audioLengthSubscription?.cancel(),
      _audioPositionSubscription?.cancel(),
      _audioStoppedSubscription?.cancel(),
    ].whereType<Future<void>>().toList();

    await Future.wait<void>(tasks);

    super.dispose();
  }

  Future<void> play({required PlayableTemplate piece}) async {
    final pieces = state.templates;
    if (pieces == null) {
      return;
    }

    final currentPlayingPiece = pieces.firstWhereOrNull(
      (playablePiece) =>
          playablePiece.status.map(stop: (_) => false, playing: (_) => true),
    );
    final List<PlayableTemplate> stoppedPieces;
    if (currentPlayingPiece != null) {
      stoppedPieces = _getReplacedPiecesToStopped(
        originalPieces: pieces,
        id: currentPlayingPiece.template.id,
      );
    } else {
      stoppedPieces = [...pieces];
    }

    final replacedPieces = _getReplacedPieces(
      originalPieces: stoppedPieces,
      id: piece.template.id,
      newPiece: piece.copyWith(status: const PlayStatus.playing(position: 0)),
    );

    state = state.copyWith(templates: replacedPieces);

    await _player.play(piece.template.url);
  }

  Future<void> stop({required PlayableTemplate piece}) async {
    final pieces = state.templates;
    if (pieces == null) {
      return;
    }

    final replaced = _getReplacedPiecesToStopped(
      originalPieces: pieces,
      id: piece.template.id,
    );

    state = state.copyWith(templates: replaced);

    await _player.stop();
  }

  Future<void> _setup() async {
    final templates = await _submissionUseCase.getTemplates();
    final playableTemplates = templates
        .map(
          (template) => PlayableTemplate(
            template: template,
            status: const PlayStatus.stop(),
          ),
        )
        .toList();
    state = state.copyWith(templates: playableTemplates);

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

    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final currentPlayingPiece = templates.firstWhereOrNull(
      (playablePiece) =>
          playablePiece.status.map(stop: (_) => false, playing: (_) => true),
    );
    if (currentPlayingPiece == null) {
      return;
    }

    final newPiece = currentPlayingPiece.copyWith(
      status: PlayStatus.playing(position: positionRatio),
    );

    final replaced = _getReplacedPieces(
      originalPieces: templates,
      id: currentPlayingPiece.template.id,
      newPiece: newPiece,
    );

    state = state.copyWith(templates: replaced);
  }

  void _onAudioFinished() {
    final pieces = state.templates;
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

    final replaced = _getReplacedPiecesToStopped(
      originalPieces: pieces,
      id: currentPlayingPiece.template.id,
    );

    state = state.copyWith(templates: replaced);
  }

  List<PlayableTemplate> _getReplacedPiecesToStopped({
    required List<PlayableTemplate> originalPieces,
    required String id,
  }) {
    final target =
        originalPieces.firstWhere((piece) => piece.template.id == id);

    final newPiece = target.copyWith(status: const PlayStatus.stop());

    return _getReplacedPieces(
      originalPieces: originalPieces,
      id: id,
      newPiece: newPiece,
    );
  }

  List<PlayableTemplate> _getReplacedPieces({
    required List<PlayableTemplate> originalPieces,
    required String id,
    required PlayableTemplate newPiece,
  }) {
    final index = originalPieces.indexWhere((piece) => piece.template.id == id);

    final pieces = [...originalPieces];

    pieces[index] = newPiece;

    return pieces;
  }
}
