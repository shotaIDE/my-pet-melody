import 'package:flutter/material.dart';
import 'package:my_pet_melody/ui/model/play_status.dart';
import 'package:skeletons/skeletons.dart';

class ChoicePositionBar extends StatelessWidget {
  const ChoicePositionBar({
    required this.status,
    Key? key,
  }) : super(key: key);

  final PlayStatus status;

  @override
  Widget build(BuildContext context) {
    const height = 6.0;

    return status.when(
      stop: () => const SizedBox(height: height),
      loadingMedia: () => const SkeletonLine(
        style: SkeletonLineStyle(height: height),
      ),
      playing: (position) => LinearProgressIndicator(
        value: position,
        minHeight: height,
      ),
    );
  }
}
