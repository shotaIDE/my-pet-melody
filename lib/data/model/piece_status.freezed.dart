// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'piece_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PieceStatusTearOff {
  const _$PieceStatusTearOff();

  _PieceStatusGenerating generating({required DateTime submitted}) {
    return _PieceStatusGenerating(
      submitted: submitted,
    );
  }

  _PieceStatusGenerated generated({required DateTime generated}) {
    return _PieceStatusGenerated(
      generated: generated,
    );
  }
}

/// @nodoc
const $PieceStatus = _$PieceStatusTearOff();

/// @nodoc
mixin _$PieceStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime submitted) generating,
    required TResult Function(DateTime generated) generated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(DateTime submitted)? generating,
    TResult Function(DateTime generated)? generated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime submitted)? generating,
    TResult Function(DateTime generated)? generated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PieceStatusGenerating value) generating,
    required TResult Function(_PieceStatusGenerated value) generated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PieceStatusGenerating value)? generating,
    TResult Function(_PieceStatusGenerated value)? generated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PieceStatusGenerating value)? generating,
    TResult Function(_PieceStatusGenerated value)? generated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PieceStatusCopyWith<$Res> {
  factory $PieceStatusCopyWith(
          PieceStatus value, $Res Function(PieceStatus) then) =
      _$PieceStatusCopyWithImpl<$Res>;
}

/// @nodoc
class _$PieceStatusCopyWithImpl<$Res> implements $PieceStatusCopyWith<$Res> {
  _$PieceStatusCopyWithImpl(this._value, this._then);

  final PieceStatus _value;
  // ignore: unused_field
  final $Res Function(PieceStatus) _then;
}

/// @nodoc
abstract class _$PieceStatusGeneratingCopyWith<$Res> {
  factory _$PieceStatusGeneratingCopyWith(_PieceStatusGenerating value,
          $Res Function(_PieceStatusGenerating) then) =
      __$PieceStatusGeneratingCopyWithImpl<$Res>;
  $Res call({DateTime submitted});
}

/// @nodoc
class __$PieceStatusGeneratingCopyWithImpl<$Res>
    extends _$PieceStatusCopyWithImpl<$Res>
    implements _$PieceStatusGeneratingCopyWith<$Res> {
  __$PieceStatusGeneratingCopyWithImpl(_PieceStatusGenerating _value,
      $Res Function(_PieceStatusGenerating) _then)
      : super(_value, (v) => _then(v as _PieceStatusGenerating));

  @override
  _PieceStatusGenerating get _value => super._value as _PieceStatusGenerating;

  @override
  $Res call({
    Object? submitted = freezed,
  }) {
    return _then(_PieceStatusGenerating(
      submitted: submitted == freezed
          ? _value.submitted
          : submitted // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_PieceStatusGenerating implements _PieceStatusGenerating {
  const _$_PieceStatusGenerating({required this.submitted});

  @override
  final DateTime submitted;

  @override
  String toString() {
    return 'PieceStatus.generating(submitted: $submitted)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PieceStatusGenerating &&
            const DeepCollectionEquality().equals(other.submitted, submitted));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(submitted));

  @JsonKey(ignore: true)
  @override
  _$PieceStatusGeneratingCopyWith<_PieceStatusGenerating> get copyWith =>
      __$PieceStatusGeneratingCopyWithImpl<_PieceStatusGenerating>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime submitted) generating,
    required TResult Function(DateTime generated) generated,
  }) {
    return generating(submitted);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(DateTime submitted)? generating,
    TResult Function(DateTime generated)? generated,
  }) {
    return generating?.call(submitted);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime submitted)? generating,
    TResult Function(DateTime generated)? generated,
    required TResult orElse(),
  }) {
    if (generating != null) {
      return generating(submitted);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PieceStatusGenerating value) generating,
    required TResult Function(_PieceStatusGenerated value) generated,
  }) {
    return generating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PieceStatusGenerating value)? generating,
    TResult Function(_PieceStatusGenerated value)? generated,
  }) {
    return generating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PieceStatusGenerating value)? generating,
    TResult Function(_PieceStatusGenerated value)? generated,
    required TResult orElse(),
  }) {
    if (generating != null) {
      return generating(this);
    }
    return orElse();
  }
}

abstract class _PieceStatusGenerating implements PieceStatus {
  const factory _PieceStatusGenerating({required DateTime submitted}) =
      _$_PieceStatusGenerating;

  DateTime get submitted;
  @JsonKey(ignore: true)
  _$PieceStatusGeneratingCopyWith<_PieceStatusGenerating> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$PieceStatusGeneratedCopyWith<$Res> {
  factory _$PieceStatusGeneratedCopyWith(_PieceStatusGenerated value,
          $Res Function(_PieceStatusGenerated) then) =
      __$PieceStatusGeneratedCopyWithImpl<$Res>;
  $Res call({DateTime generated});
}

/// @nodoc
class __$PieceStatusGeneratedCopyWithImpl<$Res>
    extends _$PieceStatusCopyWithImpl<$Res>
    implements _$PieceStatusGeneratedCopyWith<$Res> {
  __$PieceStatusGeneratedCopyWithImpl(
      _PieceStatusGenerated _value, $Res Function(_PieceStatusGenerated) _then)
      : super(_value, (v) => _then(v as _PieceStatusGenerated));

  @override
  _PieceStatusGenerated get _value => super._value as _PieceStatusGenerated;

  @override
  $Res call({
    Object? generated = freezed,
  }) {
    return _then(_PieceStatusGenerated(
      generated: generated == freezed
          ? _value.generated
          : generated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_PieceStatusGenerated implements _PieceStatusGenerated {
  const _$_PieceStatusGenerated({required this.generated});

  @override
  final DateTime generated;

  @override
  String toString() {
    return 'PieceStatus.generated(generated: $generated)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PieceStatusGenerated &&
            const DeepCollectionEquality().equals(other.generated, generated));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(generated));

  @JsonKey(ignore: true)
  @override
  _$PieceStatusGeneratedCopyWith<_PieceStatusGenerated> get copyWith =>
      __$PieceStatusGeneratedCopyWithImpl<_PieceStatusGenerated>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime submitted) generating,
    required TResult Function(DateTime generated) generated,
  }) {
    return generated(this.generated);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(DateTime submitted)? generating,
    TResult Function(DateTime generated)? generated,
  }) {
    return generated?.call(this.generated);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime submitted)? generating,
    TResult Function(DateTime generated)? generated,
    required TResult orElse(),
  }) {
    if (generated != null) {
      return generated(this.generated);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PieceStatusGenerating value) generating,
    required TResult Function(_PieceStatusGenerated value) generated,
  }) {
    return generated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PieceStatusGenerating value)? generating,
    TResult Function(_PieceStatusGenerated value)? generated,
  }) {
    return generated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PieceStatusGenerating value)? generating,
    TResult Function(_PieceStatusGenerated value)? generated,
    required TResult orElse(),
  }) {
    if (generated != null) {
      return generated(this);
    }
    return orElse();
  }
}

abstract class _PieceStatusGenerated implements PieceStatus {
  const factory _PieceStatusGenerated({required DateTime generated}) =
      _$_PieceStatusGenerated;

  DateTime get generated;
  @JsonKey(ignore: true)
  _$PieceStatusGeneratedCopyWith<_PieceStatusGenerated> get copyWith =>
      throw _privateConstructorUsedError;
}
