import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/api/my_dio.dart';
import 'package:meow_music/data/api/submission_api.dart';

final dioProvider = Provider(
  (ref) => MyDio(),
);

final submissionApiProvider = Provider(
  (ref) => SubmissionApi(
    dio: ref.watch(dioProvider),
  ),
);
