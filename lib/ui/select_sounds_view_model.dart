import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/template.dart';
import 'package:my_pet_melody/ui/helper/audio_position_helper.dart';
import 'package:my_pet_melody/ui/model/play_status.dart';
import 'package:my_pet_melody/ui/model/player_choice.dart';
import 'package:my_pet_melody/ui/select_sounds_state.dart';

class SelectSoundsViewModel extends StateNotifier<SelectSoundsState> {
  SelectSoundsViewModel({
    required Template selectedTemplate,
  }) : super(
          SelectSoundsState(
            template: PlayerChoiceTemplate(
              template: selectedTemplate,
              status: const PlayStatus.stop(),
            ),
          ),
        ) {
    _setup();
  }

  final _player = AudioPlayer();

  Future<String?> Function()? _pickVideoFileListener;
  void Function(String soundPath)? _trimSoundForDetectionListener;

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

  void registerListener({
    required Future<String?> Function() pickVideoFile,
    required void Function(String soundPath) trimSoundForDetection,
  }) {
    _pickVideoFileListener = pickVideoFile;
    _trimSoundForDetectionListener = trimSoundForDetection;
  }

  Future<void> onTapSelectSound() async {
    state = state.copyWith(isPicking: true);

    final pickedPath = await _pickVideoFileListener?.call();
    if (pickedPath == null) {
      state = state.copyWith(isPicking: false);
      return;
    }

    _trimSoundForDetectionListener?.call(pickedPath);

    state = state.copyWith(isPicking: false);
  }

  // SetPieceTitleArgs getSetPieceTitleArgs() {
  //   final soundIdList = _getSoundIdList();

  //   final displayName =
  //       (state.sounds.first.sound as SelectedSoundUploaded).localFileName;

  //   return SetPieceTitleArgs(
  //     template: state.template.template,
  //     sounds: 'soundIdList',
  //     // TODO(ide): Fix to no use of force unwrapping
  //     thumbnailLocalPath: _thumbnailLocalPath,
  //     displayName: 'displayName',
  //   );
  // }

  Future<void> play({required PlayerChoice choice}) async {
    final url = choice.uri;
    if (url == null) {
      return;
    }

    final choices = _getPlayerChoices();

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
          originalList: choices,
        ) ??
        [...choices];

    final playingList = PlayerChoiceConverter.getTargetStatusReplaced(
      originalList: stoppedList,
      targetId: choice.id,
      newStatus: const PlayStatus.loadingMedia(),
    );

    _setPlayerChoices(playingList);

    final source = UrlSource(url);

    await _player.play(source);
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

  Future<void> _setup() async {
    _audioDurationSubscription = _player.onDurationChanged.listen((duration) {
      _currentAudioDuration = duration;
    });

    _audioPositionSubscription =
        _player.onPositionChanged.listen(_onAudioPositionReceived);

    _audioStoppedSubscription = _player.onPlayerComplete.listen((_) {
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
    ];
  }

  void _setPlayerChoices(List<PlayerChoice> choices) {
    state = state.copyWith(
      template: choices.first as PlayerChoiceTemplate,
    );
  }

  // List<UploadedMedia> _getSoundIdList() {
  //   return state.sounds
  //       .map((choice) => choice.sound)
  //       .whereType<SelectedSoundUploaded>()
  //       .map(
  //         (uploaded) => UploadedMedia(
  //           id: uploaded.id,
  //           extension: uploaded.extension,
  //           url: uploaded.remoteUrl,
  //         ),
  //       )
  //       .toList();
  // }
}
