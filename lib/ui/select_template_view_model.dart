import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/helper/audio_position_helper.dart';
import 'package:meow_music/ui/model/play_status.dart';
import 'package:meow_music/ui/model/player_choice.dart';
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

  Duration? _currentAudioDuration;
  StreamSubscription<Duration>? _audioDurationSubscription;
  StreamSubscription<Duration>? _audioPositionSubscription;
  StreamSubscription<void>? _audioStoppedSubscription;

  @override
  Future<void> dispose() async {
    final tasks = [
      _audioDurationSubscription?.cancel(),
      _audioPositionSubscription?.cancel(),
      _audioStoppedSubscription?.cancel(),
    ].whereType<Future<void>>().toList();

    await Future.wait<void>(tasks);

    super.dispose();
  }

  Future<void> play({required PlayerChoiceTemplate template}) async {
    final url = template.uri;
    if (url == null) {
      return;
    }

    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
          originalList: templates,
        ) ??
        [...templates];

    final playingList = PlayerChoiceConverter.getTargetReplaced(
      originalList: stoppedList,
      targetId: template.id,
      newPlayable:
          template.copyWith(status: const PlayStatus.playing(position: 0)),
    );

    state = state.copyWith(
      templates: playingList.whereType<PlayerChoiceTemplate>().toList(),
    );

    await _player.play(url);
  }

  Future<void> stop({required PlayerChoiceTemplate template}) async {
    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final stoppedList = PlayerChoiceConverter.getTargetStopped(
      originalList: templates,
      targetId: template.id,
    );

    state = state.copyWith(
      templates: stoppedList.whereType<PlayerChoiceTemplate>().toList(),
    );

    await _player.stop();
  }

  Future<void> beforeHideScreen() async {
    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final stoppedList =
        PlayerChoiceConverter.getStoppedOrNull(originalList: templates);

    if (stoppedList != null) {
      state = state.copyWith(
        templates: stoppedList.whereType<PlayerChoiceTemplate>().toList(),
      );
    }

    await _player.stop();
  }

  Future<void> _setup() async {
    final templates = await _submissionUseCase.getTemplates();
    final playableTemplates = templates
        .map(
          (template) => PlayerChoiceTemplate(
            template: template,
            status: const PlayStatus.stop(),
          ),
        )
        .toList();
    state = state.copyWith(templates: playableTemplates);

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

    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final positionUpdatedList = PlayerChoiceConverter.getPositionUpdatedOrNull(
      originalList: templates,
      position: positionRatio,
    );
    if (positionUpdatedList == null) {
      return;
    }

    state = state.copyWith(
      templates: positionUpdatedList.whereType<PlayerChoiceTemplate>().toList(),
    );
  }

  void _onAudioFinished() {
    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
      originalList: templates,
    );
    if (stoppedList == null) {
      return;
    }

    state = state.copyWith(
      templates: stoppedList.whereType<PlayerChoiceTemplate>().toList(),
    );
  }
}
