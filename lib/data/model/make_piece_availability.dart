import 'package:freezed_annotation/freezed_annotation.dart';

part 'make_piece_availability.freezed.dart';

@freezed
class MakePieceAvailability with _$MakePieceAvailability {
  const factory MakePieceAvailability.available() =
      _MakePieceAvailabilityAvailable;
  const factory MakePieceAvailability.unavailable({
    required MakePieceUnavailableReason reason,
  }) = _MakePieceAvailabilityUnavailable;
}

enum MakePieceUnavailableReason {
  hasMaxPiecesAllowedOnFreePlan,
  hasMaxPiecesAllowedOnPremiumPlan,
}
