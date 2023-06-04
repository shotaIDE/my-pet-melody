import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/api/my_dio.dart';
import 'package:my_pet_melody/data/api/storage_api.dart';
import 'package:my_pet_melody/data/api/submission_api.dart';

final dioProvider = Provider(
  (ref) => MyDio(),
);

final submissionApiProvider = Provider(
  (ref) => SubmissionApi(
    dio: ref.watch(dioProvider),
  ),
);

final storageApiProvider = Provider(
  (ref) => StorageApi(
    dio: ref.watch(dioProvider),
  ),
);
