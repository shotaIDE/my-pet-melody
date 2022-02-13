import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/api_providers.dart';
import 'package:meow_music/data/repository/remote/submission_remote_data_source.dart';

final submissionRemoteDataSourceProvider = Provider(
  (ref) => SubmissionRemoteDataSource(
    api: ref.watch(submissionApiProvider),
  ),
);
