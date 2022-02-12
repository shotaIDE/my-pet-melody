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
          ),
        );

  final SubmissionUseCase _submissionUseCase;

  Future<void> upload(File file) async {
    await _submissionUseCase.upload(
      file,
      fileName: basename(file.path),
    );
  }

  Future<void> submit() async {
    state = state.copyWith(isProcessing: true);

    await _submissionUseCase.submit();

    state = state.copyWith(isProcessing: false);
  }
}
