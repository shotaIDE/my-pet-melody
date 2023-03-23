import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_media.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/helper/audio_position_helper.dart';
import 'package:meow_music/ui/model/play_status.dart';
import 'package:meow_music/ui/model/player_choice.dart';
import 'package:meow_music/ui/select_sounds_state.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/set_piece_title_state.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

class SelectSoundsViewModel extends StateNotifier<SelectSoundsState> {
  SelectSoundsViewModel({
    required Ref ref,
    required Template selectedTemplate,
  })  : _ref = ref,
        super(
          SelectSoundsState(
            template: PlayerChoiceTemplate(
              template: selectedTemplate,
              status: const PlayStatus.stop(),
            ),
            sounds: List.generate(
              1,
              (index) => PlayerChoiceSound(
                status: const PlayStatus.stop(),
                sound: SelectedSoundNone(id: 'selected-sound-$index'),
              ),
            ),
          ),
        ) {
    _setup();
  }

  final Ref _ref;
  final _player = AudioPlayer();

  late String _thumbnailLocalPath;

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

  Future<SelectTrimmedSoundArgs?> detect(File file) async {
    state = state.copyWith(process: SelectSoundScreenProcess.compress);

    final outputDirectory = await getTemporaryDirectory();
    final outputParentPath = outputDirectory.path;
    final fileName = basename(file.path);
    final outputPath = '$outputParentPath/$fileName';

    final copiedFile = await file.copy(outputPath);

    final compressedMediaInfo = await VideoCompress.compressVideo(
      outputPath,
      quality: VideoQuality.Res640x480Quality,
      deleteOrigin: true,
    );
    final compressedFilePath = compressedMediaInfo?.path;
    if (compressedFilePath == null) {
      return null;
    }

    final compressedFile = File(compressedFilePath);

    state = state.copyWith(process: SelectSoundScreenProcess.detect);

    final detectAction = await _ref.read(detectActionProvider.future);
    final detected = await detectAction(
      compressedFile,
      fileName: fileName,
    );

    state = state.copyWith(process: null);

    if (detected == null) {
      return null;
    }

    return SelectTrimmedSoundArgs(
      soundPath: copiedFile.path,
      movieSegmentation: detected,
    );
  }

  Future<void> upload(
    File file, {
    required PlayerChoiceSound target,
  }) async {
    final sounds = [...state.sounds];
    final index = sounds.indexOf(target);

    final localFileName = basename(file.path);
    final uploading = target.copyWith(
      sound:
          SelectedSound.uploading(id: target.id, localFileName: localFileName),
    );

    sounds[index] = uploading;

    state = state.copyWith(sounds: sounds);

    final uploadAction = await _ref.read(uploadActionProvider.future);
    final uploadedSound = await uploadAction(
      file,
      fileName: basename(file.path),
    );

    if (uploadedSound == null) {
      sounds[index] = target.copyWith(
        sound: SelectedSound.none(id: target.id),
      );

      state = state.copyWith(
        sounds: sounds,
        isAvailableSubmission: _getIsAvailableSubmission(sounds: sounds),
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
      isAvailableSubmission: _getIsAvailableSubmission(sounds: sounds),
    );
  }

  Future<void> onSelectedTrimmedSound(
    SelectTrimmedSoundResult result, {
    required PlayerChoiceSound target,
  }) async {
    final sounds = [...state.sounds];
    final index = sounds.indexOf(target);

    sounds[index] = target.copyWith(
      sound: SelectedSound.uploaded(
        id: result.uploaded.id,
        extension: result.uploaded.extension,
        localFileName: result.displayName,
        remoteUrl: result.uploaded.url,
      ),
    );

    state = state.copyWith(
      sounds: sounds,
      isAvailableSubmission: _getIsAvailableSubmission(sounds: sounds),
    );

    _thumbnailLocalPath = result.thumbnailLocalPath;
  }

  Future<void> delete({required PlayerChoiceSound target}) async {
    final sounds = [...state.sounds];
    final index = sounds.indexOf(target);

    sounds[index] = target.copyWith(
      sound: SelectedSound.none(id: target.id),
    );

    state = state.copyWith(
      sounds: sounds,
      isAvailableSubmission: _getIsAvailableSubmission(sounds: sounds),
    );
  }

  SetPieceTitleArgs getSetPieceTitleArgs() {
    final soundIdList = _getSoundIdList();

    final displayName =
        (state.sounds.first.sound as SelectedSoundUploaded).localFileName;

    return SetPieceTitleArgs(
      template: state.template.template,
      sounds: soundIdList,
      // TODO(ide): Fix to no use of force unwrapping
      thumbnailLocalPath: _thumbnailLocalPath,
      displayName: displayName,
    );
  }

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
      newStatus: const PlayStatus.playing(position: 0),
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

  bool _getIsAvailableSubmission({required List<PlayerChoiceSound> sounds}) {
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

  List<UploadedMedia> _getSoundIdList() {
    return state.sounds
        .map((choice) => choice.sound)
        .whereType<SelectedSoundUploaded>()
        .map(
          (uploaded) => UploadedMedia(
            id: uploaded.id,
            extension: uploaded.extension,
            url: uploaded.remoteUrl,
          ),
        )
        .toList();
  }
}
