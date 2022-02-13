import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/model/play_status.dart';
import 'package:meow_music/ui/model/player_choice.dart';
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
              3,
              (index) => PlayerChoiceSound(
                status: const PlayStatus.stop(),
                sound: SelectedSoundNone(id: 'selected-sound-$index'),
              ),
            ),
          ),
        );

  final SubmissionUseCase _submissionUseCase;

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

    final remoteFileName = await _submissionUseCase.upload(
      file,
      fileName: basename(file.path),
    );

    if (remoteFileName == null) {
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
        id: target.id,
        localFileName: localFileName,
        remoteFileName: remoteFileName,
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

  Future<void> submit() async {
    state = state.copyWith(isProcessing: true);

    final remoteFileNames = state.sounds
        .whereType<SelectedSoundUploaded>()
        .map((uploaded) => uploaded.remoteFileName)
        .toList();

    await _submissionUseCase.submit(
      template: state.template.template,
      remoteFileNames: remoteFileNames,
    );

    state = state.copyWith(isProcessing: false);
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
}
