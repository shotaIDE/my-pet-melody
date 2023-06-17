import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/service/in_app_purchase_service.dart';

final currentUserPurchasableListProvider = FutureProvider((ref) async {
  return ref.watch(purchasableListProvider.future);
});
