import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
        return Skeletonizer(
          enabled: loadingProgress != null,
          child: child,
        );
      },
      fit: BoxFit.fitWidth,
    );
  }
}
