import 'package:meow_music/data/model/template.dart';

class SubmissionRepository {
  Future<List<Template>> getTemplates() async {
    return [
      const Template(
        id: 'happy_birthday',
        name: 'Happy Birthday',
        url: 'about:blank',
      ),
    ];
  }
}
