import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/data/model/template.dart';

part 'localized_template.freezed.dart';

@freezed
class LocalizedTemplate with _$LocalizedTemplate {
  const factory LocalizedTemplate({
    required String id,
    required String defaultName,
    required String localizedName,
    required DateTime publishedAt,
    required String musicUrl,
    required String thumbnailUrl,
  }) = _LocalizedTemplate;
}

extension LocalizedTemplateConverter on LocalizedTemplate {
  Template toTemplate() {
    return Template(
      id: id,
      name: localizedName,
      publishedAt: publishedAt,
      musicUrl: musicUrl,
      thumbnailUrl: thumbnailUrl,
    );
  }
}
