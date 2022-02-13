// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'submission_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UploadResponse _$UploadResponseFromJson(Map<String, dynamic> json) {
  return _UploadResponse.fromJson(json);
}

/// @nodoc
class _$UploadResponseTearOff {
  const _$UploadResponseTearOff();

  _UploadResponse call({required String fileName}) {
    return _UploadResponse(
      fileName: fileName,
    );
  }

  UploadResponse fromJson(Map<String, Object?> json) {
    return UploadResponse.fromJson(json);
  }
}

/// @nodoc
const $UploadResponse = _$UploadResponseTearOff();

/// @nodoc
mixin _$UploadResponse {
  String get fileName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UploadResponseCopyWith<UploadResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadResponseCopyWith<$Res> {
  factory $UploadResponseCopyWith(
          UploadResponse value, $Res Function(UploadResponse) then) =
      _$UploadResponseCopyWithImpl<$Res>;
  $Res call({String fileName});
}

/// @nodoc
class _$UploadResponseCopyWithImpl<$Res>
    implements $UploadResponseCopyWith<$Res> {
  _$UploadResponseCopyWithImpl(this._value, this._then);

  final UploadResponse _value;
  // ignore: unused_field
  final $Res Function(UploadResponse) _then;

  @override
  $Res call({
    Object? fileName = freezed,
  }) {
    return _then(_value.copyWith(
      fileName: fileName == freezed
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$UploadResponseCopyWith<$Res>
    implements $UploadResponseCopyWith<$Res> {
  factory _$UploadResponseCopyWith(
          _UploadResponse value, $Res Function(_UploadResponse) then) =
      __$UploadResponseCopyWithImpl<$Res>;
  @override
  $Res call({String fileName});
}

/// @nodoc
class __$UploadResponseCopyWithImpl<$Res>
    extends _$UploadResponseCopyWithImpl<$Res>
    implements _$UploadResponseCopyWith<$Res> {
  __$UploadResponseCopyWithImpl(
      _UploadResponse _value, $Res Function(_UploadResponse) _then)
      : super(_value, (v) => _then(v as _UploadResponse));

  @override
  _UploadResponse get _value => super._value as _UploadResponse;

  @override
  $Res call({
    Object? fileName = freezed,
  }) {
    return _then(_UploadResponse(
      fileName: fileName == freezed
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UploadResponse implements _UploadResponse {
  const _$_UploadResponse({required this.fileName});

  factory _$_UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$$_UploadResponseFromJson(json);

  @override
  final String fileName;

  @override
  String toString() {
    return 'UploadResponse(fileName: $fileName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UploadResponse &&
            const DeepCollectionEquality().equals(other.fileName, fileName));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(fileName));

  @JsonKey(ignore: true)
  @override
  _$UploadResponseCopyWith<_UploadResponse> get copyWith =>
      __$UploadResponseCopyWithImpl<_UploadResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UploadResponseToJson(this);
  }
}

abstract class _UploadResponse implements UploadResponse {
  const factory _UploadResponse({required String fileName}) = _$_UploadResponse;

  factory _UploadResponse.fromJson(Map<String, dynamic> json) =
      _$_UploadResponse.fromJson;

  @override
  String get fileName;
  @override
  @JsonKey(ignore: true)
  _$UploadResponseCopyWith<_UploadResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

SubmitRequest _$SubmitRequestFromJson(Map<String, dynamic> json) {
  return _SubmitRequest.fromJson(json);
}

/// @nodoc
class _$SubmitRequestTearOff {
  const _$SubmitRequestTearOff();

  _SubmitRequest call(
      {required String userId,
      required String templateId,
      required List<String> fileNames}) {
    return _SubmitRequest(
      userId: userId,
      templateId: templateId,
      fileNames: fileNames,
    );
  }

  SubmitRequest fromJson(Map<String, Object?> json) {
    return SubmitRequest.fromJson(json);
  }
}

/// @nodoc
const $SubmitRequest = _$SubmitRequestTearOff();

/// @nodoc
mixin _$SubmitRequest {
  String get userId => throw _privateConstructorUsedError;
  String get templateId => throw _privateConstructorUsedError;
  List<String> get fileNames => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubmitRequestCopyWith<SubmitRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitRequestCopyWith<$Res> {
  factory $SubmitRequestCopyWith(
          SubmitRequest value, $Res Function(SubmitRequest) then) =
      _$SubmitRequestCopyWithImpl<$Res>;
  $Res call({String userId, String templateId, List<String> fileNames});
}

/// @nodoc
class _$SubmitRequestCopyWithImpl<$Res>
    implements $SubmitRequestCopyWith<$Res> {
  _$SubmitRequestCopyWithImpl(this._value, this._then);

  final SubmitRequest _value;
  // ignore: unused_field
  final $Res Function(SubmitRequest) _then;

  @override
  $Res call({
    Object? userId = freezed,
    Object? templateId = freezed,
    Object? fileNames = freezed,
  }) {
    return _then(_value.copyWith(
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: templateId == freezed
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      fileNames: fileNames == freezed
          ? _value.fileNames
          : fileNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$SubmitRequestCopyWith<$Res>
    implements $SubmitRequestCopyWith<$Res> {
  factory _$SubmitRequestCopyWith(
          _SubmitRequest value, $Res Function(_SubmitRequest) then) =
      __$SubmitRequestCopyWithImpl<$Res>;
  @override
  $Res call({String userId, String templateId, List<String> fileNames});
}

/// @nodoc
class __$SubmitRequestCopyWithImpl<$Res>
    extends _$SubmitRequestCopyWithImpl<$Res>
    implements _$SubmitRequestCopyWith<$Res> {
  __$SubmitRequestCopyWithImpl(
      _SubmitRequest _value, $Res Function(_SubmitRequest) _then)
      : super(_value, (v) => _then(v as _SubmitRequest));

  @override
  _SubmitRequest get _value => super._value as _SubmitRequest;

  @override
  $Res call({
    Object? userId = freezed,
    Object? templateId = freezed,
    Object? fileNames = freezed,
  }) {
    return _then(_SubmitRequest(
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: templateId == freezed
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      fileNames: fileNames == freezed
          ? _value.fileNames
          : fileNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SubmitRequest implements _SubmitRequest {
  const _$_SubmitRequest(
      {required this.userId,
      required this.templateId,
      required this.fileNames});

  factory _$_SubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$$_SubmitRequestFromJson(json);

  @override
  final String userId;
  @override
  final String templateId;
  @override
  final List<String> fileNames;

  @override
  String toString() {
    return 'SubmitRequest(userId: $userId, templateId: $templateId, fileNames: $fileNames)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubmitRequest &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            const DeepCollectionEquality()
                .equals(other.templateId, templateId) &&
            const DeepCollectionEquality().equals(other.fileNames, fileNames));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(userId),
      const DeepCollectionEquality().hash(templateId),
      const DeepCollectionEquality().hash(fileNames));

  @JsonKey(ignore: true)
  @override
  _$SubmitRequestCopyWith<_SubmitRequest> get copyWith =>
      __$SubmitRequestCopyWithImpl<_SubmitRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SubmitRequestToJson(this);
  }
}

abstract class _SubmitRequest implements SubmitRequest {
  const factory _SubmitRequest(
      {required String userId,
      required String templateId,
      required List<String> fileNames}) = _$_SubmitRequest;

  factory _SubmitRequest.fromJson(Map<String, dynamic> json) =
      _$_SubmitRequest.fromJson;

  @override
  String get userId;
  @override
  String get templateId;
  @override
  List<String> get fileNames;
  @override
  @JsonKey(ignore: true)
  _$SubmitRequestCopyWith<_SubmitRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

SubmitResponse _$SubmitResponseFromJson(Map<String, dynamic> json) {
  return _SubmitResponse.fromJson(json);
}

/// @nodoc
class _$SubmitResponseTearOff {
  const _$SubmitResponseTearOff();

  _SubmitResponse call({required String id, required String url}) {
    return _SubmitResponse(
      id: id,
      url: url,
    );
  }

  SubmitResponse fromJson(Map<String, Object?> json) {
    return SubmitResponse.fromJson(json);
  }
}

/// @nodoc
const $SubmitResponse = _$SubmitResponseTearOff();

/// @nodoc
mixin _$SubmitResponse {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubmitResponseCopyWith<SubmitResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitResponseCopyWith<$Res> {
  factory $SubmitResponseCopyWith(
          SubmitResponse value, $Res Function(SubmitResponse) then) =
      _$SubmitResponseCopyWithImpl<$Res>;
  $Res call({String id, String url});
}

/// @nodoc
class _$SubmitResponseCopyWithImpl<$Res>
    implements $SubmitResponseCopyWith<$Res> {
  _$SubmitResponseCopyWithImpl(this._value, this._then);

  final SubmitResponse _value;
  // ignore: unused_field
  final $Res Function(SubmitResponse) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$SubmitResponseCopyWith<$Res>
    implements $SubmitResponseCopyWith<$Res> {
  factory _$SubmitResponseCopyWith(
          _SubmitResponse value, $Res Function(_SubmitResponse) then) =
      __$SubmitResponseCopyWithImpl<$Res>;
  @override
  $Res call({String id, String url});
}

/// @nodoc
class __$SubmitResponseCopyWithImpl<$Res>
    extends _$SubmitResponseCopyWithImpl<$Res>
    implements _$SubmitResponseCopyWith<$Res> {
  __$SubmitResponseCopyWithImpl(
      _SubmitResponse _value, $Res Function(_SubmitResponse) _then)
      : super(_value, (v) => _then(v as _SubmitResponse));

  @override
  _SubmitResponse get _value => super._value as _SubmitResponse;

  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
  }) {
    return _then(_SubmitResponse(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SubmitResponse implements _SubmitResponse {
  const _$_SubmitResponse({required this.id, required this.url});

  factory _$_SubmitResponse.fromJson(Map<String, dynamic> json) =>
      _$$_SubmitResponseFromJson(json);

  @override
  final String id;
  @override
  final String url;

  @override
  String toString() {
    return 'SubmitResponse(id: $id, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubmitResponse &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.url, url));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(url));

  @JsonKey(ignore: true)
  @override
  _$SubmitResponseCopyWith<_SubmitResponse> get copyWith =>
      __$SubmitResponseCopyWithImpl<_SubmitResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SubmitResponseToJson(this);
  }
}

abstract class _SubmitResponse implements SubmitResponse {
  const factory _SubmitResponse({required String id, required String url}) =
      _$_SubmitResponse;

  factory _SubmitResponse.fromJson(Map<String, dynamic> json) =
      _$_SubmitResponse.fromJson;

  @override
  String get id;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$SubmitResponseCopyWith<_SubmitResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$FetchedPieceTearOff {
  const _$FetchedPieceTearOff();

  _FetchedPiece call({required String id, required String url}) {
    return _FetchedPiece(
      id: id,
      url: url,
    );
  }
}

/// @nodoc
const $FetchedPiece = _$FetchedPieceTearOff();

/// @nodoc
mixin _$FetchedPiece {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FetchedPieceCopyWith<FetchedPiece> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FetchedPieceCopyWith<$Res> {
  factory $FetchedPieceCopyWith(
          FetchedPiece value, $Res Function(FetchedPiece) then) =
      _$FetchedPieceCopyWithImpl<$Res>;
  $Res call({String id, String url});
}

/// @nodoc
class _$FetchedPieceCopyWithImpl<$Res> implements $FetchedPieceCopyWith<$Res> {
  _$FetchedPieceCopyWithImpl(this._value, this._then);

  final FetchedPiece _value;
  // ignore: unused_field
  final $Res Function(FetchedPiece) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$FetchedPieceCopyWith<$Res>
    implements $FetchedPieceCopyWith<$Res> {
  factory _$FetchedPieceCopyWith(
          _FetchedPiece value, $Res Function(_FetchedPiece) then) =
      __$FetchedPieceCopyWithImpl<$Res>;
  @override
  $Res call({String id, String url});
}

/// @nodoc
class __$FetchedPieceCopyWithImpl<$Res> extends _$FetchedPieceCopyWithImpl<$Res>
    implements _$FetchedPieceCopyWith<$Res> {
  __$FetchedPieceCopyWithImpl(
      _FetchedPiece _value, $Res Function(_FetchedPiece) _then)
      : super(_value, (v) => _then(v as _FetchedPiece));

  @override
  _FetchedPiece get _value => super._value as _FetchedPiece;

  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
  }) {
    return _then(_FetchedPiece(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_FetchedPiece implements _FetchedPiece {
  const _$_FetchedPiece({required this.id, required this.url});

  @override
  final String id;
  @override
  final String url;

  @override
  String toString() {
    return 'FetchedPiece(id: $id, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FetchedPiece &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.url, url));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(url));

  @JsonKey(ignore: true)
  @override
  _$FetchedPieceCopyWith<_FetchedPiece> get copyWith =>
      __$FetchedPieceCopyWithImpl<_FetchedPiece>(this, _$identity);
}

abstract class _FetchedPiece implements FetchedPiece {
  const factory _FetchedPiece({required String id, required String url}) =
      _$_FetchedPiece;

  @override
  String get id;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$FetchedPieceCopyWith<_FetchedPiece> get copyWith =>
      throw _privateConstructorUsedError;
}
