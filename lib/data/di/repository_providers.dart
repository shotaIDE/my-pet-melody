import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/repository/piece_repository.dart';
import 'package:meow_music/data/repository/submission_repository.dart';

final pieceRepositoryProvider = Provider(
  (_) => PieceRepository(),
);

final submissionRepositoryProvider = Provider(
  (_) => SubmissionRepository(),
);
