import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/trim_sound_state.dart';
import 'package:meow_music/ui/trim_sound_view_model.dart';
import 'package:video_trimmer/video_trimmer.dart';

final selectTrimmedSoundViewModelProvider = StateNotifierProvider.autoDispose
    .family<TrimSoundViewModel, TrimSoundState, String>(
  (ref, moviePath) => TrimSoundViewModel(
    submissionUseCase: ref.watch(submissionUseCaseProvider),
    moviePath: moviePath,
  ),
);

class TrimSoundScreen extends ConsumerStatefulWidget {
  TrimSoundScreen({
    required String moviePath,
    Key? key,
  })  : viewModel = selectTrimmedSoundViewModelProvider(moviePath),
        super(key: key);

  static const name = 'TrimSoundScreen';

  final AutoDisposeStateNotifierProvider<TrimSoundViewModel, TrimSoundState>
      viewModel;

  static MaterialPageRoute<SelectTrimmedSoundResult?> route({
    required String moviePath,
  }) =>
      MaterialPageRoute<SelectTrimmedSoundResult?>(
        builder: (_) => TrimSoundScreen(moviePath: moviePath),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<TrimSoundScreen> createState() => _SelectTrimmedSoundState();
}

class _SelectTrimmedSoundState extends ConsumerState<TrimSoundScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('トリミング'),
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
    );
  }

  Future<void> _save() async {
    final uploadedSound = await ref.read(widget.viewModel.notifier).save();

    if (uploadedSound == null || !mounted) {
      return;
    }

    Navigator.pop(context, uploadedSound);
  }
}
