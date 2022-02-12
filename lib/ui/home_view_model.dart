import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/usecase/piece_use_case.dart';
import 'package:meow_music/ui/home_state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel({
    required PieceUseCase pieceUseCase,
  })  : _pieceUseCase = pieceUseCase,
        super(const HomeState()) {
    _setup();
  }

  final PieceUseCase _pieceUseCase;

  StreamSubscription<List<Piece>>? _subscription;

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();

    super.dispose();
  }

  Future<void> _setup() async {
    _subscription = _pieceUseCase.getPiecesStream().listen((pieces) {
      state = state.copyWith(pieces: pieces);
    });
  }
}
