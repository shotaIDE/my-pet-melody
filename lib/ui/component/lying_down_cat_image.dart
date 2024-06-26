import 'package:flutter/material.dart';
import 'package:my_pet_melody/ui/component/flickering_image.dart';

class LyingDownCatImage extends StatelessWidget {
  const LyingDownCatImage({
    super.key,
  });

  static const width = 193.0;
  static const height = 101.0;

  @override
  Widget build(BuildContext context) {
    return const FlickeringImage(
      firstImage: 'assets/images/lying-down-cat_tail-up.png',
      secondImage: 'assets/images/lying-down-cat_tail-down.png',
    );
  }
}
