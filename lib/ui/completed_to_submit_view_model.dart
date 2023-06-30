import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/ui/completed_to_submit_state.dart';

class CompletedToSubmitViewModel extends StateNotifier<CompletedToSubmitState> {
  CompletedToSubmitViewModel()
      : super(
          const CompletedToSubmitState(
            remainTimeSeconds: waitingTimeToCloseAutomaticallySeconds,
          ),
        );

  static const waitingTimeToCloseAutomaticallySeconds = 5.0;

  Future<void> enablePushNotification() async {}
}
