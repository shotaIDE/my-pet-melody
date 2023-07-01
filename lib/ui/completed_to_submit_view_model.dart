import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/ui/completed_to_submit_state.dart';

class CompletedToSubmitViewModel extends StateNotifier<CompletedToSubmitState> {
  CompletedToSubmitViewModel()
      : super(
          const CompletedToSubmitState(
            remainTimeMilliseconds: waitingTimeToCloseAutomaticallyMilliseconds,
          ),
        );

  static const waitingTimeToCloseAutomaticallyMilliseconds = 10 * 1000;

  Timer? _timer;
  VoidCallback? _completeImmediately;

  Future<void> setup({
    required VoidCallback onClose,
    required VoidCallback onCompleteImmediately,
  }) async {
    _completeImmediately = onCompleteImmediately;

    const tickMilliseconds = 50;

    _timer =
        Timer.periodic(const Duration(milliseconds: tickMilliseconds), (timer) {
      final remainTimeMilliseconds = state.remainTimeMilliseconds;
      if (remainTimeMilliseconds == null) {
        timer.cancel();
        return;
      }

      final newRemainTimeMilliseconds =
          remainTimeMilliseconds - tickMilliseconds;

      if (newRemainTimeMilliseconds <= 0) {
        timer.cancel();

        onClose.call();

        return;
      }

      state = state.copyWith(
        remainTimeMilliseconds: newRemainTimeMilliseconds,
      );
    });
  }

  Future<void> stop() async {
    await _stopTimer();
  }

  Future<void> onCompleteImmediately() async {
    await _stopTimer();

    _completeImmediately?.call();
  }

  Future<void> _stopTimer() async {
    _timer?.cancel();

    state = state.copyWith(remainTimeMilliseconds: null);
  }
}
