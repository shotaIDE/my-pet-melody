// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'piece.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PieceTearOff {
  const _$PieceTearOff();

  _Piece call(
      {required String id,
      required String name,
      required PieceStatus status,
      required String url}) {
    return _Piece(
      id: id,
      name: name,
      status: status,
      url: url,
    );
  }
}

/// @nodoc
const $Piece = _$PieceTearOff();

/// @nodoc
mixin _$Piece {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  PieceStatus get status => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PieceCopyWith<Piece> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PieceCopyWith<$Res> {
  factory $PieceCopyWith(Piece value, $Res Function(Piece) then) =
      _$PieceCopyWithImpl<$Res>;
  $Res call({String id, String name, PieceStatus status, String url});

  $PieceStatusCopyWith<$Res> get status;
}

/// @nodoc
class _$PieceCopyWithImpl<$Res> implements $PieceCopyWith<$Res> {
  _$PieceCopyWithImpl(this._value, this._then);

  final Piece _value;
  // ignore: unused_field
  final $Res Function(Piece) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? status = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PieceStatus,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  $PieceStatusCopyWith<$Res> get status {
    return $PieceStatusCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value));
    });
  }
}

/// @nodoc
abstract class _$PieceCopyWith<$Res> implements $PieceCopyWith<$Res> {
  factory _$PieceCopyWith(_Piece value, $Res Function(_Piece) then) =
      __$PieceCopyWithImpl<$Res>;
  @override
  $Res call({String id, String name, PieceStatus status, String url});

  @override
  $PieceStatusCopyWith<$Res> get status;
}

/// @nodoc
class __$PieceCopyWithImpl<$Res> extends _$PieceCopyWithImpl<$Res>
    implements _$PieceCopyWith<$Res> {
  __$PieceCopyWithImpl(_Piece _value, $Res Function(_Piece) _then)
      : super(_value, (v) => _then(v as _Piece));

  @override
  _Piece get _value => super._value as _Piece;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? status = freezed,
    Object? url = freezed,
  }) {
    return _then(_Piece(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PieceStatus,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Piece implements _Piece {
  const _$_Piece(
      {required this.id,
      required this.name,
      required this.status,
      required this.url});

  @override
  final String id;
  @override
  final String name;
  @override
  final PieceStatus status;
  @override
  final String url;

  @override
  String toString() {
    return 'Piece(id: $id, name: $name, status: $status, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Piece &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.url, url));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(url));

  @JsonKey(ignore: true)
  @override
  _$PieceCopyWith<_Piece> get copyWith =>
      __$PieceCopyWithImpl<_Piece>(this, _$identity);
}

abstract class _Piece implements Piece {
  const factory _Piece(
      {required String id,
      required String name,
      required PieceStatus status,
      required String url}) = _$_Piece;

  @override
  String get id;
  @override
  String get name;
  @override
  PieceStatus get status;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$PieceCopyWith<_Piece> get copyWith => throw _privateConstructorUsedError;
}
