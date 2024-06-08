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

extension LocalizedTemplateGenerator on LocalizedTemplate {
  static LocalizedTemplate fromTemplate(
    Template template, {
    LocalizedTemplateMetadata? localizedTemplateMetadata,
  }) {
    if (localizedTemplateMetadata == null) {
      return LocalizedTemplate(
        id: template.id,
        defaultName: template.name,
        localizedName: template.name,
        publishedAt: template.publishedAt,
        musicUrl: template.musicUrl,
        thumbnailUrl: template.thumbnailUrl,
      );
    }

    return LocalizedTemplate(
      id: template.id,
      defaultName: template.name,
      localizedName: localizedTemplateMetadata.name,
      publishedAt: template.publishedAt,
      musicUrl: template.musicUrl,
      thumbnailUrl: template.thumbnailUrl,
    );
  }
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
