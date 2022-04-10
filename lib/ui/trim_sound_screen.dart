import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
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

  static MaterialPageRoute<UploadedSound?> route({
    required String moviePath,
  }) =>
      MaterialPageRoute<UploadedSound?>(
        builder: (_) => TrimSoundScreen(moviePath: moviePath),
        settings: const RouteSettings(name: name),
        fullscreenDialog: true,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('トリミング'),
        actions: [
          TextButton(
            onPressed: progressVisibility
                ? null
                : () => ref.read(widget.viewModel.notifier).save(),
            child: const Text('保存'),
          )
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: progressVisibility,
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: VideoViewer(trimmer: trimmer),
                ),
                Center(
                  child: TrimEditor(
                    trimmer: trimmer,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: const Duration(seconds: 10),
                    onChangeStart:
                        ref.read(widget.viewModel.notifier).onUpdateStart,
                    onChangeEnd:
                        ref.read(widget.viewModel.notifier).onUpdateEnd,
                    onChangePlaybackState: (isPlaying) => ref
                        .read(widget.viewModel.notifier)
                        .onUpdatePlaybackState(isPlaying: isPlaying),
                  ),
                ),
                TextButton(
                  onPressed: ref.read(widget.viewModel.notifier).onPlay,
                  child: isPlaying
                      ? const Icon(
                          Icons.pause,
                          size: 80,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.play_arrow,
                          size: 80,
                          color: Colors.white,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
