import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/repository/remote/submission_remote_data_source.dart';

class SubmissionRepository {
  SubmissionRepository({required SubmissionRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final SubmissionRemoteDataSource _remote;

  Future<List<Template>> getTemplates() async {
    return [
      const Template(
        id: 'happy_birthday',
        name: 'Happy Birthday',
        url: 'about:blank',
      ),
    ];
  }

  Future<void> submit({
    required String userId,
  }) async {
    return _remote.submit(userId: userId);
  }
}
