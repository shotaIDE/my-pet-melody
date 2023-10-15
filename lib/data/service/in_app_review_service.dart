import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

final inAppReviewActionsProvider = Provider(
  (_) => InAppReviewActions(),
);

class InAppReviewActions {
  Future<void> request() async {
    final isAvailable = await InAppReview.instance.isAvailable();

    if (!isAvailable) {
      return;
    }

    await InAppReview.instance.requestReview();
  }
}
