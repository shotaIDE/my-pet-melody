import 'package:meow_music/data/model/template.dart';

abstract class DatabaseService {
  Future<List<TemplateDraft>> getTemplates();
}
