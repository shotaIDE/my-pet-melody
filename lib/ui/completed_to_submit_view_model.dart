import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/completed_to_submit_state.dart';

class CompletedToSubmitViewModel extends StateNotifier<CompletedToSubmitState> {
  CompletedToSubmitViewModel({
    required SubmissionUseCase submissionUseCase,
  })  : _submissionUseCase = submissionUseCase,
        super(const CompletedToSubmitState());

  final SubmissionUseCase _submissionUseCase;
}
