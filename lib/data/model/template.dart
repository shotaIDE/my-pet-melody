import 'package:freezed_annotation/freezed_annotation.dart';

part 'template.freezed.dart';

@freezed
class Template with _$Template {
  const factory Template({
    required String id,
    required String name,
    required String url,
  }) = _Template;
}
