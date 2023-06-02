import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/component/transparent_app_bar.dart';
import 'package:meow_music/ui/definition/display_definition.dart';
import 'package:meow_music/ui/helper/audio_position_helper.dart';
import 'package:meow_music/ui/model/player_choice.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/select_trimmed_sound_view_model.dart';
import 'package:meow_music/ui/trim_sound_for_generation_screen.dart';
import 'package:skeletons/skeletons.dart';

final selectTrimmedSoundViewModelProvider = StateNotifierProvider.autoDispose
    .family<SelectTrimmedSoundViewModel, SelectTrimmedSoundState,
        SelectTrimmedSoundArgs>(
  (ref, args) => SelectTrimmedSoundViewModel(
    ref: ref,
    args: args,
  ),
);

const _seekBarBorderWidth = 4.0;
const _seekBarHeight = 24.0;

class SelectTrimmedSoundScreen extends ConsumerStatefulWidget {
  SelectTrimmedSoundScreen({
    required SelectTrimmedSoundArgs args,
    Key? key,
  })  : viewModel = selectTrimmedSoundViewModelProvider(args),
        super(key: key);

  static const name = 'SelectTrimmedSoundScreen';

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModel;

  static MaterialPageRoute<SelectTrimmedSoundResult?> route({
    required SelectTrimmedSoundArgs args,
  }) =>
      MaterialPageRoute<SelectTrimmedSoundResult?>(
        builder: (_) => SelectTrimmedSoundScreen(args: args),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<SelectTrimmedSoundScreen> createState() =>
      _SelectTrimmedSoundState();
}

class _SelectTrimmedSoundState extends ConsumerState<SelectTrimmedSoundScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(widget.viewModel.notifier).setup();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);

    if (state.choices.isEmpty) {
      return _UnavailableTrimmedSoundScreen(viewModel: widget.viewModel);
    }

    return _SelectTrimmedSoundScreen(viewModelProvider: widget.viewModel);
  }
}

class _UnavailableTrimmedSoundScreen extends ConsumerStatefulWidget {
  const _UnavailableTrimmedSoundScreen({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModel;

  @override
  ConsumerState<_UnavailableTrimmedSoundScreen> createState() =>
      _UnavailableTrimmedSoundScreenState();
}

class _UnavailableTrimmedSoundScreenState
    extends ConsumerState<_UnavailableTrimmedSoundScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);

    final title = Text(
      '鳴き声が\n見つかりませんでした',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );

    final firstThumbnailPath = state.equallyDividedThumbnailPaths.first;
    const firstThumbnailHeight = 48.0;
    final firstThumbnail = firstThumbnailPath != null
        ? Image.file(
            File(firstThumbnailPath),
            fit: BoxFit.cover,
            width: firstThumbnailHeight * DisplayDefinition.aspectRatio,
            height: firstThumbnailHeight,
          )
        : const SizedBox(
            width: firstThumbnailHeight * DisplayDefinition.aspectRatio,
            height: firstThumbnailHeight,
            child: SkeletonAvatar(),
          );
    final moviePanel = ListTile(
      leading: firstThumbnail,
      title: Text(state.displayName),
      tileColor: Colors.grey[300],
    );

    const noDesiredTrimmingDescription = Text(
      '自分で鳴き声部分をトリミングして設定してね！',
      textAlign: TextAlign.center,
    );

    final trimManuallyButton = TextButton(
      onPressed: () async {
        final localPath =
            ref.read(widget.viewModel.notifier).getLocalPathName();

        final outputPath = await Navigator.push(
          context,
          TrimSoundForGenerationScreen.route(moviePath: localPath),
        );

        if (outputPath == null || !mounted) {
          return;
        }

        Navigator.pop(context, outputPath);
      },
      child: const Text('自分でトリミングする'),
    );

