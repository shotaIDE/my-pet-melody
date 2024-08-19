import 'package:flutter/material.dart';
import 'package:my_pet_melody/ui/model/play_status.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChoicePositionBar extends StatelessWidget {
  const ChoicePositionBar({
    required this.status,
    super.key,
  });

  final PlayStatus status;

  @override
  Widget build(BuildContext context) {
    const height = 6.0;

    return status.when(
      stop: () => const SizedBox(height: height),
      loadingMedia: () => const Skeletonizer(
        child: LinearProgressIndicator(
          value: 0.5,
          minHeight: height,
        ),
      ),
      playing: (position) => LinearProgressIndicator(
        value: position,
        minHeight: height,
      ),
    );
  }
}
