import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class IsPremiumPlanText extends StatelessWidget {
  const IsPremiumPlanText({
    required this.isPremiumPlan,
    Key? key,
  }) : super(key: key);

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

    return isPremium ? const Text('プレミアムプラン') : const Text('フリープラン');
  }
}
