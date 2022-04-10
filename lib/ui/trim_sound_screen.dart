import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/ui/trim_sound_state.dart';
import 'package:meow_music/ui/trim_sound_view_model.dart';

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

    return Scaffold(
      appBar: AppBar(),
      body: const Placeholder(),
    );
  }
}
