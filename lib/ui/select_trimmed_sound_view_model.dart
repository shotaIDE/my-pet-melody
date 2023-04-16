import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/movie_segmentation.dart';
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
    required Ref ref,
    required SelectTrimmedSoundArgs args,
  })  : _ref = ref,
        _fileName = args.fileName,
        _moviePath = args.soundPath,
        _movieSegmentation = args.movieSegmentation,
        super(
          SelectTrimmedSoundState(
            fileName: args.fileName,
            choices: args.movieSegmentation.nonSilents
                .mapIndexed(
                  (index, segment) => PlayerChoiceTrimmedMovie(
                    status: const PlayStatus.stop(),
                    index: index + 1,
                    segment: segment,
                  ),
                )
                .toList(),
            splitThumbnails: List.generate(splitCount, (_) => null),
            durationMilliseconds: args.movieSegmentation.durationMilliseconds,
          ),
        );

  static const splitCount = 10;

  final Ref _ref;
  final String _fileName;
  final String _moviePath;
  final MovieSegmentation _movieSegmentation;
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
        _player.onPositionChanged.listen(_onAudioPositionReceived);

    _audioStoppedSubscription = _player.onPlayerComplete.listen((_) {
      _onAudioFinished();
    });

    final startDateTime = DateTime.now();

    final outputDirectory = await getTemporaryDirectory();
    final outputParentPath = outputDirectory.path;

    final originalFileNameWithoutExtension =
        basenameWithoutExtension(_moviePath);
    final originalExtension = extension(_moviePath);

    await Future.wait(
      state.choices.mapIndexed((index, choice) async {
        final paddedHash = '${choice.hashCode}'.padLeft(8, '0');
        final outputFileName = 'thumbnail_$paddedHash.png';
        final outputPath = '$outputParentPath/$outputFileName';

        final file = File(outputPath);
        final thumbnailBase64 =
            _movieSegmentation.nonSilents[index].thumbnailBase64;
        final thumbnailBytes = base64Decode(thumbnailBase64);
        await file.writeAsBytes(thumbnailBytes);

        final choices = [...state.choices];
        final replacedChoice = choice.copyWith(thumbnailPath: outputPath);
        choices[index] = replacedChoice;
        state = state.copyWith(choices: choices);
      }),
    );

    await Future.wait(
      List.generate(splitCount, (index) async {
        final paddedIndex = '$index'.padLeft(2, '0');
        final outputFileName = 'split-$paddedIndex.png';
        final outputPath = '$outputParentPath/$outputFileName';

        final file = File(outputPath);
        final thumbnailBase64 =
            _movieSegmentation.equallyDividedThumbnailsBase64[index];
        final thumbnailBytes = base64Decode(thumbnailBase64);
        await file.writeAsBytes(thumbnailBytes);

        final splitThumbnails = [...state.splitThumbnails];
        splitThumbnails[index] = outputPath;
        state = state.copyWith(splitThumbnails: splitThumbnails);
      }),
    );

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

    final endDateTime = DateTime.now();

    final elapsedDuration = endDateTime.difference(startDateTime);
    debugPrint('Running time to output thumbnails: $elapsedDuration');
  }

  String getLocalPathName() {
    return _moviePath;
  }

  Future<void> play({required PlayerChoiceTrimmedMovie choice}) async {
    final path = choice.uri;
    if (path == null) {
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

    final source = DeviceFileSource(path);

    await _player.play(source);
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

    final uploadAction = await _ref.read(uploadActionProvider.future);
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
      displayName: '$_fileName - セグメント${choice.id}',
      thumbnailLocalPath: thumbnailPath,
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
