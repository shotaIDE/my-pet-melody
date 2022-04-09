import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/select_trimmed_sound_view_model.dart';

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

    final title = Text(
      '使いたい鳴き声を\n選ぼう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );

    final segmentPanels = state.choices.mapIndexed(
      (index, choice) {
        final thumbnailPath = choice.thumbnailPath;
        final thumbnail = thumbnailPath != null
            ? Image.file(
                File(thumbnailPath),
                fit: BoxFit.fill,
                width: 95,
                height: 64,
              )
            : const SizedBox(
                width: 95,
                height: 64,
              );

        final title = Text('セグメント ${index + 1}');

        final subtitle = Text(
          '${choice.segment.startMilliseconds}ms - '
          '${choice.segment.endMilliseconds}ms',
        );

        final selectButton = IconButton(
          onPressed: () {},
          icon: const Icon(Icons.reply),
          iconSize: 24,
        );

        return Column(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title,
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: subtitle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: selectButton,
                ),
              ],
            ),
          ],
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
