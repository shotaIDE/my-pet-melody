import 'package:collection/collection.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:path_provider/path_provider.dart';

class SelectTrimmedSoundViewModel
    extends StateNotifier<SelectTrimmedSoundState> {
  SelectTrimmedSoundViewModel({
    required SelectTrimmedSoundArgs args,
  })  : _moviePath = args.soundPath,
        super(
          SelectTrimmedSoundState(
            choices: args.segments
                .map((segment) => TrimmedSoundChoice(segment: segment))
                .toList(),
          ),
        );

  final String _moviePath;

  Future<void> setup() async {
    final outputDirectory = await getTemporaryDirectory();
    final outputParentPath = outputDirectory.path;

    const outputFrameCount = 1;

    final thumbnailFilePaths = List.generate(state.choices.length, (index) {
      final paddedIndex = '$index'.padLeft(6, '0');
      final outputFileName = 'thumbnail_$paddedIndex.png';
      return '$outputParentPath/$outputFileName';
    });

    await Future.wait(
      state.choices.mapIndexed((index, choice) async {
        final startSeconds = choice.segment.startMilliseconds / 1000;
        final outputPath = thumbnailFilePaths[index];

        await FFmpegKit.execute(
          '-i $_moviePath '
          '-ss $startSeconds '
          '-frames:v $outputFrameCount '
          '-f image2 '
          '$outputPath',
        );
      }),
    );

    state = state.copyWith(
      choices: state.choices
          .mapIndexed(
            (index, choice) => choice.copyWith(
              thumbnailPath: thumbnailFilePaths[index],
            ),
          )
          .toList(),
    );
  }
}
