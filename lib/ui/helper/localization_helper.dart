import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/service/database_service.dart';
import 'package:my_pet_melody/data/service/device_service.dart';
import 'package:my_pet_melody/data/usecase/piece_use_case.dart';
import 'package:my_pet_melody/ui/model/localized_template.dart';

final localizedTemplatesProvider = FutureProvider.autoDispose((ref) async {
  final locale = ref.watch(deviceLocaleProvider);
  final localizedTemplateMetadataList =
      await ref.watch(localizedTemplateMetadataListProvider(locale).future);
  final templates = await ref.watch(templatesProvider.future);

  return templates.map(
    (template) {
      final localizedTemplateMetadata =
          localizedTemplateMetadataList.firstWhereOrNull(
        (templateMetadata) => templateMetadata.id == template.id,
      );

      return LocalizedTemplateGenerator.fromTemplate(
        template,
        localizedTemplateMetadata: localizedTemplateMetadata,
      );
    },
  ).toList();
});
