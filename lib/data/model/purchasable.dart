import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchasable.freezed.dart';

@freezed
class Purchasable with _$Purchasable {
  const factory Purchasable({
    required String id,
    required String title,
    required String price,
  }) = _Purchasable;
}
