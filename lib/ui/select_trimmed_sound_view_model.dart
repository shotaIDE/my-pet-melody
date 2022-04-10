import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/non_silence_segment.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
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
    required SubmissionUseCase submissionUseCase,
    required SelectTrimmedSoundArgs args,
  })  : _submissionUseCase = submissionUseCase,
        _moviePath = args.soundPath,
        super(
          SelectTrimmedSoundState(
            choices: args.segments
                .map(
                  (segment) => PlayerChoiceTrimmedMovie(
                    status: const PlayStatus.stop(),
                    path: args.soundPath,
                    segment: segment,
                  ),
                )
                .toList(),
          ),
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

  Future<void> setup() async {
    _audioPositionSubscription =
        _player.onAudioPositionChanged.listen(_onAudioPositionReceived);

    _audioStoppedSubscription = _player.onPlayerCompletion.listen((_) {
      _onAudioFinished();
    });

    final outputDirectory = await getTemporaryDirectory();
    final outputParentPath = outputDirectory.path;

    final int durationMilliseconds;
    final session = await FFprobeKit.getMediaInformation(_moviePath);
    final durationString = session.getMediaInformation()?.getDuration();
    if (durationString != null) {
      final durationSeconds = double.parse(durationString);
      durationMilliseconds = (durationSeconds * 1000).toInt();
    } else {
      // MediaInformation が取得できなかった場合、もう一つの手段で長さを取得する
      // https://pub.dev/packages/ffmpeg_kit_flutter#3-using
      durationMilliseconds = await session.getDuration();
    }
    final durationSeconds = durationMilliseconds / 1000;

    state = state.copyWith(
      lengthMilliseconds: durationMilliseconds,
    );

    final thumbnailFilePaths = List.generate(state.choices.length, (index) {
      final paddedIndex = '$index'.padLeft(6, '0');
      final outputFileName = 'thumbnail_$paddedIndex.png';
      return '$outputParentPath/$outputFileName';
    });

    await Future.wait(
      state.choices.mapIndexed((index, choice) async {
        final startSeconds = choice.segment.startMilliseconds / 1000;
        const outputFrameCount = 1;
        final outputPath = thumbnailFilePaths[index];

        await FFmpegKit.execute(
          '-i $_moviePath '
          '-ss $startSeconds '
          '-frames:v $outputFrameCount '
          '-f image2 '
          '-y '
          '$outputPath',
        );
      }),
    );

    state = state.copyWith(
      choices: state.choices
          .mapIndexed(
            (index, choice) => choice.copyWith(
              thumbnailPath: thumbnailFilePaths[index],
            ),
          )
          .toList(),
    );

    final splitDurationSeconds = durationSeconds / splitCount;

    final splitThumbnailFilePaths = List.generate(splitCount, (index) {
      final paddedIndex = '$index'.padLeft(2, '0');
      final outputFileName = 'split_$paddedIndex.png';
      return '$outputParentPath/$outputFileName';
    });

    await Future.wait(
      List.generate(splitCount, (index) async {
        final startSeconds = splitDurationSeconds * index;
        const outputFrameCount = 1;

        final outputPath = splitThumbnailFilePaths[index];

        await FFmpegKit.execute(
          '-i $_moviePath '
          '-ss $startSeconds '
          '-frames:v $outputFrameCount '
          '-f image2 '
          '-y '
          '$outputPath',
        );
      }),
    );

    state = state.copyWith(
      splitThumbnails: splitThumbnailFilePaths,
    );
  }

  String getLocalPathName() {
    return _moviePath;
  }

  Future<void> play({required PlayerChoiceTrimmedMovie choice}) async {
    final url = choice.url;
    if (url == null) {
      return;
    }

    final choices = _getPlayerChoices();

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
          originalList: choices,
        ) ??
        [...choices];

    final playingList = PlayerChoiceConverter.getTargetReplaced(
      originalList: stoppedList,
      targetId: choice.id,
      newPlayable:
          choice.copyWith(status: const PlayStatus.playing(position: 0)),
    );

    _currentPlayingSegment = choice.segment;

    _setPlayerChoices(playingList);

    await _player.play(
      url,
      position: Duration(milliseconds: choice.segment.startMilliseconds),
    );
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

  Future<UploadedSound?> select({
    required PlayerChoiceTrimmedMovie choice,
  }) async {
    final startSeconds = choice.segment.startMilliseconds / 1000;
    final lengthSeconds =
        (choice.segment.endMilliseconds - choice.segment.startMilliseconds) /
            1000;

    final outputDirectory = await getTemporaryDirectory();
    final outputParentPath = outputDirectory.path;
    const outputFileName = 'trimmed.mov';
    final outputPath = '$outputParentPath/$outputFileName';

    await FFmpegKit.execute(
      '-i $_moviePath '
      '-ss $startSeconds '
      '-t $lengthSeconds '
      '-y '
      '$outputPath',
    );

    final outputFile = File(outputPath);

    final uploadedSound = await _submissionUseCase.upload(
      outputFile,
      fileName: basename(outputFileName),
    );

    if (uploadedSound == null) {
      return null;
    }

    return uploadedSound;
  }

  void _onAudioPositionReceived(Duration position) {
    final segment = _currentPlayingSegment;
    if (segment == null) {
      return;
    }

    final length = Duration(
      milliseconds: segment.endMilliseconds - segment.startMilliseconds,
    );
    final fixedPosition = Duration(
      milliseconds: position.inMilliseconds - segment.startMilliseconds,
    );

    final positionRatio = AudioPositionHelper.getPositionRatio(
      length: length,
      position: fixedPosition,
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
