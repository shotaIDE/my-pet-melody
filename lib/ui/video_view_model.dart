import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/ui/video_state.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends StateNotifier<VideoState> {
  VideoViewModel({
    required PieceGenerated piece,
  })  : _url = piece.movieUrl,
        super(
          VideoState(title: piece.name),
        );

  final String _url;

  late final VideoPlayerController _videoPlayerController;

  @override
  Future<void> dispose() async {
    await _videoPlayerController.dispose();
    state.controller?.dispose();

    super.dispose();
  }

  Future<void> setup() async {
    _videoPlayerController = VideoPlayerController.network(_url);

    await _videoPlayerController.initialize();

    final chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );

    state = state.copyWith(controller: chewieController);
  }
}
