import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class PositionBarWhenLoadingMedia extends StatelessWidget {
  const PositionBarWhenLoadingMedia({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SkeletonLine(
      style: SkeletonLineStyle(height: 4),
    );
  }
}
