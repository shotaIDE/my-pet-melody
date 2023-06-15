import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/ui/join_premium_plan_state.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class JoinPremiumPlanViewModel extends StateNotifier<JoinPremiumPlanState> {
  JoinPremiumPlanViewModel() : super(const JoinPremiumPlanState());

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

  Future<void> joinPremiumPlan() async {
    state = state.copyWith(isProcessing: true);

    await Future<void>.delayed(const Duration(seconds: 1));

    state = state.copyWith(isProcessing: false);
  }
}
