import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/select_trimmed_sound_view_model.dart';
import 'package:meow_music/ui/trim_sound_screen.dart';
import 'package:skeletons/skeletons.dart';

final selectTrimmedSoundViewModelProvider = StateNotifierProvider.autoDispose
    .family<SelectTrimmedSoundViewModel, SelectTrimmedSoundState,
        SelectTrimmedSoundArgs>(
  (ref, args) => SelectTrimmedSoundViewModel(
    submissionUseCase: ref.watch(submissionUseCaseProvider),
    args: args,
  ),
);

const _aspectRatio = 1.5;

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
        fullscreenDialog: true,
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
      style: Theme.of(context).textTheme.headline4,
    );

    final firstThumbnailPath = state.splitThumbnails.first;
    const firstThumbnailHeight = 48.0;
    final firstThumbnail = firstThumbnailPath != null
        ? Image.file(
            File(firstThumbnailPath),
            fit: BoxFit.cover,
            width: firstThumbnailHeight * _aspectRatio,
            height: firstThumbnailHeight,
          )
        : const SizedBox(
            width: firstThumbnailHeight * _aspectRatio,
            height: firstThumbnailHeight,
            child: SkeletonAvatar(),
          );
    final moviePanel = ListTile(
      leading: firstThumbnail,
      title: Text(state.fileName),
      tileColor: Colors.grey[300],
    );

    const noDesiredTrimmingDescription = Text(
      'ご自分で鳴き声部分をトリミングして鳴き声を設定してください。',
      textAlign: TextAlign.center,
    );

    final trimManuallyButton = TextButton(
      onPressed: () async {
        final localPath =
            ref.read(widget.viewModel.notifier).getLocalPathName();

        final outputPath = await Navigator.push(
          context,
          TrimSoundScreen.route(moviePath: localPath),
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
      '使いたい鳴き声を\n選ぼう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline4,
    );

    final firstThumbnailPath = state.splitThumbnails.first;
    const firstThumbnailHeight = 48.0;
    final firstThumbnail = firstThumbnailPath != null
        ? Image.file(
            File(firstThumbnailPath),
            fit: BoxFit.cover,
            width: firstThumbnailHeight * _aspectRatio,
            height: firstThumbnailHeight,
          )
        : const SizedBox(
            width: firstThumbnailHeight * _aspectRatio,
            height: firstThumbnailHeight,
            child: SkeletonAvatar(),
          );
    final moviePanel = ListTile(
      leading: firstThumbnail,
      title: Text(state.fileName),
      tileColor: Colors.grey[300],
    );

    const noDesiredTrimmingDescription = Text(
      'この中に使いたい鳴き声がない場合は？',
      textAlign: TextAlign.center,
    );

    final trimManuallyButton = TextButton(
      onPressed: () async {
        final localPath =
            ref.read(widget.viewModel.notifier).getLocalPathName();

        final outputPath = await Navigator.push(
          context,
          TrimSoundScreen.route(moviePath: localPath),
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
        const width = height * _aspectRatio;
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

        final title = Text('セグメント ${index + 1}');

        final subtitle = Text(
          '${choice.segment.startMilliseconds}ms - '
          '${choice.segment.endMilliseconds}ms',
        );

        final splitThumbnails = state.splitThumbnails;
        final seekBarBackgroundLayer = SizedBox(
          height: seekBarHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final splitWidth = width ~/ splitThumbnails.length;
              final imageWidth = constraints.maxHeight * _aspectRatio;
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
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        title,
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: subtitle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                .select(choice: choice);

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
          const Padding(
            padding: EdgeInsets.only(top: 32, left: 16, right: 16),
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
                          .headline6!
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
