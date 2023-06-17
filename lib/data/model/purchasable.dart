import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchasable.freezed.dart';

@freezed
class Purchasable with _$Purchasable {
  const factory Purchasable({
    required String title,
    required String price,
    required Package package,
  }) = _Purchasable;
}
