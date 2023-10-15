// ignore_for_file: prefer-match-file-name

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

final requestInAppReviewActionProvider = Provider((_) {
  Future<void> action() async {
    final isAvailable = await InAppReview.instance.isAvailable();
    if (!isAvailable) {
      return;
    }

    await InAppReview.instance.requestReview();
  }

  return action;
});
