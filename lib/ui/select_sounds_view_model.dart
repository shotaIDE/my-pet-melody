import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/select_sounds_state.dart';

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

  Future<void> submit() async {
    state = state.copyWith(isProcessing: true);

    await Future<void>.delayed(const Duration(seconds: 1));

    state = state.copyWith(isProcessing: false);
  }
}
