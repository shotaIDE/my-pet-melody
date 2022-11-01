import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    required this.url,
    Key? key,
  }) : super(key: key);

  static const name = 'VideoScreen';

  final String url;

  static MaterialPageRoute<VideoScreen> route({
    required String url,
  }) =>
      MaterialPageRoute<VideoScreen>(
        builder: (_) => VideoScreen(url: url),
        settings: const RouteSettings(name: name),
        fullscreenDialog: true,
      );

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final VideoPlayerController _videoPlayerController;
  late final ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(
      widget.url,
    );
    _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
