import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/movie_segmentation.dart';
import 'package:my_pet_melody/data/usecase/submission_use_case.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/helper/audio_position_helper.dart';
import 'package:my_pet_melody/ui/model/localized_template.dart';
import 'package:my_pet_melody/ui/model/play_status.dart';
import 'package:my_pet_melody/ui/model/player_choice.dart';
import 'package:my_pet_melody/ui/select_trimmed_sound_state.dart';
import 'package:my_pet_melody/ui/set_piece_title_state.dart';
import 'package:my_pet_melody/ui/trim_sound_for_generation_state.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_trimmer/video_trimmer.dart';

class SelectTrimmedSoundViewModel
    extends StateNotifier<SelectTrimmedSoundState> {
  SelectTrimmedSoundViewModel({
    required Ref ref,
    required SelectTrimmedSoundArgs args,
  })  : _ref = ref,
        _template = args.template,
        _displayName = args.displayName,
        _moviePath = args.soundPath,
        _movieSegmentation = args.movieSegmentation,
        super(
          SelectTrimmedSoundState(
            displayName: args.displayName,
            choices: args.movieSegmentation.nonSilents
                .mapIndexed(
                  (index, segment) => PlayerChoiceTrimmedMovie(
                    status: const PlayStatus.stop(),
                    index: index + 1,
                    segment: segment,
                  ),
                )
                .toList(),
            equallyDividedThumbnailPaths: List.generate(
              DisplayDefinition.equallyDividedCount,
              (_) => null,
            ),
            durationMilliseconds: args.movieSegmentation.durationMilliseconds,
          ),
        );

  final Ref _ref;
  final LocalizedTemplate _template;
  final String _displayName;
  final String _moviePath;
  final MovieSegmentation _movieSegmentation;
  final _player = AudioPlayer();

  void Function(TrimSoundForGenerationArgs)?
      _moveToTrimSoundForGenerationScreen;
  VoidCallback? _displayTrimmingForGenerationIsRestricted;

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

  Future<void> setup({
    required void Function(TrimSoundForGenerationArgs)?
        moveToTrimSoundForGenerationScreen,
    required VoidCallback displayTrimmingForGenerationIsRestricted,
  }) async {
    _moveToTrimSoundForGenerationScreen = moveToTrimSoundForGenerationScreen;
    _displayTrimmingForGenerationIsRestricted =
        displayTrimmingForGenerationIsRestricted;

    _audioPositionSubscription =
        _player.onPositionChanged.listen(_onAudioPositionReceived);

    _audioStoppedSubscription = _player.onPlayerComplete.listen((_) {
      _onAudioFinished();
    });

    final startDateTime = DateTime.now();

    final outputDirectory = await getTemporaryDirectory();
    final outputParentPath = outputDirectory.path;

    await Future.wait(
      state.choices.mapIndexed((index, choice) async {
        final paddedHash = '${choice.hashCode}'.padLeft(8, '0');
        final outputFileName = 'choice-thumbnail_$paddedHash.png';
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
      List.generate(DisplayDefinition.equallyDividedCount, (index) async {
        final paddedIndex = '$index'.padLeft(2, '0');
        final outputFileName = 'equally-divided-thumbnail_$paddedIndex.png';
        final outputPath = '$outputParentPath/$outputFileName';

        final file = File(outputPath);
        final thumbnailBase64 =
            _movieSegmentation.equallyDividedThumbnailsBase64[index];
        final thumbnailBytes = base64Decode(thumbnailBase64);
        await file.writeAsBytes(thumbnailBytes);

        final equallyDividedThumbnailPaths = [
          ...state.equallyDividedThumbnailPaths,
        ];
        equallyDividedThumbnailPaths[index] = outputPath;
        state = state.copyWith(
          equallyDividedThumbnailPaths: equallyDividedThumbnailPaths,
        );
      }),
    );

    final movieFile = File(_moviePath);

    for (var index = 0; index < state.choices.length; index++) {
      final trimmer = Trimmer();
      // As workaround, call `loadVideo` every time.
      // When first call `loadVideo` once and call `saveTrimmedVideo` multiple,
      // trimmed movies are sometimes saved in the same file.
      await trimmer.loadVideo(videoFile: movieFile);

      final choice = state.choices[index];

      final trimmedPathCompleter = Completer<String?>();

      await trimmer.saveTrimmedVideo(
        startValue: choice.segment.startMilliseconds.toDouble(),
        endValue: choice.segment.endMilliseconds.toDouble(),
        onSave: (value) {
          trimmedPathCompleter.complete(value);
        },
      );

      final trimmedPath = await trimmedPathCompleter.future;
      if (trimmedPath == null) {
        continue;
      }

      debugPrint('Trimmed path: $trimmedPath');

      final choices = [...state.choices];
      final replacedChoice = choices[index].copyWith(path: trimmedPath);
      choices[index] = replacedChoice;
      state = state.copyWith(
        choices: choices,
      );
    }

    final endDateTime = DateTime.now();

    final elapsedDuration = endDateTime.difference(startDateTime);
    debugPrint('Running time to output thumbnails: $elapsedDuration');
  }

  Future<void> onTrimManually() async {
    final isAvailable = _ref.read(isAvailableToTrimSoundForGenerationProvider);

    if (isAvailable) {
      final args = TrimSoundForGenerationArgs(
        template: _template,
        displayName: _displayName,
        soundPath: _moviePath,
      );
      _moveToTrimSoundForGenerationScreen?.call(args);
      return;
    }

    _displayTrimmingForGenerationIsRestricted?.call();
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
      newStatus: const PlayStatus.loadingMedia(),
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

  Future<void> select({required int index}) async {
    state = state.copyWith(
      selectedIndex: index,
      isAvailableGoNext: true,
    );
  }

  Future<SetPieceTitleArgs?> onGoNext() async {
    final index = state.selectedIndex!;
    final choice = state.choices[index];
    final outputPath = choice.path;
    if (outputPath == null) {
      return null;
    }

    state = state.copyWith(isUploading: true);

    final trimmer = Trimmer();
    final movieFile = File(_moviePath);
    await trimmer.loadVideo(videoFile: movieFile);

    final thumbnailPathCompleter = Completer<String?>();

    await trimmer.saveTrimmedVideo(
      startValue: choice.segment.startMilliseconds.toDouble(),
      endValue: choice.segment.startMilliseconds.toDouble(),
      onSave: (value) {
        thumbnailPathCompleter.complete(value);
      },
      outputType: OutputType.gif,
    );

    final thumbnailPath = await thumbnailPathCompleter.future;
    if (thumbnailPath == null) {
      state = state.copyWith(isUploading: false);

      return null;
    }

    final uploadAction = await _ref.read(uploadActionProvider.future);
    final outputFile = File(outputPath);
    final uploadedSound = await uploadAction(
      outputFile,
      fileName: basename(outputPath),
    );
    if (uploadedSound == null) {
      state = state.copyWith(isUploading: false);

      return null;
    }

    state = state.copyWith(isUploading: false);

    return SetPieceTitleArgs(
      template: _template,
      sounds: [uploadedSound],
      thumbnailLocalPath: thumbnailPath,
      displayName: _displayName,
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

    final positionRatio = getAudioPositionRatio(
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
