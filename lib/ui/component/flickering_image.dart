import 'dart:math';

import 'package:flutter/material.dart';

class FlickeringImage extends StatefulWidget {
  const FlickeringImage({
    required this.firstImage,
    required this.secondImage,
    this.flipHorizontally = false,
    super.key,
  });

  final String firstImage;
  final String secondImage;
  final bool flipHorizontally;

  @override
  FlickeringImageState createState() => FlickeringImageState();
}

class FlickeringImageState extends State<FlickeringImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<String> _images;
  int _imageIndex = 0;

  @override
  void initState() {
    super.initState();

    _images = [widget.firstImage, widget.secondImage];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addListener(() {
        setState(() {
          _imageIndex = (_animationController.value * _images.length).floor();
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(_images[_imageIndex]);

    if (widget.flipHorizontally) {
      return Transform(
        transform: Matrix4.rotationY(pi),
        alignment: Alignment.center,
        child: image,
      );
    }

    return image;
  }
}
