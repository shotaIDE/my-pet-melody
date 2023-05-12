import 'package:flutter/material.dart';
import 'package:meow_music/ui/component/flickering_image.dart';

class SpeakingCatImage extends StatelessWidget {
  const SpeakingCatImage({
    Key? key,
  }) : super(key: key);

  static const width = 195.0;
  static const height = 131.0;

  @override
  Widget build(BuildContext context) {
    return const FlickeringImage(
      firstImage: 'assets/images/speaking-cat_mouth-opened.png',
      secondImage: 'assets/images/speaking-cat_mouth-closed.png',
    );
  }
}
