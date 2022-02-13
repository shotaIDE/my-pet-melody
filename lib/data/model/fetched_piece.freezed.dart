// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'fetched_piece.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
