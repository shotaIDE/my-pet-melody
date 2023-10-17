import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/definitions/types.dart';
import 'package:my_pet_melody/data/model/make_piece_availability.dart';
import 'package:my_pet_melody/data/model/piece.dart';
import 'package:my_pet_melody/data/usecase/piece_use_case.dart';
import 'package:my_pet_melody/data/usecase/submission_use_case.dart';
import 'package:my_pet_melody/ui/helper/audio_position_helper.dart';
import 'package:my_pet_melody/ui/home_state.dart';
import 'package:my_pet_melody/ui/model/play_status.dart';
import 'package:my_pet_melody/ui/model/player_choice.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel({
    required Ref ref,
    required Listener listener,
  })  : _ref = ref,
        super(const HomeState()) {
    _setup(listener: listener);
  }

  final Ref _ref;

  final _player = AudioPlayer();

  VoidCallback? _moveToSelectTemplateScreen;
  VoidCallback? _displayPieceMakingIsRestrictedByFreePlan;
  Future<ConfirmToMakePieceResult?> Function()?
      _displayPieceMakingIsRestrictedByPremiumPlan;
  Duration? _currentAudioDuration;
  StreamSubscription<List<Piece>>? _piecesSubscription;
  StreamSubscription<Duration>? _audioDurationSubscription;
  StreamSubscription<Duration>? _audioPositionSubscription;
  StreamSubscription<void>? _audioStoppedSubscription;

  @override
  Future<void> dispose() async {
    final tasks = [
      _piecesSubscription?.cancel(),
      _audioDurationSubscription?.cancel(),
      _audioPositionSubscription?.cancel(),
      _audioStoppedSubscription?.cancel(),
    ].whereType<Future<void>>().toList();

    await Future.wait<void>(tasks);

    super.dispose();
  }

  void registerListener({
    required VoidCallback moveToSelectTemplateScreen,
    required VoidCallback displayPieceMakingIsRestrictedByFreePlan,
    required Future<ConfirmToMakePieceResult?> Function()
        displayPieceMakingIsRestrictedByPremiumPlan,
  }) {
    _moveToSelectTemplateScreen = moveToSelectTemplateScreen;
    _displayPieceMakingIsRestrictedByFreePlan =
        displayPieceMakingIsRestrictedByFreePlan;
    _displayPieceMakingIsRestrictedByPremiumPlan =
        displayPieceMakingIsRestrictedByPremiumPlan;
  }

  Future<void> onMakePiece() async {
    await _beforeHideScreen();

    final makePieceAvailability =
        await _ref.read(makePieceAvailabilityProvider.future);
    await makePieceAvailability.when(
      available: () {
        _moveToSelectTemplateScreen?.call();
      },
      unavailable: (reason) async {
        switch (reason) {
          case MakePieceUnavailableReason.hasMaxPiecesAllowedOnFreePlan:
            _displayPieceMakingIsRestrictedByFreePlan?.call();
            break;
          case MakePieceUnavailableReason.hasMaxPiecesAllowedOnPremiumPlan:
            final result =
                await _displayPieceMakingIsRestrictedByPremiumPlan?.call();
            if (result == null) {
              return;
            }

            if (result.requestedDoNotShowAgain) {
              // TODO: Save the user's preference
            }

            result.maybeMap(
              continued: (_) {
                _moveToSelectTemplateScreen?.call();
              },
              orElse: () {},
            );
            break;
        }
      },
    );
  }

  Future<void> _setup({required Listener listener}) async {
    listener<Future<List<Piece>>>(
      piecesProvider.future,
      (_, next) async {
        final pieceDataList = await next;

        final pieces = pieceDataList
            .map(
              (piece) => PlayerChoicePiece(
                status: const PlayStatus.stop(),
                piece: piece,
              ),
            )
            .toList();

        final previousPlaying = state.pieces?.firstWhereOrNull(
          (piece) => piece.status.map(
            stop: (_) => false,
            loadingMedia: (_) => true,
            playing: (_) => true,
          ),
        );

        final List<PlayerChoicePiece> fixedPieces;
        if (previousPlaying != null) {
          fixedPieces = PlayerChoiceConverter.getTargetStatusReplaced(
            originalList: pieces,
            targetId: previousPlaying.id,
            newStatus: previousPlaying.status,
          ).whereType<PlayerChoicePiece>().toList();
        } else {
          fixedPieces = pieces;
        }

        state = state.copyWith(
          pieces: fixedPieces,
        );
      },
      fireImmediately: true,
    );

    _audioDurationSubscription = _player.onDurationChanged.listen((duration) {
      _currentAudioDuration = duration;
    });

    _audioPositionSubscription =
        _player.onPositionChanged.listen(_onAudioPositionReceived);

    _audioStoppedSubscription = _player.onPlayerComplete.listen((_) {
      _onAudioFinished();
    });
  }

  void _onAudioPositionReceived(Duration position) {
    final duration = _currentAudioDuration;
    if (duration == null) {
      return;
    }

    final positionRatio = AudioPositionHelper.getPositionRatio(
      duration: duration,
      position: position,
    );

    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final positionUpdatedList = PlayerChoiceConverter.getPositionUpdatedOrNull(
      originalList: pieces,
      position: positionRatio,
    );
    if (positionUpdatedList == null) {
      return;
    }

    state = state.copyWith(
      pieces: positionUpdatedList.whereType<PlayerChoicePiece>().toList(),
    );
  }

  void _onAudioFinished() {
    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
      originalList: pieces,
    );
    if (stoppedList == null) {
      return;
    }

    state = state.copyWith(
      pieces: stoppedList.whereType<PlayerChoicePiece>().toList(),
    );
  }

  Future<void> _beforeHideScreen() async {
    final pieces = state.pieces;
    if (pieces == null) {
      return;
    }

    final stoppedList =
        PlayerChoiceConverter.getStoppedOrNull(originalList: pieces);

    if (stoppedList != null) {
      state = state.copyWith(
        pieces: stoppedList.whereType<PlayerChoicePiece>().toList(),
      );
    }

    await _player.stop();
  }
}
