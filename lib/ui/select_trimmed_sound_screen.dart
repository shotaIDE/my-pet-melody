import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/ui/model/player_choice.dart';
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
  static const _aspectRatio = 1.5;

  @override
  void initState() {
    super.initState();

    ref.read(widget.viewModel.notifier).setup();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);

    final title = Text(
      '使いたい鳴き声を\n選ぼう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );

    final firstThumbnailPath = state.splitThumbnails?.first;
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

    const noDesiredTrimmingDescription = Text('この中に使いたい鳴き声がない場合は？');

    final trimManuallyButton = TextButton(
      onPressed: _trimManually,
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

        final thumbnailButtonIcon = Container(
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
        );
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
            ],
          ),
        );

        final title = Text('セグメント ${index + 1}');

        final subtitle = Text(
          '${choice.segment.startMilliseconds}ms - '
          '${choice.segment.endMilliseconds}ms',
        );

        final splitThumbnails = state.splitThumbnails;
        final seekBarBackgroundLayer = splitThumbnails != null
            ? SizedBox(
                height: seekBarHeight,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final splitWidth = width ~/ splitThumbnails.length;
                    final imageWidth = constraints.maxHeight * _aspectRatio;
                    final imageCount = (width / imageWidth).ceil();
                    final thumbnails = List.generate(imageCount, (index) {
                      final positionX = index * imageWidth;
                      final imageIndex = positionX ~/ splitWidth;
                      final imagePath = splitThumbnails[imageIndex];

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
              )
            : ConstrainedBox(
                constraints: const BoxConstraints.expand(height: 24),
                child: const SkeletonAvatar(),
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
                        margin: EdgeInsets.only(left: positionX1),
                        width: positionX2 - positionX1,
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
          onTap: () => _select(choice: choice),
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
            padding: EdgeInsets.only(top: 32),
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

  Future<void> _trimManually() async {
    final localPath = ref.read(widget.viewModel.notifier).getLocalPathName();

    final outputPath = await Navigator.push(
      context,
      TrimSoundScreen.route(moviePath: localPath),
    );

    if (outputPath == null || !mounted) {
      return;
    }

    Navigator.pop(context, outputPath);
  }

  Future<void> _select({
    required PlayerChoiceTrimmedMovie choice,
  }) async {
    final result =
        await ref.read(widget.viewModel.notifier).select(choice: choice);

    if (result == null || !mounted) {
      return;
    }

    Navigator.pop(context, result);
  }
}
