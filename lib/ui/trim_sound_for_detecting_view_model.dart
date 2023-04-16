import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/trim_sound_for_detecting_state.dart';
import 'package:path/path.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimSoundForDetectingViewModel
    extends StateNotifier<TrimSoundForDetectingState> {
  TrimSoundForDetectingViewModel({
    required Ref ref,
    required String moviePath,
  })  : _ref = ref,
        _moviePath = moviePath,
        super(
          TrimSoundForDetectingState(
            trimmer: Trimmer(),
          ),
        );

  static const splitCount = 10;

  final Ref _ref;
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

  Future<SelectTrimmedSoundArgs?> onComplete() async {
    state = state.copyWith(isUploading: true);

    final originalFileNameWithoutExtension =
        basenameWithoutExtension(_moviePath);
    const convertedExtension = '.mp4';

    final trimmedFilePathCompleter = Completer<String?>();

    await state.trimmer.saveTrimmedVideo(
      startValue: state.startValue,
      endValue: state.endValue,
      onSave: (value) {
        trimmedFilePathCompleter.complete(value);
      },
      customVideoFormat: convertedExtension,
    );

    final trimmedPath = await trimmedFilePathCompleter.future;
    if (trimmedPath == null) {
      state = state.copyWith(isUploading: false);
      return null;
    }

    final trimmedFile = File(trimmedPath);
    final displayName = '$originalFileNameWithoutExtension$convertedExtension';
    final detectAction = await _ref.read(detectActionProvider.future);
    final detected = await detectAction(
      trimmedFile,
      fileName: displayName,
    );

    if (detected == null) {
      return null;
    }

    return SelectTrimmedSoundArgs(
      fileName: originalFileNameWithoutExtension,
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
