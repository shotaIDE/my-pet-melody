// ignore_for_file: prefer-match-file-name

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/purchasable.dart';
import 'package:my_pet_melody/data/model/purchase_error.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final purchasableListProvider = FutureProvider<List<Purchasable>?>((_) async {
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
  } on PlatformException catch (error) {
    // TODO(ide): record error
    debugPrint('$error');

    return [];
  }
});

final purchaseActionsProvider = Provider(
  (ref) {
    return PurchaseActions();
  },
);

class PurchaseActions {
  Future<Result<void, PurchaseError>> purchase({
    required Purchasable purchasable,
  }) async {
    try {
      final package = purchasable.package;
      final purchaserInfo = await Purchases.purchasePackage(package);
      final entitlements =
          purchaserInfo.entitlements.all['my_entitlement_identifier'];
      if (entitlements == null) {
        return const Result.failure(PurchaseError.unrecoverable());
      }

      if (!entitlements.isActive) {
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
}