    final body = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          moviePanel,
          const Padding(
            padding: EdgeInsets.only(top: 32, left: 16, right: 16),
            child: noDesiredTrimmingDescription,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: trimManuallyButton,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: title,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: body,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class _SelectTrimmedSoundScreen extends ConsumerStatefulWidget {
  const _SelectTrimmedSoundScreen({
    required this.viewModelProvider,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModelProvider;

  @override
  ConsumerState<_SelectTrimmedSoundScreen> createState() =>
      _SelectTrimmedSoundScreenState();
}

class _SelectTrimmedSoundScreenState
    extends ConsumerState<_SelectTrimmedSoundScreen> {
  @override
  Widget build(BuildContext context) {
    final choicesCount = ref.watch(
      widget.viewModelProvider.select((state) => state.choices.length),
    );
    final isUploading = ref.watch(
      widget.viewModelProvider.select((state) => state.isUploading),
    );
    final viewModel = ref.watch(widget.viewModelProvider.notifier);

    final title = Text(
      '鳴き声を選ぼう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );

    const firstThumbnailHeight = 48.0;
    final movieTile = _MovieTile(
      viewModelProvider: widget.viewModelProvider,
      thumbnailWidth: firstThumbnailHeight * DisplayDefinition.aspectRatio,
      thumbnailHeight: firstThumbnailHeight,
    );

    final noDesiredTrimmingDescription = RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: const [
          TextSpan(
            text: '再生すると',
          ),
          TextSpan(
            text: 'すぐに鳴き声が聞こえる',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'ものを選んでね！'
                'この中にない場合は自分でトリミングしてみてね！',
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );

    final trimManuallyButton = TextButton(
      onPressed: () async {
        final localPath =
            ref.read(widget.viewModelProvider.notifier).getLocalPathName();

        final outputPath = await Navigator.push(
          context,
          TrimSoundForGenerationScreen.route(moviePath: localPath),
        );

        if (outputPath == null || !mounted) {
          return;
        }

        Navigator.pop(context, outputPath);
      },
      child: const Text('自分でトリミングする'),
    );

    final choicePanels = List.generate(
      choicesCount,
      (index) => _ChoicePanel(
        viewModelProvider: widget.viewModelProvider,
        index: index,
        onPlay: viewModel.play,
        onStop: viewModel.stop,
        onSelect: _select,
      ),
    );

    final body = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          movieTile,
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: noDesiredTrimmingDescription,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: trimManuallyButton,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
              children: choicePanels,
            ),
          ),
        ],
      ),
    );

    final scaffold = Scaffold(
      appBar: transparentAppBar(
        context: context,
        titleText: 'STEP 2/3 (2)',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: title,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: body,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );

    return isUploading
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

  Future<void> _select({
    required PlayerChoiceTrimmedMovie choice,
    required int index,
  }) async {
    final result = await ref
        .read(widget.viewModelProvider.notifier)
        .select(choice: choice, index: index);
    if (result == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.pop(context, result);
  }
}

class _MovieTile extends ConsumerWidget {
  const _MovieTile({
    required this.viewModelProvider,
    required this.thumbnailWidth,
    required this.thumbnailHeight,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModelProvider;
  final double thumbnailWidth;
  final double thumbnailHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName =
        ref.watch(viewModelProvider.select((state) => state.displayName));

    return ListTile(
      leading: _EquallyDividedThumbnail(
        viewModelProvider: viewModelProvider,
        index: 0,
        width: thumbnailWidth,
        height: thumbnailHeight,
      ),
      title: Text(displayName),
      tileColor: Colors.grey[300],
    );
  }
}

class _ChoicePanel extends ConsumerWidget {
  const _ChoicePanel({
    required this.viewModelProvider,
    required this.index,
    required this.onPlay,
    required this.onStop,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModelProvider;
  final int index;
  final void Function({required PlayerChoiceTrimmedMovie choice}) onPlay;
  final void Function({required PlayerChoiceTrimmedMovie choice}) onStop;
  final Future<void> Function({
    required PlayerChoiceTrimmedMovie choice,
    required int index,
  }) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choice =
        ref.watch(viewModelProvider.select((state) => state.choices[index]));

    final detailsPanel = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _seekBarBorderWidth),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        _ChoiceThumbnailButton(
                          viewModelProvider: viewModelProvider,
                          index: index,
                          onPlay: onPlay,
                          onStop: onStop,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: _PositionText(
                              viewModelProvider: viewModelProvider,
                              index: index,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _PlayingIndicator(
                      viewModelProvider: viewModelProvider,
                      index: index,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: _SeekBar(
            viewModelProvider: viewModelProvider,
            index: index,
          ),
        ),
      ],
    );

    final body = Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            child: detailsPanel,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );

    return InkWell(
      onTap: () => onSelect(choice: choice, index: index),
      child: Container(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8 - _seekBarBorderWidth,
          left: 8 - _seekBarBorderWidth,
          right: 8 - _seekBarBorderWidth,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        child: body,
      ),
    );
  }
}

class _ChoiceThumbnailButton extends ConsumerWidget {
  const _ChoiceThumbnailButton({
    required this.viewModelProvider,
    required this.index,
    required this.onPlay,
    required this.onStop,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModelProvider;
  final int index;
  final void Function({required PlayerChoiceTrimmedMovie choice}) onPlay;
  final void Function({required PlayerChoiceTrimmedMovie choice}) onStop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choice = ref.watch(
      viewModelProvider.select((state) => state.choices[index]),
    );

    const height = 64.0;
    const width = height * DisplayDefinition.aspectRatio;
    final thumbnailBackground = _Thumbnail(
      path: choice.thumbnailPath,
      width: width,
      height: height,
    );

    final thumbnailButtonIcon = choice.path != null
        ? Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              choice.status.map(
                stop: (_) => Icons.play_arrow,
                playing: (_) => Icons.stop,
              ),
            ),
          )
        : null;

    return InkWell(
      onTap: () => choice.status.map(
        stop: (_) => onPlay(choice: choice),
        playing: (_) => onStop(choice: choice),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          thumbnailBackground,
          if (thumbnailButtonIcon != null) thumbnailButtonIcon,
        ],
      ),
    );
  }
}

class _PositionText extends ConsumerWidget {
  const _PositionText({
    required this.viewModelProvider,
    required this.index,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModelProvider;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startMilliseconds = ref.watch(
      viewModelProvider
          .select((state) => state.choices[index].segment.startMilliseconds),
    );
    final endMilliseconds = ref.watch(
      viewModelProvider
          .select((state) => state.choices[index].segment.endMilliseconds),
    );

    final startPosition = AudioPositionHelper.formattedPosition(
      milliseconds: startMilliseconds,
    );
    final endPosition = AudioPositionHelper.formattedPosition(
      milliseconds: endMilliseconds,
    );

    return Text('開始: $startPosition\n終了: $endPosition');
  }
}

class _PlayingIndicator extends ConsumerWidget {
  const _PlayingIndicator({
    required this.viewModelProvider,
    required this.index,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModelProvider;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      viewModelProvider.select((state) => state.choices[index].status),
    );

    final playingIndicator = status.when(
      stop: LinearProgressIndicator.new,
      playing: (value) => LinearProgressIndicator(value: value),
    );

    return Visibility(
      visible: status.map(stop: (_) => false, playing: (_) => true),
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: playingIndicator,
    );
  }
}

class _SeekBar extends ConsumerWidget {
  const _SeekBar({
    required this.viewModelProvider,
    required this.index,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModelProvider;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final durationMilliseconds = ref.watch(
      viewModelProvider.select((state) => state.durationMilliseconds),
    );
    final startMilliseconds = ref.watch(
      viewModelProvider
          .select((state) => state.choices[index].segment.startMilliseconds),
    );
    final endMilliseconds = ref.watch(
      viewModelProvider
          .select((state) => state.choices[index].segment.endMilliseconds),
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(_seekBarBorderWidth),
          child: _SeekBarBackgroundLayer(
            viewModelProvider: viewModelProvider,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints.expand(
            height: _seekBarHeight + _seekBarBorderWidth * 2,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final seekBarWidth =
                  constraints.maxWidth - _seekBarBorderWidth * 2;
              final startRatio = startMilliseconds / durationMilliseconds;
              final endRatio = endMilliseconds / durationMilliseconds;
              final positionX1 =
                  seekBarWidth * startRatio + _seekBarBorderWidth;
              final positionX2 = seekBarWidth * endRatio + _seekBarBorderWidth;

              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: _seekBarBorderWidth,
                    ),
                    width: positionX1 - _seekBarBorderWidth,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: positionX2,
                    ),
                    width: constraints.maxWidth -
                        (positionX2 + _seekBarBorderWidth),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: positionX1 - 4),
                    width: positionX2 - positionX1 + 8,
                    height: constraints.maxHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: _seekBarBorderWidth,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SeekBarBackgroundLayer extends ConsumerWidget {
  const _SeekBarBackgroundLayer({
    required this.viewModelProvider,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModelProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equallyDividedCount = ref.watch(
      viewModelProvider
          .select((state) => state.equallyDividedThumbnailPaths.length),
    );

    return SizedBox(
      height: _seekBarHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final equallyDividedWidth = width ~/ equallyDividedCount;
          final thumbnailWidth =
              constraints.maxHeight * DisplayDefinition.aspectRatio;
          final thumbnailCountShouldBeDisplayed =
              (width / thumbnailWidth).ceil();
          final thumbnails =
              List.generate(thumbnailCountShouldBeDisplayed, (index) {
            final positionX = index * thumbnailWidth;
            final imageIndex = min(
              positionX ~/ equallyDividedWidth,
              DisplayDefinition.equallyDividedCount - 1,
            );

            final thumbnailBody = _EquallyDividedThumbnail(
              viewModelProvider: viewModelProvider,
              index: imageIndex,
              width: thumbnailWidth,
              height: _seekBarHeight,
            );

            return Padding(
              padding: EdgeInsets.only(left: positionX),
              child: thumbnailBody,
            );
          });

          return ClipRect(
            child: Stack(
              children: thumbnails,
            ),
          );
        },
      ),
    );
  }
}

class _EquallyDividedThumbnail extends ConsumerWidget {
  const _EquallyDividedThumbnail({
    required this.viewModelProvider,
    required this.index,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModelProvider;
  final int index;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnailPath = ref.watch(
      viewModelProvider
          .select((state) => state.equallyDividedThumbnailPaths[index]),
    );

    return _Thumbnail(
      path: thumbnailPath,
      width: width,
      height: height,
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.path,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);

  final String? path;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return path != null
        ? Image.file(
            File(path!),
            fit: BoxFit.cover,
            width: width,
            height: height,
          )
        : SizedBox(
            width: width,
            height: height,
            child: const SkeletonAvatar(),
          );
  }
}
