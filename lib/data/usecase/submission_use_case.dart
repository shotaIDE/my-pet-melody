import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/repository/submission_repository.dart';

class SubmissionUseCase {
  SubmissionUseCase({required SubmissionRepository repository})
      : _repository = repository;

  final SubmissionRepository _repository;

  Future<List<Template>> getTemplates() async {
    return _repository.getTemplates();
  }
}
