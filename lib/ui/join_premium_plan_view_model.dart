import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/purchasable.dart';
import 'package:my_pet_melody/data/service/in_app_purchase_service.dart';
import 'package:my_pet_melody/ui/join_premium_plan_state.dart';

class JoinPremiumPlanViewModel extends StateNotifier<JoinPremiumPlanState> {
  JoinPremiumPlanViewModel({required Ref ref})
      : _ref = ref,
        super(const JoinPremiumPlanState());

  final Ref _ref;

  void Function()? _showCompletedJoiningPremiumPlan;
  void Function()? _showFailedJoiningPremiumPlan;
  void Function()? _showCompletedRestoring;
  void Function()? _showFailedRestoring;

  void registerListener({
    required void Function() showCompletedJoiningPremiumPlan,
    required void Function() showFailedJoiningPremiumPlan,
    required void Function() showCompletedRestoring,
    required void Function() showFailedRestoring,
  }) {
    _showCompletedJoiningPremiumPlan = showCompletedJoiningPremiumPlan;
    _showFailedJoiningPremiumPlan = showFailedJoiningPremiumPlan;
    _showCompletedRestoring = showCompletedRestoring;
    _showFailedRestoring = showFailedRestoring;
  }

  Future<void> joinPremiumPlan({
    required Purchasable purchasable,
  }) async {
    state = state.copyWith(isProcessing: true);

    final purchaseActions = _ref.read(purchaseActionsProvider);
    final result = await purchaseActions.purchase(purchasable: purchasable);

    result.when(
      success: (_) {
        _showCompletedJoiningPremiumPlan?.call();
      },
      failure: (error) {
        error.map(
          cancelledByUser: (_) {},
          unrecoverable: (_) {
            _showFailedJoiningPremiumPlan?.call();
          },
        );
      },
    );

    state = state.copyWith(isProcessing: false);
  }

  Future<void> restore() async {
    state = state.copyWith(isProcessing: true);

    final purchaseActions = _ref.read(purchaseActionsProvider);
    final result = await purchaseActions.restore();

    if (result) {
      _showCompletedRestoring?.call();
    } else {
      _showFailedRestoring?.call();
    }

    state = state.copyWith(isProcessing: false);
  }
}
