import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/trim_sound_for_detecting_state.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
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

  Future<SelectTrimmedSoundResult?> save() async {
    state = state.copyWith(isUploading: true);

    final originalFileNameWithoutExtension =
        basenameWithoutExtension(_moviePath);

    final trimmedFilePathCompleter = Completer<String?>();

    await state.trimmer.saveTrimmedVideo(
      startValue: state.startValue,
      endValue: state.endValue,
      onSave: (value) {
        trimmedFilePathCompleter.complete(value);
      },
      customVideoFormat: '.mp4',
      videoFileName: originalFileNameWithoutExtension,
    );

    final trimmedPath = await trimmedFilePathCompleter.future;
    if (trimmedPath == null) {
      state = state.copyWith(isUploading: false);
      return null;
    }

    final trimmedFileName = basename(trimmedPath);

    final compressedDirectory = await getTemporaryDirectory();
    final compressedParentPath = compressedDirectory.path;
    final compressedOriginalPath = '$compressedParentPath/$trimmedFileName';

    final trimmedFile = File(trimmedPath);
    await trimmedFile.copy(compressedOriginalPath);

    final compressedMediaInfo = await VideoCompress.compressVideo(
      compressedOriginalPath,
      quality: VideoQuality.Res640x480Quality,
      deleteOrigin: true,
    );
    final compressedPath = compressedMediaInfo?.path;
    if (compressedPath == null) {
      return null;
    }

    final outputFile = File(compressedPath);

    final uploadAction = await _ref.read(uploadActionProvider.future);
    final uploadedSound = await uploadAction(
      outputFile,
      fileName: trimmedFileName,
    );

    if (uploadedSound == null) {
      state = state.copyWith(isUploading: false);
      return null;
    }

    return SelectTrimmedSoundResult(
      uploaded: uploadedSound,
      displayName: originalFileNameWithoutExtension,
      // TODO(ide): Generate thumbnail and should be set
      thumbnailLocalPath: '',
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
