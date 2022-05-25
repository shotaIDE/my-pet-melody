import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/template.dart';

abstract class DatabaseService {
  Future<List<TemplateDraft>> getTemplates();

  Stream<List<PieceDraft>> piecesStream({required String userId});
}
