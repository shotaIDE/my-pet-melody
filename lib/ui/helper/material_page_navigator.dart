import 'package:flutter/material.dart';

extension MaterialPageNavigator on Navigator {
  static Future<void> popUntilInclusively(
    BuildContext context,
    RoutePredicate predicate,
  ) async {
    if (!context.mounted) {
      return;
    }
    Navigator.popUntil(context, predicate);
    Navigator.pop(context);
  }
}
