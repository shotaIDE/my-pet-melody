import 'package:flutter/material.dart';
import 'package:my_pet_melody/l10n/generated/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class IsPremiumPlanText extends StatelessWidget {
  const IsPremiumPlanText({required this.isPremiumPlan, super.key});

  final bool? isPremiumPlan;

  @override
  Widget build(BuildContext context) {
    final isPremium = isPremiumPlan;

    return Skeletonizer(
      enabled: isPremium == null,
      child: isPremium == true
          ? Text(AppLocalizations.of(context)!.premiumPlan)
          : Text(AppLocalizations.of(context)!.freePlan),
    );
  }
}
