import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/helper/audio_position_helper.dart';
import 'package:meow_music/ui/model/play_status.dart';
import 'package:meow_music/ui/model/player_choice.dart';
import 'package:meow_music/ui/request_push_notification_permission_state.dart';
import 'package:meow_music/ui/select_sounds_state.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
        extension: uploadedSound.extension,
        localFileName: localFileName,
        remoteUrl: uploadedSound.url,
      ),
    );

    state = state.copyWith(
      sounds: sounds,
      isAvailableSubmission: _getIsAvailableSubmission(),
    );
  }

  Future<void> uploaded(
    UploadedSound uploadedSound, {
    required PlayerChoiceSound target,
  }) async {
    final sounds = state.sounds;
    final index = sounds.indexOf(target);

    sounds[index] = target.copyWith(
      sound: SelectedSound.uploaded(
        id: uploadedSound.id,
        extension: uploadedSound.extension,
        // TODO(ide): 繋ぎ込み
        localFileName: 'localFileName',
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
      sounds: soundIdList,
    );
  }

  Future<void> submit() async {
    state = state.copyWith(isProcessing: true);

    final soundIdList = _getSoundIdList();

    await _submissionUseCase.submit(
      template: state.template.template,
      sounds: soundIdList,
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

  Future<SelectTrimmedSoundArgs?> detect(File file) async {
    state = state.copyWith(isProcessing: true);

    final outputDirectory = await getTemporaryDirectory();
    final outputParentPath = outputDirectory.path;
    final fileName = basename(file.path);
    final outputPath = '$outputParentPath/$fileName';

    final copiedFile = await file.copy(outputPath);

    final detected = await _submissionUseCase.detect(
      copiedFile,
      fileName: fileName,
    );

    state = state.copyWith(isProcessing: false);

    if (detected == null) {
      return null;
    }

    return SelectTrimmedSoundArgs(
      soundPath: copiedFile.path,
      detected: detected,
    );
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
    _audioDurationSubscription = _player.onDurationChanged.listen((duration) {
      _currentAudioDuration = duration;
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
    final duration = _currentAudioDuration;
    if (duration == null) {
      return;
    }

    final positionRatio = AudioPositionHelper.getPositionRatio(
      duration: duration,
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

  List<UploadedSound> _getSoundIdList() {
    return state.sounds
        .map((choice) => choice.sound)
        .whereType<SelectedSoundUploaded>()
        .map(
          (uploaded) => UploadedSound(
            id: uploaded.id,
            extension: uploaded.extension,
            url: uploaded.remoteUrl,
          ),
        )
        .toList();
  }
}
