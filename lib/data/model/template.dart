import 'package:freezed_annotation/freezed_annotation.dart';

part 'template.freezed.dart';

@freezed
class Template with _$Template {
  const factory Template({
    required String id,
    required String name,
    required DateTime publishedAt,
    required String musicUrl,
    required String thumbnailUrl,
  }) = _Template;
}

@freezed
class TemplateDraft with _$TemplateDraft {
  const factory TemplateDraft({
    required String id,
    required String name,
    required DateTime publishedAt,
  }) = _TemplateDraft;
}
