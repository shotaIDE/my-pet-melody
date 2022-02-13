import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/usecase/piece_use_case.dart';
import 'package:meow_music/ui/home_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<void> share({required Piece piece}) async {
    state = state.copyWith(isProcessing: true);

    final dio = Dio();

    final parentDirectory = await getApplicationDocumentsDirectory();
    final parentPath = parentDirectory.path;
    final directory = Directory('$parentPath/${piece.name}');
    await directory.create(recursive: true);

    final path = '${directory.path}/${piece.name}.mp3';

    await dio.download(piece.url, path);

    await Share.shareFiles([path]);

    state = state.copyWith(isProcessing: false);
  }

  Future<void> _setup() async {
    final piecesStream = await _pieceUseCase.getPiecesStream();
    _subscription = piecesStream.listen((pieces) {
      state = state.copyWith(pieces: pieces);
    });
  }
}
