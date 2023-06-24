// ignore_for_file: prefer-match-file-name

import 'package:flutter_riverpod/flutter_riverpod.dart';

final isPremiumPlanStateProviderMock =
    StateNotifierProvider<_IsPremiumPlanNotifierMock, bool?>(
  (ref) => _IsPremiumPlanNotifierMock(),
);

final toggleIsPremiumPlanForDebugActionProvider = Provider((ref) {
  final isPremiumPlanStateNotifier =
      ref.watch(isPremiumPlanStateProviderMock.notifier);

  return isPremiumPlanStateNotifier.toggleForDebug;
});

class _IsPremiumPlanNotifierMock extends StateNotifier<bool?> {
  _IsPremiumPlanNotifierMock() : super(true);

  void toggleForDebug() {
    final current = state;
    if (current == null) {
      return;
    }

    state = !current;
  }
}
