import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/logger/event_reporter.dart';
import 'package:my_pet_melody/data/model/piece.dart';
import 'package:my_pet_melody/data/usecase/play_video_use_case.dart';
import 'package:my_pet_melody/ui/video_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends StateNotifier<VideoState> {
  VideoViewModel({
    required PieceGenerated piece,
    required EventReporter eventReporter,
    required Ref ref,
  })  : _piece = piece,
        _eventReporter = eventReporter,
        _ref = ref,
        super(
          VideoState(title: piece.name),
        );

  final PieceGenerated _piece;
  final EventReporter _eventReporter;
  final Ref _ref;

  late final VideoPlayerController _videoPlayerController;

  @override
  Future<void> dispose() async {
    await _videoPlayerController.dispose();
    state.controller?.dispose();

    super.dispose();
  }

  Future<void> setup() async {
    final movieUri = Uri.parse(_piece.movieUrl);
    _videoPlayerController = VideoPlayerController.networkUrl(movieUri);

    await _videoPlayerController.initialize();

    final chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
    );

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        _ref.read(onAppCompletedToPlayVideoActionProvider).call();

        _eventReporter.videoFinished();
      }
    });

    state = state.copyWith(controller: chewieController);
  }

  Future<void> share() async {
    await state.controller?.pause();

    state = state.copyWith(isProcessing: true);

    final dio = Dio();

    final pieceName = _piece.name;

    final parentDirectory = await getApplicationDocumentsDirectory();
    final parentPath = parentDirectory.path;
    final directory = Directory('$parentPath/$pieceName');
    await directory.create(recursive: true);

    final path = '${directory.path}/$pieceName${_piece.movieExtension}';
    await dio.download(_piece.movieUrl, path);

    final xFile = XFile(path);
    await Share.shareXFiles([xFile]);

    state = state.copyWith(isProcessing: false);
  }
}
