import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/join_premium_plan_state.dart';

class JoinPremiumPlanViewModel extends StateNotifier<JoinPremiumPlanState> {
  JoinPremiumPlanViewModel({
    required Ref ref,
  })  : _ref = ref,
        super(const JoinPremiumPlanState());

  final Ref _ref;
}
