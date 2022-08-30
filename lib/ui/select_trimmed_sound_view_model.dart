import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/detected_non_silent_segments.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/helper/audio_position_helper.dart';
import 'package:meow_music/ui/model/play_status.dart';
import 'package:meow_music/ui/model/player_choice.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SelectTrimmedSoundViewModel
    extends StateNotifier<SelectTrimmedSoundState> {
  SelectTrimmedSoundViewModel({
    required Reader reader,
    required SelectTrimmedSoundArgs args,
  })  : _reader = reader,
        _moviePath = args.soundPath,
        super(
          SelectTrimmedSoundState(
            fileName: basename(args.soundPath),
            choices: args.detected.list
                .mapIndexed(
                  (index, segment) => PlayerChoiceTrimmedMovie(
                    status: const PlayStatus.stop(),
                    index: index + 1,
                    segment: segment,
                  ),
                )
                .toList(),
            splitThumbnails: List.generate(splitCount, (_) => null),
            durationMilliseconds: args.detected.durationMilliseconds,
          ),
        );

  static const splitCount = 10;

  final Reader _reader;
  final String _moviePath;
  final _player = AudioPlayer();

  NonSilentSegment? _currentPlayingSegment;
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

  Future<void> setup() async {
    _audioPositionSubscription =
        _player.onAudioPositionChanged.listen(_onAudioPositionReceived);

    _audioStoppedSubscription = _player.onPlayerCompletion.listen((_) {
      _onAudioFinished();
    });

    final startDateTime = DateTime.now();

    final outputDirectory = await getTemporaryDirectory();
    final outputParentPath = outputDirectory.path;

    final originalExtension = extension(_moviePath);

    await Future.wait(
      state.choices.mapIndexed((index, choice) async {
        final paddedIndex = '$index'.padLeft(2, '0');
        final outputFileName = 'segment_$paddedIndex$originalExtension';
        final outputPath = '$outputParentPath/$outputFileName';

        final startPosition = AudioPositionHelper.formattedPosition(
          milliseconds: choice.segment.startMilliseconds,
        );
        final endPosition = AudioPositionHelper.formattedPosition(
          milliseconds: choice.segment.endMilliseconds,
        );

        await FFmpegKit.execute(
          '-ss $startPosition '
          '-to $endPosition '
          '-i $_moviePath '
          '-y '
          '$outputPath',
        );

        final choices = [...state.choices];
        final replacedChoice = choices[index].copyWith(path: outputPath);
        choices[index] = replacedChoice;
        state = state.copyWith(
          choices: choices,
        );
      }),
    );

    await Future.wait(
      state.choices.mapIndexed((index, choice) async {
        final paddedHash = '${choice.hashCode}'.padLeft(8, '0');
        final outputFileName = 'thumbnail_$paddedHash.png';
        final outputPath = '$outputParentPath/$outputFileName';

        final startPositionMilliseconds = choice.segment.startMilliseconds;
        final startPosition = AudioPositionHelper.formattedPosition(
          milliseconds: startPositionMilliseconds,
        );
        final loadEndPosition = AudioPositionHelper.formattedPosition(
          milliseconds: startPositionMilliseconds + 1000,
        );
        const outputFrameCount = 1;

        await FFmpegKit.execute(
          '-ss $startPosition '
          '-to $loadEndPosition '
          '-i $_moviePath '
          '-frames:v $outputFrameCount '
          '-f image2 '
          '-y '
          '$outputPath',
        );

        final choices = [...state.choices];
        final replacedChoice = choice.copyWith(thumbnailPath: outputPath);
        choices[index] = replacedChoice;
        state = state.copyWith(choices: choices);
      }),
    );

    final splitDurationMilliseconds = state.durationMilliseconds ~/ splitCount;

    await Future.wait(
      List.generate(splitCount, (index) async {
        final paddedIndex = '$index'.padLeft(2, '0');
        final outputFileName = 'split_$paddedIndex.png';
        final outputPath = '$outputParentPath/$outputFileName';

        final startPositionMilliseconds = splitDurationMilliseconds * index;
        final startPosition = AudioPositionHelper.formattedPosition(
          milliseconds: splitDurationMilliseconds * index,
        );
        final loadEndPosition = AudioPositionHelper.formattedPosition(
          milliseconds: startPositionMilliseconds + 1000,
        );
        const outputFrameCount = 1;

        await FFmpegKit.execute(
          '-ss $startPosition '
          '-to $loadEndPosition '
          '-i $_moviePath '
          '-frames:v $outputFrameCount '
          '-f image2 '
          '-y '
          '$outputPath ',
        );

        final splitThumbnails = [...state.splitThumbnails];
        splitThumbnails[index] = outputPath;
        state = state.copyWith(splitThumbnails: splitThumbnails);
      }),
    );

    final endDateTime = DateTime.now();

    final elapsedDuration = endDateTime.difference(startDateTime);
    debugPrint('Running time to output thumbnails: $elapsedDuration');
  }

  String getLocalPathName() {
    return _moviePath;
  }

  Future<void> play({required PlayerChoiceTrimmedMovie choice}) async {
    final url = choice.uri;
    if (url == null) {
      return;
    }

    final choices = _getPlayerChoices();

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
          originalList: choices,
        ) ??
        [...choices];

    final playingList = PlayerChoiceConverter.getTargetStatusReplaced(
      originalList: stoppedList,
      targetId: choice.id,
      newStatus: const PlayStatus.playing(position: 0),
    );

    _currentPlayingSegment = choice.segment;

    _setPlayerChoices(playingList);

    await _player.play(url);
  }

  Future<void> stop({required PlayerChoice choice}) async {
    final choices = _getPlayerChoices();

    final stoppedList = PlayerChoiceConverter.getTargetStopped(
      originalList: choices,
      targetId: choice.id,
    );

    _currentPlayingSegment = null;

    _setPlayerChoices(stoppedList);

    await _player.stop();
  }

  Future<SelectTrimmedSoundResult?> select({
    required PlayerChoiceTrimmedMovie choice,
    required int index,
  }) async {
    final outputPath = choice.path;
    if (outputPath == null) {
      return null;
    }

    final thumbnailPath = state.splitThumbnails[index];
    if (thumbnailPath == null) {
      return null;
    }

    state = state.copyWith(isUploading: true);

    await FFmpegKit.cancel();

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

    final originalFileNameWithoutExtension =
        basenameWithoutExtension(_moviePath);

    return SelectTrimmedSoundResult(
      uploaded: uploadedSound,
      label: '$originalFileNameWithoutExtension - セグメント${choice.id}',
      thumbnailPath: thumbnailPath,
    );
  }

  Future<void> _onAudioPositionReceived(Duration position) async {
    final segment = _currentPlayingSegment;
    if (segment == null) {
      return;
    }

    final duration = Duration(
      milliseconds: segment.endMilliseconds - segment.startMilliseconds,
    );

    final positionRatio = AudioPositionHelper.getPositionRatio(
      duration: duration,
      position: position,
    );

    final choices = _getPlayerChoices();

    final positionUpdatedList = PlayerChoiceConverter.getPositionUpdatedOrNull(
      originalList: choices,
      position: positionRatio,
    );
    if (positionUpdatedList == null) {
      return;
    }

    _setPlayerChoices(positionUpdatedList);
  }

  void _onAudioFinished() {
    final choices = _getPlayerChoices();

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
      originalList: choices,
    );
    if (stoppedList == null) {
      return;
    }

    _setPlayerChoices(stoppedList);
  }

  List<PlayerChoice> _getPlayerChoices() {
    return state.choices;
  }

  void _setPlayerChoices(List<PlayerChoice> choices) {
    state = state.copyWith(
      choices:
          choices.map((choice) => choice as PlayerChoiceTrimmedMovie).toList(),
    );
  }
}
