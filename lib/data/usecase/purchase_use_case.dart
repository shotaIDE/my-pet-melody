import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/purchasable.dart';
import 'package:my_pet_melody/data/service/in_app_purchase_service.dart';

final FutureProvider<List<Purchasable>?> currentUserPurchasableListProvider =
    FutureProvider((ref) {
  return ref.watch(purchasableListProvider.future);
});
