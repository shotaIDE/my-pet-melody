import 'package:flutter/material.dart';
import 'package:my_pet_melody/ui/model/play_status.dart';

class CircledPlayButton extends StatelessWidget {
  const CircledPlayButton({
    required this.status,
    required this.onPressedWhenStop,
    required this.onPressedWhenPlaying,
    Key? key,
  }) : super(key: key);

  final PlayStatus status;
  final VoidCallback onPressedWhenStop;
  final VoidCallback onPressedWhenPlaying;

  @override
  Widget build(BuildContext context) {
    final icon = status.when(
      stop: () => Icons.play_arrow,
      loadingMedia: () => Icons.stop,
      playing: (position) => Icons.stop,
    );

    final onTapButton = status.map(
      stop: (_) => onPressedWhenStop,
      loadingMedia: (_) => onPressedWhenPlaying,
      playing: (_) => onPressedWhenPlaying,
    );

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: IconButton(
        color: Theme.of(context).primaryColor,
        onPressed: onTapButton,
        icon: Icon(icon),
      ),
    );
  }
}
