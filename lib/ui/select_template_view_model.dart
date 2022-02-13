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
      stoppedTemplates = PlayableConverter.getReplacedPlayableListToStopped(
        originalList: templates,
        id: currentPlayingPiece.id,
      );
    } else {
      stoppedTemplates = [...templates];
    }

    final playingTemplates = PlayableConverter.getReplacedPlayableList(
      originalList: stoppedTemplates,
      id: template.id,
      newPlayable:
          template.copyWith(status: const PlayStatus.playing(position: 0)),
    ).whereType<PlayableTemplate>().toList();

    state = state.copyWith(templates: playingTemplates);

    await _player.play(template.template.url);
  }

  Future<void> stop({required PlayableTemplate template}) async {
    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final stoppedTemplates = PlayableConverter.getReplacedPlayableListToStopped(
      originalList: templates,
      id: template.id,
    ).whereType<PlayableTemplate>().toList();

    state = state.copyWith(templates: stoppedTemplates);

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

    final currentPlayingTemplate = templates.firstWhereOrNull(
      (template) =>
          template.status.map(stop: (_) => false, playing: (_) => true),
    );
    if (currentPlayingTemplate == null) {
      return;
    }

    final newTemplate = currentPlayingTemplate.copyWith(
      status: PlayStatus.playing(position: positionRatio),
    );

    final positionUpdatedTemplates = PlayableConverter.getReplacedPlayableList(
      originalList: templates,
      id: currentPlayingTemplate.id,
      newPlayable: newTemplate,
    ).whereType<PlayableTemplate>().toList();

    state = state.copyWith(templates: positionUpdatedTemplates);
  }

  void _onAudioFinished() {
    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final currentPlayingTemplate = templates.firstWhereOrNull(
      (playablePiece) =>
          playablePiece.status.map(stop: (_) => false, playing: (_) => true),
    );
    if (currentPlayingTemplate == null) {
      return;
    }

    final stoppedTemplates = PlayableConverter.getReplacedPlayableListToStopped(
      originalList: templates,
      id: currentPlayingTemplate.id,
    ).whereType<PlayableTemplate>().toList();

    state = state.copyWith(templates: stoppedTemplates);
  }
}
