import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/template.dart';
import 'package:my_pet_melody/data/usecase/submission_use_case.dart';
import 'package:my_pet_melody/ui/select_trimmed_sound_state.dart';
import 'package:my_pet_melody/ui/trim_sound_for_detection_state.dart';
import 'package:path/path.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimSoundForDetectionViewModel
    extends StateNotifier<TrimSoundForDetectionState> {
  TrimSoundForDetectionViewModel({
    required Ref ref,
    required TrimSoundForDetectionArgs args,
  })  : _ref = ref,
        _template = args.template,
        _moviePath = args.moviePath,
        super(
          TrimSoundForDetectionState(
            trimmer: Trimmer(),
          ),
        );

  static const maxDurationToTrim = Duration(seconds: 20);

  final Ref _ref;
  final Template _template;
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

  Future<SelectTrimmedSoundArgs?> onGoNext() async {
    state = state.copyWith(process: TrimSoundForDetectionScreenProcess.convert);

    final originalFileNameWithoutExtension =
        basenameWithoutExtension(_moviePath);
    const desiredSizeMegaBytes = 10;
    const desiredSizeBytes = desiredSizeMegaBytes * 1000 * 1000;
    final desiredBitrate =
        (desiredSizeBytes * 8) ~/ maxDurationToTrim.inSeconds;
    final ffmpegCommand = '-b:v $desiredBitrate -maxrate $desiredBitrate '
        '-bufsize ${desiredBitrate * 2}';
    const convertedExtension = '.mp4';

    final trimmedPathCompleter = Completer<String?>();

    await state.trimmer.saveTrimmedVideo(
      startValue: state.startValue,
      endValue: state.endValue,
      onSave: (value) {
        trimmedPathCompleter.complete(value);
      },
      ffmpegCommand: ffmpegCommand,
      customVideoFormat: convertedExtension,
    );

    final trimmedPath = await trimmedPathCompleter.future;
    if (trimmedPath == null) {
      state = state.copyWith(process: null);
      return null;
    }

    state = state.copyWith(process: TrimSoundForDetectionScreenProcess.detect);

    final trimmedFile = File(trimmedPath);
    final displayFileName =
        '$originalFileNameWithoutExtension$convertedExtension';
    final detectAction = await _ref.read(detectActionProvider.future);
    final detected = await detectAction(
      trimmedFile,
      fileName: displayFileName,
    );

    if (detected == null) {
      state = state.copyWith(process: null);

      return null;
    }

    state = state.copyWith(process: null);

    return SelectTrimmedSoundArgs(
      template: _template,
      displayName: originalFileNameWithoutExtension,
      soundPath: trimmedPath,
      movieSegmentation: detected,
    );
  }

  void onUpdateStart(double value) {
    state = state.copyWith(startValue: value);
  }

  void onUpdateEnd(double value) {
    state = state.copyWith(endValue: value);
  }

  void onUpdatePlaybackState({required bool isPlaying}) {
    if (isPlaying == state.isPlaying) {
      return;
    }

    state = state.copyWith(isPlaying: isPlaying);
  }
}
