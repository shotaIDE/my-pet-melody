import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class FetchedThumbnail extends StatelessWidget {
  const FetchedThumbnail({
    required this.url,
    super.key,
  });

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const SizedBox.shrink();
    }

    return Image.network(
      url!,
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
