import 'package:flutter/material.dart';
import 'package:meow_music/ui/component/flickering_image.dart';

class ListeningMusicCatImage extends StatelessWidget {
  const ListeningMusicCatImage({
    Key? key,
  }) : super(key: key);

  static const width = 170.0;
  static const height = 179.0;

  @override
  Widget build(BuildContext context) {
    return const FlickeringImage(
      firstImage: 'assets/images/listening-music-cat_head-up.png',
      secondImage: 'assets/images/listening-music-cat_head-down.png',
    );
  }
}
