// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'root_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$RootStateTearOff {
  const _$RootStateTearOff();

  _RootState call({bool? shouldLaunchOnboarding = null}) {
    return _RootState(
      shouldLaunchOnboarding: shouldLaunchOnboarding,
    );
  }
}

/// @nodoc
const $RootState = _$RootStateTearOff();

/// @nodoc
mixin _$RootState {
  bool? get shouldLaunchOnboarding => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RootStateCopyWith<RootState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RootStateCopyWith<$Res> {
  factory $RootStateCopyWith(RootState value, $Res Function(RootState) then) =
      _$RootStateCopyWithImpl<$Res>;
  $Res call({bool? shouldLaunchOnboarding});
}

/// @nodoc
class _$RootStateCopyWithImpl<$Res> implements $RootStateCopyWith<$Res> {
  _$RootStateCopyWithImpl(this._value, this._then);

  final RootState _value;
  // ignore: unused_field
  final $Res Function(RootState) _then;

  @override
  $Res call({
    Object? shouldLaunchOnboarding = freezed,
  }) {
    return _then(_value.copyWith(
      shouldLaunchOnboarding: shouldLaunchOnboarding == freezed
          ? _value.shouldLaunchOnboarding
          : shouldLaunchOnboarding // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
abstract class _$RootStateCopyWith<$Res> implements $RootStateCopyWith<$Res> {
  factory _$RootStateCopyWith(
          _RootState value, $Res Function(_RootState) then) =
      __$RootStateCopyWithImpl<$Res>;
  @override
  $Res call({bool? shouldLaunchOnboarding});
}

/// @nodoc
class __$RootStateCopyWithImpl<$Res> extends _$RootStateCopyWithImpl<$Res>
    implements _$RootStateCopyWith<$Res> {
  __$RootStateCopyWithImpl(_RootState _value, $Res Function(_RootState) _then)
      : super(_value, (v) => _then(v as _RootState));

  @override
  _RootState get _value => super._value as _RootState;

  @override
  $Res call({
    Object? shouldLaunchOnboarding = freezed,
  }) {
    return _then(_RootState(
      shouldLaunchOnboarding: shouldLaunchOnboarding == freezed
          ? _value.shouldLaunchOnboarding
          : shouldLaunchOnboarding // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$_RootState implements _RootState {
  const _$_RootState({this.shouldLaunchOnboarding = null});

  @JsonKey()
  @override
  final bool? shouldLaunchOnboarding;

  @override
  String toString() {
    return 'RootState(shouldLaunchOnboarding: $shouldLaunchOnboarding)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RootState &&
            const DeepCollectionEquality()
                .equals(other.shouldLaunchOnboarding, shouldLaunchOnboarding));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(shouldLaunchOnboarding));

  @JsonKey(ignore: true)
  @override
  _$RootStateCopyWith<_RootState> get copyWith =>
      __$RootStateCopyWithImpl<_RootState>(this, _$identity);
}

abstract class _RootState implements RootState {
  const factory _RootState({bool? shouldLaunchOnboarding}) = _$_RootState;

  @override
  bool? get shouldLaunchOnboarding;
  @override
  @JsonKey(ignore: true)
  _$RootStateCopyWith<_RootState> get copyWith =>
      throw _privateConstructorUsedError;
}
