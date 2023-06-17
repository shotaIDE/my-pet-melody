import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/purchasable.dart';
import 'package:my_pet_melody/data/service/in_app_purchase_service.dart';
import 'package:my_pet_melody/ui/join_premium_plan_state.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class JoinPremiumPlanViewModel extends StateNotifier<JoinPremiumPlanState> {
  JoinPremiumPlanViewModel({required Ref ref})
      : _ref = ref,
        super(const JoinPremiumPlanState());

  final Ref _ref;

  Future<void> setup() async {
    try {
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;
      final packages = offering?.availablePackages;
      packages?.forEach(
        (package) {
          final storeProduct = package.storeProduct;
          debugPrint(
            'Title: ${storeProduct.title}, price: ${storeProduct.priceString}',
          );
        },
      );
    } on PlatformException catch (error) {
      debugPrint('$error');
    }
  }

  Future<void> joinPremiumPlan({
    required Purchasable purchasable,
  }) async {
    state = state.copyWith(isProcessing: true);

    final purchaseActions = _ref.read(purchaseActionsProvider);
    final result = await purchaseActions.purchase(purchasable: purchasable);

    result.when(
      success: (_) {
        debugPrint('Succeeded.');
      },
      failure: (error) {
        debugPrint('Failed: $error');
      },
    );

    state = state.copyWith(isProcessing: false);
  }

  Future<void> restore() async {
    state = state.copyWith(isProcessing: true);

    final purchaseActions = _ref.read(purchaseActionsProvider);
    final result = await purchaseActions.restore();

    if (result) {
      debugPrint('Succeeded.');
    } else {
      debugPrint('Failed.');
    }

    state = state.copyWith(isProcessing: false);
  }
}
