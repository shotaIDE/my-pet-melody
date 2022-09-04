import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/helper/audio_position_helper.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/trim_sound_state.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimSoundViewModel extends StateNotifier<TrimSoundState> {
  TrimSoundViewModel({
    required Reader reader,
    required String moviePath,
  })  : _reader = reader,
        _moviePath = moviePath,
        super(
          TrimSoundState(
            trimmer: Trimmer(),
          ),
        );

  static const splitCount = 10;

  final Reader _reader;
  final String _moviePath;

  @override
  Future<void> dispose() async {
    state.trimmer.dispose();

    super.dispose();
  }

  Future<void> setup() async {
    final file = File(_moviePath);
    await state.trimmer.loadVideo(videoFile: file);
  }

  Future<void> onPlay() async {
    final playbackState = await state.trimmer.videPlaybackControl(
      startValue: state.startValue,
      endValue: state.endValue,
    );

    state = state.copyWith(isPlaying: playbackState);
  }

  Future<SelectTrimmedSoundResult?> save() async {
    state = state.copyWith(isUploading: true);

    final startPosition = AudioPositionHelper.formattedPosition(
      milliseconds: state.startValue.toInt(),
    );
    final endPosition = AudioPositionHelper.formattedPosition(
      milliseconds: state.endValue.toInt(),
    );

    final originalFileNameWithoutExtension =
        basenameWithoutExtension(_moviePath);
    final originalExtension = extension(_moviePath);

    final outputDirectory = await getTemporaryDirectory();
    final outputParentPath = outputDirectory.path;
    final outputFileName = '$originalFileNameWithoutExtension'
        '_manually_trimmed'
        '$originalExtension';
    final outputPath = '$outputParentPath/$outputFileName';

    debugPrint(
      'Begin to trim from $startPosition to $endPosition.',
    );

    await FFmpegKit.execute(
      '-ss $startPosition '
      '-to $endPosition '
      '-i $_moviePath '
      '-y '
      '$outputPath',
    );

    final outputFile = File(outputPath);

    final uploadAction = await _reader(uploadActionProvider.future);
    final uploadedSound = await uploadAction(
      outputFile,
      fileName: basename(outputPath),
    );

    if (uploadedSound == null) {
      state = state.copyWith(isUploading: false);

      return null;
    }

    return SelectTrimmedSoundResult(
      uploaded: uploadedSound,
      displayName: '$originalFileNameWithoutExtension - 手動トリミング',
      // TODO(ide): Generate thumbnail and should be set
      thumbnailPath: '',
    );
  }

  void onUpdateStart(double value) {
    state = state.copyWith(startValue: value);
  }

  void onUpdateEnd(double value) {
    state = state.copyWith(endValue: value);
  }

  void onUpdatePlaybackState({required bool isPlaying}) {
    state = state.copyWith(isPlaying: isPlaying);
  }
}
