import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/select_trimmed_sound_view_model.dart';
import 'package:skeletons/skeletons.dart';

final selectTrimmedSoundViewModelProvider = StateNotifierProvider.autoDispose
    .family<SelectTrimmedSoundViewModel, SelectTrimmedSoundState,
        SelectTrimmedSoundArgs>(
  (ref, args) => SelectTrimmedSoundViewModel(
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

  static MaterialPageRoute route({
    required SelectTrimmedSoundArgs args,
  }) =>
      MaterialPageRoute<SelectTrimmedSoundScreen>(
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

    const seekBarHeight = 24.0;

    final segmentPanels = state.choices.mapIndexed(
      (index, choice) {
        const height = 64.0;
        const width = height * _aspectRatio;
        final thumbnailPath = choice.thumbnailPath;
        final thumbnailBackground = thumbnailPath != null
            ? Image.file(
                File(thumbnailPath),
                fit: BoxFit.fill,
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

        final selectButton = IconButton(
          onPressed: () =>
              ref.read(widget.viewModel.notifier).select(choice: choice),
          icon: const Icon(Icons.reply),
          iconSize: 24,
        );

        final playingIndicator = choice.status.when(
          stop: LinearProgressIndicator.new,
          playing: (value) => LinearProgressIndicator(value: value),
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
                          fit: BoxFit.fill,
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
        final lengthMilliseconds = state.lengthMilliseconds;
        final seekBar = lengthMilliseconds != null
            ? Stack(
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
                        final startRatio = choice.segment.startMilliseconds /
                            lengthMilliseconds;
                        final endRatio =
                            choice.segment.endMilliseconds / lengthMilliseconds;
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
              )
            : Container();

        final body = Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: seekBarBorderWidth),
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
                  selectButton,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: seekBar,
            ),
          ],
        );

        return Container(
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
        );
      },
    ).toList();

    final body = SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 203),
      child: Column(
        children: [
          ...segmentPanels,
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
            child: body,
          ),
        ],
      ),
    );
  }
}
