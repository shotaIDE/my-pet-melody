import 'package:collection/collection.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
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

  static const splitCount = 10;

  final String _moviePath;

  Future<void> setup() async {
    final outputDirectory = await getTemporaryDirectory();
    final outputParentPath = outputDirectory.path;

    final session = await FFprobeKit.getMediaInformation(_moviePath);
    final durationString = session.getMediaInformation()?.getDuration();
    if (durationString == null) {
      return;
    }

    final durationSeconds = double.parse(durationString);
    state = state.copyWith(
      lengthMilliseconds: (durationSeconds * 1000).toInt(),
    );

    final thumbnailFilePaths = List.generate(state.choices.length, (index) {
      final paddedIndex = '$index'.padLeft(6, '0');
      final outputFileName = 'thumbnail_$paddedIndex.png';
      return '$outputParentPath/$outputFileName';
    });

    await Future.wait(
      state.choices.mapIndexed((index, choice) async {
        final startSeconds = choice.segment.startMilliseconds / 1000;
        const outputFrameCount = 1;
        final outputPath = thumbnailFilePaths[index];

        await FFmpegKit.execute(
          '-i $_moviePath '
          '-ss $startSeconds '
          '-frames:v $outputFrameCount '
          '-f image2 '
          '-y '
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

    final splitDuration = durationSeconds / splitCount;

    final splitThumbnailFilePaths = List.generate(splitCount, (index) {
      final paddedIndex = '$index'.padLeft(2, '0');
      final outputFileName = 'split_$paddedIndex.png';
      return '$outputParentPath/$outputFileName';
    });

    await Future.wait(
      List.generate(splitCount, (index) async {
        final startSeconds = splitDuration * index;
        const outputFrameCount = 1;

        final outputPath = splitThumbnailFilePaths[index];

        await FFmpegKit.execute(
          '-i $_moviePath '
          '-ss $startSeconds '
          '-frames:v $outputFrameCount '
          '-f image2 '
          '-y '
          '$outputPath',
        );
      }),
    );

    state = state.copyWith(
      splitThumbnails: splitThumbnailFilePaths,
    );
  }
}
