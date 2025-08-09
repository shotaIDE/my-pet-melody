import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_premium_plan_state.freezed.dart';

@freezed
abstract class JoinPremiumPlanState with _$JoinPremiumPlanState {
  const factory JoinPremiumPlanState({
    @Default(false) bool isProcessing,
  }) = _SetPieceTitleState;
}
