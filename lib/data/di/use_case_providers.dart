import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/repository_providers.dart';
import 'package:meow_music/data/usecase/piece_use_case.dart';

final pieceUseCaseProvider = Provider(
  (ref) => PieceUseCase(
    repository: ref.watch(pieceRepositoryProvider),
  ),
);
