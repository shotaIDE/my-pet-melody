import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/helper/audio_position_helper.dart';
import 'package:meow_music/ui/model/play_status.dart';
import 'package:meow_music/ui/model/player_choice.dart';
import 'package:meow_music/ui/request_push_notification_permission_state.dart';
import 'package:meow_music/ui/select_sounds_state.dart';
import 'package:path/path.dart';

class SelectSoundsViewModel extends StateNotifier<SelectSoundsState> {
  SelectSoundsViewModel({
    required Template selectedTemplate,
    required SubmissionUseCase submissionUseCase,
  })  : _submissionUseCase = submissionUseCase,
        super(
          SelectSoundsState(
            template: PlayerChoiceTemplate(
              template: selectedTemplate,
              status: const PlayStatus.stop(),
            ),
            sounds: List.generate(
              2,
              (index) => PlayerChoiceSound(
                status: const PlayStatus.stop(),
                sound: SelectedSoundNone(id: 'selected-sound-$index'),
              ),
            ),
          ),
        ) {
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

  Future<void> upload(
    File file, {
    required PlayerChoiceSound target,
  }) async {
    final sounds = state.sounds;
    final index = sounds.indexOf(target);

    final localFileName = basename(file.path);
    final uploading = target.copyWith(
      sound:
          SelectedSound.uploading(id: target.id, localFileName: localFileName),
    );

    sounds[index] = uploading;

    state = state.copyWith(sounds: sounds);

    final uploadedSound = await _submissionUseCase.upload(
      file,
      fileName: basename(file.path),
    );

    if (uploadedSound == null) {
      sounds[index] = target.copyWith(
        sound: SelectedSound.none(id: target.id),
      );

      state = state.copyWith(
        sounds: sounds,
        isAvailableSubmission: _getIsAvailableSubmission(),
      );

      return;
    }

    sounds[index] = target.copyWith(
      sound: SelectedSound.uploaded(
        id: uploadedSound.id,
        localFileName: localFileName,
        remoteUrl: uploadedSound.url,
      ),
    );

    state = state.copyWith(
      sounds: sounds,
      isAvailableSubmission: _getIsAvailableSubmission(),
    );
  }

  Future<void> delete({required PlayerChoiceSound target}) async {
    final sounds = state.sounds;
    final index = sounds.indexOf(target);

    sounds[index] = target.copyWith(
      sound: SelectedSound.none(id: target.id),
    );

    state = state.copyWith(
      sounds: sounds,
      isAvailableSubmission: _getIsAvailableSubmission(),
    );
  }

  RequestPushNotificationPermissionArgs getRequestPermissionArgs() {
    final soundIdList = _getSoundIdList();

    return RequestPushNotificationPermissionArgs(
      template: state.template.template,
      soundIdList: soundIdList,
    );
  }

  Future<void> submit() async {
    state = state.copyWith(isProcessing: true);

    final soundIdList = _getSoundIdList();

    await _submissionUseCase.submit(
      template: state.template.template,
      soundIdList: soundIdList,
    );

    state = state.copyWith(isProcessing: false);
  }

  Future<void> play({required PlayerChoice choice}) async {
    final url = choice.url;
    if (url == null) {
      return;
    }

    final choices = _getPlayerChoices();

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
          originalList: choices,
        ) ??
        [...choices];

    final playingList = PlayerChoiceConverter.getTargetReplaced(
      originalList: stoppedList,
      targetId: choice.id,
      newPlayable:
          choice.copyWith(status: const PlayStatus.playing(position: 0)),
    );

    _setPlayerChoices(playingList);

    await _player.play(url);
  }

  Future<void> stop({required PlayerChoice choice}) async {
    final choices = _getPlayerChoices();

    final stoppedList = PlayerChoiceConverter.getTargetStopped(
      originalList: choices,
      targetId: choice.id,
    );

    _setPlayerChoices(stoppedList);

    await _player.stop();
  }

  Future<void> beforeHideScreen() async {
    final choices = _getPlayerChoices();

    final stoppedList =
        PlayerChoiceConverter.getStoppedOrNull(originalList: choices);

    if (stoppedList != null) {
      _setPlayerChoices(stoppedList);
    }

    await _player.stop();
  }

  bool _getIsAvailableSubmission() {
    final sounds = state.sounds;

    return sounds.fold(
      true,
      (previousValue, sound) =>
          previousValue &&
          sound.sound.map(
            none: (_) => false,
            uploading: (_) => false,
            uploaded: (_) => true,
          ),
    );
  }

  Future<void> _setup() async {
    _audioLengthSubscription = _player.onDurationChanged.listen((duration) {
      _currentAudioLength = duration;
    });

    _audioPositionSubscription =
        _player.onAudioPositionChanged.listen(_onAudioPositionReceived);

    _audioStoppedSubscription = _player.onPlayerCompletion.listen((_) {
      _onAudioFinished();
    });

    final isRequestStepExists = await _submissionUseCase
        .getShouldShowRequestPushNotificationPermission();
    state = state.copyWith(isRequestStepExists: isRequestStepExists);
  }

  void _onAudioPositionReceived(Duration position) {
    final length = _currentAudioLength;
    if (length == null) {
      return;
    }

    final positionRatio = AudioPositionHelper.getPositionRatio(
      length: length,
      position: position,
    );

    final choices = _getPlayerChoices();

    final positionUpdatedList = PlayerChoiceConverter.getPositionUpdatedOrNull(
      originalList: choices,
      position: positionRatio,
    );
    if (positionUpdatedList == null) {
      return;
    }

    _setPlayerChoices(positionUpdatedList);
  }

  void _onAudioFinished() {
    final choices = _getPlayerChoices();

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
      originalList: choices,
    );
    if (stoppedList == null) {
      return;
    }

    _setPlayerChoices(stoppedList);
  }

  List<PlayerChoice> _getPlayerChoices() {
    return [
      state.template,
      ...state.sounds,
    ];
  }

  void _setPlayerChoices(List<PlayerChoice> choices) {
    state = state.copyWith(
      template: choices.first as PlayerChoiceTemplate,
      sounds: choices
          .sublist(1)
          .map((choice) => choice as PlayerChoiceSound)
          .toList(),
    );
  }

  List<String> _getSoundIdList() {
    return state.sounds
        .map((choice) => choice.sound)
        .whereType<SelectedSoundUploaded>()
        .map((uploaded) => uploaded.id)
        .toList();
  }
}
