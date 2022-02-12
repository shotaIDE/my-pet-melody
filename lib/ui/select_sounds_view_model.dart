import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/select_sounds_state.dart';
import 'package:path/path.dart';

class SelectSoundsViewModel extends StateNotifier<SelectSoundsState> {
  SelectSoundsViewModel({
    required Template selectedTemplate,
    required SubmissionUseCase submissionUseCase,
  })  : _submissionUseCase = submissionUseCase,
        super(
          SelectSoundsState(
            template: selectedTemplate,
            sounds: List.generate(3, (index) => null),
          ),
        );

  final SubmissionUseCase _submissionUseCase;

  Future<void> upload(
    File file, {
    required int index,
  }) async {
    final replacedSounds = state.sounds;
    final localFileName = basename(file.path);
    final uploading = SelectedSound.uploading(localFileName: localFileName);
    replacedSounds[index] = uploading;

    state = state.copyWith(sounds: replacedSounds);

    final remoteFileName = await _submissionUseCase.upload(
      file,
      fileName: basename(file.path),
    );

    if (remoteFileName == null) {
      replacedSounds[index] = null;

      state = state.copyWith(sounds: replacedSounds);

      return;
    }

    replacedSounds[index] = SelectedSound.uploaded(
      localFileName: localFileName,
      remoteFileName: remoteFileName,
    );

    state = state.copyWith(sounds: replacedSounds);
  }

  Future<void> delete({required int index}) async {
    final sounds = state.sounds;
    sounds[index] = null;

    state = state.copyWith(sounds: sounds);
  }

  Future<void> submit() async {
    state = state.copyWith(isProcessing: true);

    await _submissionUseCase.submit();

    state = state.copyWith(isProcessing: false);
  }
}
