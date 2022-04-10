import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/non_silence_segment.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/trim_sound_state.dart';

class TrimSoundViewModel extends StateNotifier<TrimSoundState> {
  TrimSoundViewModel({
    required SubmissionUseCase submissionUseCase,
    required String moviePath,
  })  : _submissionUseCase = submissionUseCase,
        _moviePath = moviePath,
        super(
          const TrimSoundState(),
        );

  static const splitCount = 10;

  final SubmissionUseCase _submissionUseCase;
  final String _moviePath;
  final _player = AudioPlayer();

  NonSilenceSegment? _currentPlayingSegment;
  StreamSubscription<Duration>? _audioPositionSubscription;
  StreamSubscription<void>? _audioStoppedSubscription;

  @override
  Future<void> dispose() async {
    final tasks = [
      _audioPositionSubscription?.cancel(),
      _audioStoppedSubscription?.cancel(),
    ].whereType<Future<void>>().toList();

    await Future.wait<void>(tasks);

    super.dispose();
  }

  Future<void> setup() async {}
}
