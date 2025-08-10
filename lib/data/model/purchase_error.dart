import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_error.freezed.dart';

@freezed
abstract class PurchaseError with _$PurchaseError {
  const factory PurchaseError.cancelledByUser() = PurchaseErrorCancelledByUser;
  const factory PurchaseError.unrecoverable() = PurchaseErrorUnrecoverable;
}
