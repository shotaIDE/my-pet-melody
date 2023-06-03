import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class FetchedThumbnail extends StatelessWidget {
  const FetchedThumbnail({
    required this.url,
    Key? key,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      loadingBuilder: (_, child, loadingProgress) {
        if (loadingProgress != null) {
          return const SkeletonLine(
            style: SkeletonLineStyle(height: double.infinity),
          );
        }
        return child;
      },
      fit: BoxFit.fitWidth,
    );
  }
}
