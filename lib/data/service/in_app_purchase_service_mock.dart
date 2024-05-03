// ignore_for_file: prefer-match-file-name

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/purchasable.dart';
import 'package:my_pet_melody/data/model/purchase_error.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:my_pet_melody/data/service/in_app_purchase_service.dart';

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

class PurchaseActionsMock extends PurchaseActions {
  const PurchaseActionsMock({required super.errorReporter});

  @override
  Future<String> userId() async {
    return 'DummyPurchaseUserID';
  }

  @override
  Future<Result<void, PurchaseError>> purchase({
    required Purchasable purchasable,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return const Result.success(null);
  }

  @override
  Future<bool> restore() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return true;
  }
}
