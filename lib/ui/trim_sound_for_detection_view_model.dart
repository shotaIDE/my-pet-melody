import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/logger/event_reporter.dart';
import 'package:my_pet_melody/data/usecase/submission_use_case.dart';
import 'package:my_pet_melody/ui/model/localized_template.dart';
import 'package:my_pet_melody/ui/select_trimmed_sound_state.dart';
import 'package:my_pet_melody/ui/trim_sound_for_detection_state.dart';
import 'package:path/path.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimSoundForDetectionViewModel
    extends StateNotifier<TrimSoundForDetectionState> {
  TrimSoundForDetectionViewModel({
    required EventReporter eventReporter,
    required Ref ref,
    required TrimSoundForDetectionArgs args,
  })  : _eventReporter = eventReporter,
        _ref = ref,
        _template = args.template,
        _moviePath = args.moviePath,
        super(
          TrimSoundForDetectionState(
            trimmer: Trimmer(),
          ),
        );

  static const maxDurationToTrim = Duration(seconds: 20);

  final EventReporter _eventReporter;
  final Ref _ref;
  final LocalizedTemplate _template;
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
    final playbackState = await state.trimmer.videoPlaybackControl(
      startValue: state.startValue,
      endValue: state.endValue,
    );

    state = state.copyWith(isPlaying: playbackState);
  }

  Future<SelectTrimmedSoundArgs?> onGoNext() async {
    state = state.copyWith(process: TrimSoundForDetectionScreenProcess.convert);

    unawaited(
      _eventReporter.startToConvertMovieForDetection(),
    );

    final originalFileNameWithoutExtension =
        basenameWithoutExtension(_moviePath);
    // Trimmed movie is saved in the same extension as the original movie.
    final convertedExtension = extension(_moviePath);

    final trimmedPathCompleter = Completer<String?>();

    await state.trimmer.saveTrimmedVideo(
      startValue: state.startValue,
      endValue: state.endValue,
      onSave: (value) {
        trimmedPathCompleter.complete(value);
      },
    );

    final trimmedPath = await trimmedPathCompleter.future;
    if (trimmedPath == null) {
      state = state.copyWith(process: null);
      return null;
    }

    state = state.copyWith(process: TrimSoundForDetectionScreenProcess.detect);

    unawaited(
      _eventReporter.startToDetect(),
    );

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

  void onUpdateStart(double? value) {
    if (value == null) {
      return;
    }

    state = state.copyWith(startValue: value);
  }

  void onUpdateEnd(double? value) {
    if (value == null) {
      return;
    }

    state = state.copyWith(endValue: value);
  }

  void onUpdatePlaybackState({required bool isPlaying}) {
    if (isPlaying == state.isPlaying) {
      return;
    }

    state = state.copyWith(isPlaying: isPlaying);
  }
}
