// ignore_for_file: prefer-match-file-name

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/logger/error_reporter.dart';
import 'package:my_pet_melody/data/model/purchasable.dart';
import 'package:my_pet_melody/data/model/purchase_error.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final isPremiumPlanProvider = Provider((ref) {
  final isPremiumPlan = ref.watch(_isPremiumPlanStateProvider);
  return isPremiumPlan;
});

final purchasableListProvider = FutureProvider<List<Purchasable>?>((ref) async {
  final errorReporter = ref.watch(errorReporterProvider);

  try {
    final offerings = await Purchases.getOfferings();
    final offering = offerings.current;
    final packages = offering?.availablePackages;
    return packages?.map(
      (package) {
        final storeProduct = package.storeProduct;

        return Purchasable(
          title: storeProduct.title,
          price: storeProduct.priceString,
          package: package,
        );
      },
    ).toList();
  } on PlatformException catch (error, stack) {
    await errorReporter.send(
      error,
      stack,
      reason: 'failed to fetch purchasable.',
    );

    return [];
  }
});

final purchaseActionsProvider = Provider(
  (ref) {
    final errorReporter = ref.watch(errorReporterProvider);

    return PurchaseActions(errorReporter: errorReporter);
  },
);

const _premiumPlanEntitlementIdentifier = 'premium';

class PurchaseActions {
  const PurchaseActions({required ErrorReporter errorReporter})
      : _errorReporter = errorReporter;

  final ErrorReporter _errorReporter;

  Future<Result<void, PurchaseError>> purchase({
    required Purchasable purchasable,
  }) async {
    try {
      final package = purchasable.package;
      final purchaserInfo = await Purchases.purchasePackage(package);
      final entitlement =
          purchaserInfo.entitlements.all[_premiumPlanEntitlementIdentifier];
      if (entitlement == null) {
        return const Result.failure(PurchaseError.unrecoverable());
      }

      if (!entitlement.isActive) {
        return const Result.failure(PurchaseError.unrecoverable());
      }

      return const Result.success(null);
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return const Result.failure(PurchaseError.cancelledByUser());
      }

      return const Result.failure(PurchaseError.unrecoverable());
    }
  }

  Future<bool> restore() async {
    try {
      await Purchases.restorePurchases();
      return true;
    } on PlatformException catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'failed to restore purchases.',
      );

      return false;
    }
  }
}

final _isPremiumPlanStateProvider =
    StateNotifierProvider<_IsPremiumPlanNotifier, bool?>(
  (ref) => _IsPremiumPlanNotifier(),
);

class _IsPremiumPlanNotifier extends StateNotifier<bool?> {
  _IsPremiumPlanNotifier() : super(null) {
    _setup();
  }

  Future<void> _setup() async {
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      final entitlement =
          customerInfo.entitlements.all[_premiumPlanEntitlementIdentifier];
      if (entitlement == null) {
        _updateIfNeeded(isPremiumPlan: false);
        return;
      }

      _updateIfNeeded(isPremiumPlan: entitlement.isActive);
    });
  }

  void _updateIfNeeded({required bool? isPremiumPlan}) {
    if (state == isPremiumPlan) {
      return;
    }

    state = isPremiumPlan;
  }
}
