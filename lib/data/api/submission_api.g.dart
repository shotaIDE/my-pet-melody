// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UploadResponse _$$_UploadResponseFromJson(Map<String, dynamic> json) =>
    _$_UploadResponse(
      fileName: json['fileName'] as String,
    );

Map<String, dynamic> _$$_UploadResponseToJson(_$_UploadResponse instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
    };

_$_SubmitRequest _$$_SubmitRequestFromJson(Map<String, dynamic> json) =>
    _$_SubmitRequest(
      userId: json['userId'] as String,
      templateId: json['templateId'] as String,
      fileNames:
          (json['fileNames'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_SubmitRequestToJson(_$_SubmitRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'templateId': instance.templateId,
      'fileNames': instance.fileNames,
    };

_$_SubmitResponse _$$_SubmitResponseFromJson(Map<String, dynamic> json) =>
    _$_SubmitResponse(
      id: json['id'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$$_SubmitResponseToJson(_$_SubmitResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
    };
