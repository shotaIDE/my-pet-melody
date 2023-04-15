import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/trim_sound_for_generating_state.dart';
import 'package:meow_music/ui/trim_sound_for_generating_view_model.dart';
import 'package:video_trimmer/video_trimmer.dart';

final _trimSoundForGeneratingViewModelProvider =
    StateNotifierProvider.autoDispose.family<TrimSoundForGeneratingViewModel,
        TrimSoundForGeneratingState, String>(
  (ref, moviePath) => TrimSoundForGeneratingViewModel(
    ref: ref,
    moviePath: moviePath,
  ),
);

class TrimSoundForGeneratingScreen extends ConsumerStatefulWidget {
  TrimSoundForGeneratingScreen({
    required String moviePath,
    Key? key,
  })  : viewModel = _trimSoundForGeneratingViewModelProvider(moviePath),
        super(key: key);

  static const name = 'TrimSoundForGeneratingScreen';

  final AutoDisposeStateNotifierProvider<TrimSoundForGeneratingViewModel,
      TrimSoundForGeneratingState> viewModel;

  static MaterialPageRoute<SelectTrimmedSoundResult?> route({
    required String moviePath,
  }) =>
      MaterialPageRoute<SelectTrimmedSoundResult?>(
        builder: (_) => TrimSoundForGeneratingScreen(moviePath: moviePath),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<TrimSoundForGeneratingScreen> createState() =>
      _TrimSoundForGeneratingScreenState();
}

class _TrimSoundForGeneratingScreenState
    extends ConsumerState<TrimSoundForGeneratingScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(widget.viewModel.notifier).setup();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);

    final trimmer = state.trimmer;
    final progressVisibility = state.progressVisibility;

    final isPlaying = state.isPlaying;

    final viewer = VideoViewer(trimmer: trimmer);

    final editor = LayoutBuilder(
      builder: (context, constraints) => TrimEditor(
        trimmer: trimmer,
        viewerWidth: constraints.maxWidth - 16,
        maxVideoLength: const Duration(seconds: 10),
        onChangeStart: ref.read(widget.viewModel.notifier).onUpdateStart,
        onChangeEnd: ref.read(widget.viewModel.notifier).onUpdateEnd,
        onChangePlaybackState: (isPlaying) => ref
            .read(widget.viewModel.notifier)
            .onUpdatePlaybackState(isPlaying: isPlaying),
      ),
    );

    final playButton = IconButton(
      onPressed: ref.read(widget.viewModel.notifier).onPlay,
      icon: isPlaying
          ? const Icon(
              Icons.pause,
              size: 64,
              color: Colors.white,
            )
          : const Icon(
              Icons.play_arrow,
              size: 64,
              color: Colors.white,
            ),
    );

    final scaffold = Scaffold(
      appBar: AppBar(
        title: const Text('自分でトリミング'),
        actions: [
          IconButton(
            onPressed: progressVisibility ? null : _save,
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        color: Colors.black,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constrains) {
              return Column(
                children: [
                  Visibility(
                    visible: progressVisibility,
                    child: const LinearProgressIndicator(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: viewer,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      width: constrains.maxWidth,
                      child: editor,
                    ),
                  ),
                  playButton,
                ],
              );
            },
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );

    return state.isUploading
        ? Stack(
            children: [
              scaffold,
              Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'アップロードしています',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              )
            ],
          )
        : scaffold;
  }

  Future<void> _save() async {
    final uploadedSound = await ref.read(widget.viewModel.notifier).save();

    if (uploadedSound == null || !mounted) {
      return;
    }

    Navigator.pop(context, uploadedSound);
  }
}
