import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/template.dart';
import 'package:my_pet_melody/data/usecase/submission_use_case.dart';
import 'package:my_pet_melody/ui/helper/audio_position_helper.dart';
import 'package:my_pet_melody/ui/set_piece_title_state.dart';
import 'package:my_pet_melody/ui/trim_sound_for_generation_state.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimSoundForGenerationViewModel
    extends StateNotifier<TrimSoundForGenerationState> {
  TrimSoundForGenerationViewModel({
    required Ref ref,
    required TrimSoundForGenerationArgs args,
  })  : _ref = ref,
        _template = args.template,
        _displayName = args.displayName,
        _moviePath = args.soundPath,
        super(
          TrimSoundForGenerationState(
            trimmer: Trimmer(),
          ),
        );

  static const maxDurationToTrim = Duration(seconds: 10);

  final Ref _ref;
  final Template _template;
  final String _displayName;
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

  Future<SetPieceTitleArgs?> onGoNext() async {
    state =
        state.copyWith(process: TrimSoundForGenerationScreenProcess.convert);

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

    final startMilliseconds = state.startValue;
    final endMilliseconds = state.endValue;

    await state.trimmer.saveTrimmedVideo(
      startValue: startMilliseconds,
      endValue: endMilliseconds,
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

    final startPosition = formattedAudioPosition(
      milliseconds: startMilliseconds.toInt(),
    );
    final thumbnailDirectory = await getTemporaryDirectory();
    final thumbnailParentPath = thumbnailDirectory.path;
    final thumbnailPath = '$thumbnailParentPath/thumbnail.png';

    await FFmpegKit.execute(
      '-ss $startPosition '
      '-i $_moviePath '
      '-vframes 1 '
      '$thumbnailPath',
    );

    state = state.copyWith(process: TrimSoundForGenerationScreenProcess.upload);

    final trimmedFile = File(trimmedPath);
    final displayFileName =
        '$originalFileNameWithoutExtension$convertedExtension';
    final uploadAction = await _ref.read(uploadActionProvider.future);
    final uploadedSound = await uploadAction(
      trimmedFile,
      fileName: displayFileName,
    );

    if (uploadedSound == null) {
      state = state.copyWith(process: null);

      return null;
    }

    state = state.copyWith(process: null);

    return SetPieceTitleArgs(
      template: _template,
      sounds: [uploadedSound],
      thumbnailLocalPath: thumbnailPath,
      displayName: _displayName,
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
