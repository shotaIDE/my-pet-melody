import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/trim_sound_state.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimSoundViewModel extends StateNotifier<TrimSoundState> {
  TrimSoundViewModel({
    required SubmissionUseCase submissionUseCase,
    required String moviePath,
  })  : _submissionUseCase = submissionUseCase,
        _moviePath = moviePath,
        super(
          TrimSoundState(
            trimmer: Trimmer(),
          ),
        );

  static const splitCount = 10;

  final SubmissionUseCase _submissionUseCase;
  final String _moviePath;

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

  Future<void> save() async {
    final result = await state.trimmer.saveTrimmedVideo(
      startValue: state.startValue,
      endValue: state.endValue,
    );

    debugPrint('succeeded to save: $result');
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
