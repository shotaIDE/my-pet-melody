import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/ui/component/footer.dart';
import 'package:my_pet_melody/ui/component/primary_button.dart';
import 'package:my_pet_melody/ui/component/transparent_app_bar.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/select_trimmed_sound_screen.dart';
import 'package:my_pet_melody/ui/trim_sound_for_detection_state.dart';
import 'package:my_pet_melody/ui/trim_sound_for_detection_view_model.dart';
import 'package:video_trimmer/video_trimmer.dart';

final _trimSoundForDetectionViewModelProvider =
    StateNotifierProvider.autoDispose.family<TrimSoundForDetectionViewModel,
        TrimSoundForDetectionState, TrimSoundForDetectionArgs>(
  (ref, args) => TrimSoundForDetectionViewModel(
    ref: ref,
    args: args,
  ),
);

class TrimSoundForDetectionScreen extends ConsumerStatefulWidget {
  TrimSoundForDetectionScreen({
    required TrimSoundForDetectionArgs args,
    Key? key,
  })  : viewModelProvider = _trimSoundForDetectionViewModelProvider(args),
        super(key: key);

  static const name = 'TrimSoundForDetectionScreen';

  final AutoDisposeStateNotifierProvider<TrimSoundForDetectionViewModel,
      TrimSoundForDetectionState> viewModelProvider;

  static MaterialPageRoute<TrimSoundForDetectionScreen> route({
    required TrimSoundForDetectionArgs args,
  }) =>
      MaterialPageRoute<TrimSoundForDetectionScreen>(
        builder: (_) => TrimSoundForDetectionScreen(args: args),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<TrimSoundForDetectionScreen> createState() =>
      _TrimSoundForDetectionScreenState();
}

class _TrimSoundForDetectionScreenState
    extends ConsumerState<TrimSoundForDetectionScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(widget.viewModelProvider.notifier).setup();
  }

  @override
  Widget build(BuildContext context) {
    final title = Text(
      '鳴き声の範囲を選ぼう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );

    final description = Text(
      '選択した範囲から自動で鳴き声を探すよ！',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    );

    final viewer = _VideoViewer(viewModelProvider: widget.viewModelProvider);

    final playControlPanel = GestureDetector(
      onTap: ref.read(widget.viewModelProvider.notifier).onPlay,
      child: Stack(
        alignment: Alignment.center,
        children: [
          viewer,
          _PlayControlButton(
            viewModelProvider: widget.viewModelProvider,
          ),
        ],
      ),
    );

    final editor = _TrimEditor(viewModelProvider: widget.viewModelProvider);

    final footerButton = PrimaryButton(
      onPressed: _onGoNext,
      text: '次へ',
    );
    final footerContent = ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: DisplayDefinition.actionButtonMaxWidth,
      ),
      child: footerButton,
    );
    final footer = Footer(child: footerContent);

    final scaffold = Scaffold(
      appBar: transparentAppBar(
        context: context,
        titleText: 'STEP 3/5',
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: title,
            ),
          ),
          const SizedBox(height: 32),
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: description,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: playControlPanel,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: SafeArea(
              top: false,
              bottom: false,
              child: editor,
            ),
          ),
          const SizedBox(height: 24),
          footer,
        ],
      ),
      resizeToAvoidBottomInset: false,
    );

    return _GrayMask(
      viewModelProvider: widget.viewModelProvider,
      child: scaffold,
    );
  }

  Future<void> _onGoNext() async {
    final args = await ref.read(widget.viewModelProvider.notifier).onGoNext();
    if (args == null || !mounted) {
      return;
    }

    await Navigator.push(
      context,
      SelectTrimmedSoundScreen.route(args: args),
    );
  }
}

class _VideoViewer extends ConsumerWidget {
  const _VideoViewer({
    required this.viewModelProvider,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<TrimSoundForDetectionViewModel,
      TrimSoundForDetectionState> viewModelProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trimmer =
        ref.watch(viewModelProvider.select((state) => state.trimmer));

    return VideoViewer(trimmer: trimmer);
  }
}

class _TrimEditor extends ConsumerWidget {
  const _TrimEditor({
    required this.viewModelProvider,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<TrimSoundForDetectionViewModel,
      TrimSoundForDetectionState> viewModelProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(viewModelProvider.notifier);
    final trimmer =
        ref.watch(viewModelProvider.select((state) => state.trimmer));

    return LayoutBuilder(
      builder: (context, constraints) => TrimViewer(
        trimmer: trimmer,
        viewerWidth: constraints.maxWidth - 16,
        maxVideoLength: TrimSoundForDetectionViewModel.maxDurationToTrim,
        onChangeStart: viewModel.onUpdateStart,
        onChangeEnd: viewModel.onUpdateEnd,
        onChangePlaybackState: (isPlaying) =>
            viewModel.onUpdatePlaybackState(isPlaying: isPlaying),
      ),
    );
  }
}

class _PlayControlButton extends ConsumerWidget {
  const _PlayControlButton({
    required this.viewModelProvider,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<TrimSoundForDetectionViewModel,
      TrimSoundForDetectionState> viewModelProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying =
        ref.watch(viewModelProvider.select((state) => state.isPlaying));

    return isPlaying
        ? const SizedBox.shrink()
        : const Icon(
            Icons.play_arrow,
            size: 48,
            color: Colors.white,
          );
  }
}

class _GrayMask extends ConsumerWidget {
  const _GrayMask({
    required this.viewModelProvider,
    required this.child,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<TrimSoundForDetectionViewModel,
      TrimSoundForDetectionState> viewModelProvider;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final process =
        ref.watch(viewModelProvider.select((state) => state.process));

    final message = process != null ? _processLabel(process) : '';

    return Stack(
      children: [
        child,
        Visibility(
          visible: process != null,
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
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
          ),
        ),
      ],
    );
  }

  String _processLabel(TrimSoundForDetectionScreenProcess process) {
    switch (process) {
      case TrimSoundForDetectionScreenProcess.convert:
        return '動画を変換しています';

      case TrimSoundForDetectionScreenProcess.detect:
        return '動画の中から鳴き声を探しています';
    }
  }
}
