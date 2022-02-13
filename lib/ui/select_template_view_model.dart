import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/play_status.dart';
import 'package:meow_music/ui/playable.dart';
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

  Future<void> play({required PlayableTemplate template}) async {
    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final currentPlayingPiece = templates.firstWhereOrNull(
      (playablePiece) =>
          playablePiece.status.map(stop: (_) => false, playing: (_) => true),
    );
    final List<Playable> stoppedTemplates;
    if (currentPlayingPiece != null) {
      stoppedTemplates = PlayableConverter.getReplacedPlayablesToStopped(
        originalPieces: templates,
        id: currentPlayingPiece.template.id,
      );
    } else {
      stoppedTemplates = [...templates];
    }

    final replacedPieces = PlayableConverter.getReplacedPlayables(
      originalPieces: stoppedTemplates,
      id: template.template.id,
      newPiece:
          template.copyWith(status: const PlayStatus.playing(position: 0)),
    ).whereType<PlayableTemplate>().toList();

    state = state.copyWith(templates: replacedPieces);

    await _player.play(template.template.url);
  }

  Future<void> stop({required PlayableTemplate piece}) async {
    final pieces = state.templates;
    if (pieces == null) {
      return;
    }

    final replaced = PlayableConverter.getReplacedPlayablesToStopped(
      originalPieces: pieces,
      id: piece.template.id,
    ).whereType<PlayableTemplate>().toList();

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

    final replaced = PlayableConverter.getReplacedPlayables(
      originalPieces: templates,
      id: currentPlayingPiece.template.id,
      newPiece: newPiece,
    ).whereType<PlayableTemplate>().toList();

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

    final replaced = PlayableConverter.getReplacedPlayablesToStopped(
      originalPieces: pieces,
      id: currentPlayingPiece.template.id,
    ).whereType<PlayableTemplate>().toList();

    state = state.copyWith(templates: replaced);
  }
}
