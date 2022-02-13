import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/completed_to_submit_state.dart';

class CompletedToSubmitViewModel extends StateNotifier<CompletedToSubmitState> {
  CompletedToSubmitViewModel() : super(const CompletedToSubmitState());

  Future<void> enablePushNotification() async {}
}
