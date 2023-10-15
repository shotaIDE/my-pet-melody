import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/preference_key.dart';
import 'package:my_pet_melody/data/service/in_app_review_service.dart';
import 'package:my_pet_melody/data/service/preference_service.dart';

final onAppCompletedToPlayVideoActionProvider = Provider((ref) {
  final requestInAppReviewAction = ref.watch(requestInAppReviewActionProvider);

  Future<void> action() async {
    final previousCount = await PreferenceService.getInt(
          PreferenceKey.appCompletedToPlayVideoCount,
        ) ??
        0;

    // In-app review suggestions are triggered at 1, 5, 20, 40, 60, ... .
    // This is due to the constraints of OS, which does not allow for
    // frequent in-app reviews to be performed.
    final newCount = previousCount + 1;
    if (newCount == 1 || newCount == 5 || newCount % 20 == 0) {
      await requestInAppReviewAction.call();
    }

    await PreferenceService.setInt(
      PreferenceKey.appCompletedToPlayVideoCount,
      value: newCount,
    );
  }

  return action;
});
