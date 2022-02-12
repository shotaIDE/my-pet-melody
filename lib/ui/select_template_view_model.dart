import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/select_template_state.dart';

class SelectTemplateViewModel extends StateNotifier<SelectTemplateState> {
  SelectTemplateViewModel({
    required SubmissionUseCase submissionUseCase,
  })  : _submissionUseCase = submissionUseCase,
        super(const SelectTemplateState()) {
    _setup();
  }

  final SubmissionUseCase _submissionUseCase;

  Future<void> _setup() async {
    final templates = await _submissionUseCase.getTemplates();
    state = state.copyWith(templates: templates);
  }
}
