import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_error.freezed.dart';

@freezed
sealed class PurchaseError with _$PurchaseError {
  const factory PurchaseError.cancelledByUser() = PurchaseErrorCancelledByUser;
  const factory PurchaseError.unrecoverable() = PurchaseErrorUnrecoverable;
}
