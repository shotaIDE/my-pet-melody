// ignore_for_file: prefer-match-file-name

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/purchasable.dart';
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
          id: package.identifier,
          title: storeProduct.title,
          price: storeProduct.priceString,
        );
      },
    ).toList();
  } on PlatformException catch (error) {
    // TODO(ide): record error
    debugPrint('$error');

    return [];
  }
});
