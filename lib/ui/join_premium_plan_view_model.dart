import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/join_premium_plan_state.dart';

class JoinPremiumPlanViewModel extends StateNotifier<JoinPremiumPlanState> {
  JoinPremiumPlanViewModel() : super(const JoinPremiumPlanState());

  Future<void> joinPremiumPlan() async {
    state = state.copyWith(isProcessing: true);

    await Future<void>.delayed(const Duration(seconds: 1));

    state = state.copyWith(isProcessing: false);
  }
}
