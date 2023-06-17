import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_error.freezed.dart';

@freezed
class PurchaseError with _$PurchaseError {
  const factory PurchaseError.cancelledByUser() = _PurchaseErrorCancelledByUser;
  const factory PurchaseError.unrecoverable() = _PurchaseErrorUnrecoverable;
}
