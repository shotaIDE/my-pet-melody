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

  _SubmitRequest call({required String userId}) {
    return _SubmitRequest(
      userId: userId,
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
  $Res call({String userId});
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
  }) {
    return _then(_value.copyWith(
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
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
  $Res call({String userId});
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
  }) {
    return _then(_SubmitRequest(
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SubmitRequest implements _SubmitRequest {
  const _$_SubmitRequest({required this.userId});

  factory _$_SubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$$_SubmitRequestFromJson(json);

  @override
  final String userId;

  @override
  String toString() {
    return 'SubmitRequest(userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubmitRequest &&
            const DeepCollectionEquality().equals(other.userId, userId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(userId));

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
  const factory _SubmitRequest({required String userId}) = _$_SubmitRequest;

  factory _SubmitRequest.fromJson(Map<String, dynamic> json) =
      _$_SubmitRequest.fromJson;

  @override
  String get userId;
  @override
  @JsonKey(ignore: true)
  _$SubmitRequestCopyWith<_SubmitRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
