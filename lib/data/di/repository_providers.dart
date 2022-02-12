import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/repository/piece_repository.dart';

final pieceRepositoryProvider = Provider(
  (_) => PieceRepository(),
);
