import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletons/skeletons.dart';

class IsPremiumPlanText extends StatelessWidget {
  const IsPremiumPlanText({
    required this.isPremiumPlan,
    super.key,
  });

  final bool? isPremiumPlan;

  @override
  Widget build(BuildContext context) {
    final isPremium = isPremiumPlan;

    if (isPremium == null) {
      return SizedBox(
        width: 100,
        child: SkeletonParagraph(
          style: const SkeletonParagraphStyle(lines: 1),
        ),
      );
    }

    return isPremium
        ? Text(AppLocalizations.of(context)!.premiumPlan)
        : Text(AppLocalizations.of(context)!.freePlan);
  }
}
