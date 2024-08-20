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
        final skeletonEnabled = loadingProgress != null;
        final fixedChild = skeletonEnabled
            ? ColoredBox(
                color: Theme.of(context).primaryColor,
              )
            : child;

        return Skeletonizer(
          enabled: skeletonEnabled,
          child: fixedChild,
        );
      },
      fit: BoxFit.fitWidth,
    );
  }
}
