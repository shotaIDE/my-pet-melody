import 'package:flutter/material.dart';

class FlickeringImage extends StatefulWidget {
  const FlickeringImage({
    required this.firstImage,
    required this.secondImage,
    Key? key,
  }) : super(key: key);

  final String firstImage;
  final String secondImage;

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
      duration: const Duration(seconds: 3),
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
    return Image.asset(_images[_imageIndex]);
  }
}
