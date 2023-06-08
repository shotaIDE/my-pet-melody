import 'package:flutter/material.dart';
import 'package:my_pet_melody/ui/component/flickering_image.dart';

class SpeakingCatImage extends StatelessWidget {
  const SpeakingCatImage({
    this.flipHorizontally = false,
    Key? key,
  }) : super(key: key);

  static const width = 195.0;
  static const height = 131.0;

  final bool flipHorizontally;

  @override
  Widget build(BuildContext context) {
    return FlickeringImage(
      firstImage: 'assets/images/speaking-cat_mouth-opened.png',
      secondImage: 'assets/images/speaking-cat_mouth-closed.png',
      flipHorizontally: flipHorizontally,
    );
  }
}
