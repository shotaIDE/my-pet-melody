import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/definition/display_definition.dart';
import 'package:meow_music/ui/helper/audio_position_helper.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/select_trimmed_sound_view_model.dart';
import 'package:meow_music/ui/trim_sound_for_generating_screen.dart';
import 'package:skeletons/skeletons.dart';

final selectTrimmedSoundViewModelProvider = StateNotifierProvider.autoDispose
    .family<SelectTrimmedSoundViewModel, SelectTrimmedSoundState,
        SelectTrimmedSoundArgs>(
  (ref, args) => SelectTrimmedSoundViewModel(
    ref: ref,
    args: args,
  ),
);

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

    return _SelectTrimmedSoundScreen(viewModel: widget.viewModel);
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

    final firstThumbnailPath = state.splitThumbnails.first;
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
      title: Text(state.fileName),
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
          TrimSoundForGeneratingScreen.route(moviePath: localPath),
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
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModel;

  @override
  ConsumerState<_SelectTrimmedSoundScreen> createState() =>
      _SelectTrimmedSoundScreenState();
}

class _SelectTrimmedSoundScreenState
    extends ConsumerState<_SelectTrimmedSoundScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);

    final title = Text(
      '鳴き声を選ぼう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );

    const firstThumbnailHeight = 48.0;
    final moviePanel = _MovieTile(
      viewModelProvider: widget.viewModel,
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
            ref.read(widget.viewModel.notifier).getLocalPathName();

        final outputPath = await Navigator.push(
          context,
          TrimSoundForGeneratingScreen.route(moviePath: localPath),
        );

        if (outputPath == null || !mounted) {
          return;
        }

        Navigator.pop(context, outputPath);
      },
      child: const Text('自分でトリミングする'),
    );

    const seekBarHeight = 24.0;

    final segmentPanels = state.choices.mapIndexed(
      (index, choice) {
        const height = 64.0;
        const width = height * DisplayDefinition.aspectRatio;
        final thumbnailPath = choice.thumbnailPath;
        final thumbnailBackground = thumbnailPath != null
            ? Image.file(
                File(thumbnailPath),
                fit: BoxFit.cover,
                width: width,
                height: height,
              )
            : const SizedBox(
                width: width,
                height: height,
                child: SkeletonAvatar(),
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
        final thumbnail = InkWell(
          onTap: () => choice.status.map(
            stop: (_) =>
                ref.read(widget.viewModel.notifier).play(choice: choice),
            playing: (_) =>
                ref.read(widget.viewModel.notifier).stop(choice: choice),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              thumbnailBackground,
              thumbnailButtonIcon,
            ].whereType<Widget>().toList(),
          ),
        );

        final startPosition = AudioPositionHelper.formattedPosition(
          milliseconds: choice.segment.startMilliseconds,
        );
        final endPosition = AudioPositionHelper.formattedPosition(
          milliseconds: choice.segment.endMilliseconds,
        );

        final positionText = Text('開始: $startPosition\n終了: $endPosition');

        final splitThumbnails = state.splitThumbnails;
        final seekBarBackgroundLayer = SizedBox(
          height: seekBarHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final splitWidth = width ~/ splitThumbnails.length;
              final imageWidth =
                  constraints.maxHeight * DisplayDefinition.aspectRatio;
              final imageCount = (width / imageWidth).ceil();
              final thumbnails = List.generate(imageCount, (index) {
                final positionX = index * imageWidth;
                final imageIndex = min(
                  positionX ~/ splitWidth,
                  SelectTrimmedSoundViewModel.splitCount - 1,
                );
                final imagePath = splitThumbnails[imageIndex];

                if (imagePath == null) {
                  return Padding(
                    padding: EdgeInsets.only(left: positionX),
                    child: const SkeletonAvatar(),
                  );
                }

                return Padding(
                  padding: EdgeInsets.only(left: positionX),
                  child: Image.file(
                    File(imagePath),
                    width: imageWidth,
                    height: seekBarHeight,
                    fit: BoxFit.cover,
                  ),
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

        const seekBarBorderWidth = 4.0;
        final durationMilliseconds = state.durationMilliseconds;
        final seekBar = Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(seekBarBorderWidth),
              child: seekBarBackgroundLayer,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints.expand(
                height: seekBarHeight + seekBarBorderWidth * 2,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final seekBarWidth =
                      constraints.maxWidth - seekBarBorderWidth * 2;
                  final startRatio =
                      choice.segment.startMilliseconds / durationMilliseconds;
                  final endRatio =
                      choice.segment.endMilliseconds / durationMilliseconds;
                  final positionX1 =
                      seekBarWidth * startRatio + seekBarBorderWidth;
                  final positionX2 =
                      seekBarWidth * endRatio + seekBarBorderWidth;

                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          left: seekBarBorderWidth,
                        ),
                        width: positionX1 - seekBarBorderWidth,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: positionX2,
                        ),
                        width: constraints.maxWidth -
                            (positionX2 + seekBarBorderWidth),
                        color: Colors.white.withOpacity(0.5),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: positionX1 - 4),
                        width: positionX2 - positionX1 + 8,
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: seekBarBorderWidth,
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

        const selectIcon = Icon(Icons.arrow_forward_ios);

        final playingIndicator = choice.status.when(
          stop: LinearProgressIndicator.new,
          playing: (value) => LinearProgressIndicator(value: value),
        );

        final detailsPanel = Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: seekBarBorderWidth),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            thumbnail,
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24),
                                child: positionText,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: choice.status
                              .map(stop: (_) => false, playing: (_) => true),
                          maintainState: true,
                          maintainAnimation: true,
                          maintainSize: true,
                          child: playingIndicator,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: seekBar,
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
              child: selectIcon,
            ),
          ],
        );

        return InkWell(
          onTap: () async {
            final result = await ref
                .read(widget.viewModel.notifier)
                .select(choice: choice, index: index);

            if (result == null || !mounted) {
              return;
            }

            Navigator.pop(context, result);
          },
          child: Container(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8 - seekBarBorderWidth,
              left: 8 - seekBarBorderWidth,
              right: 8 - seekBarBorderWidth,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            child: body,
          ),
        );
      },
    ).toList();

    final body = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          moviePanel,
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
              children: segmentPanels,
            ),
          ),
        ],
      ),
    );

    final scaffold = Scaffold(
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
    final title =
        ref.watch(viewModelProvider.select((state) => state.fileName));

    return ListTile(
      leading: _SplitThumbnail(
        viewModelProvider: viewModelProvider,
        index: 0,
        width: thumbnailWidth,
        height: thumbnailHeight,
      ),
      title: Text(title),
      tileColor: Colors.grey[300],
    );
  }
}

class _SplitThumbnail extends ConsumerWidget {
  const _SplitThumbnail({
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
    final thumbnail = ref.watch(
      viewModelProvider.select((state) => state.splitThumbnails[index]),
    );

    return thumbnail != null
        ? Image.file(
            File(thumbnail),
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
