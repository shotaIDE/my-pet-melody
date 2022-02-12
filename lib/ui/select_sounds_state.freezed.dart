// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'select_sounds_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SelectSoundsStateTearOff {
  const _$SelectSoundsStateTearOff();

  _SelectSoundsState call(
      {required Template template, bool isProcessing = false}) {
    return _SelectSoundsState(
      template: template,
      isProcessing: isProcessing,
    );
  }
}

/// @nodoc
const $SelectSoundsState = _$SelectSoundsStateTearOff();

/// @nodoc
mixin _$SelectSoundsState {
  Template get template => throw _privateConstructorUsedError;
  bool get isProcessing => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SelectSoundsStateCopyWith<SelectSoundsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectSoundsStateCopyWith<$Res> {
  factory $SelectSoundsStateCopyWith(
          SelectSoundsState value, $Res Function(SelectSoundsState) then) =
      _$SelectSoundsStateCopyWithImpl<$Res>;
  $Res call({Template template, bool isProcessing});

  $TemplateCopyWith<$Res> get template;
}

/// @nodoc
class _$SelectSoundsStateCopyWithImpl<$Res>
    implements $SelectSoundsStateCopyWith<$Res> {
  _$SelectSoundsStateCopyWithImpl(this._value, this._then);

  final SelectSoundsState _value;
  // ignore: unused_field
  final $Res Function(SelectSoundsState) _then;

  @override
  $Res call({
    Object? template = freezed,
    Object? isProcessing = freezed,
  }) {
    return _then(_value.copyWith(
      template: template == freezed
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as Template,
      isProcessing: isProcessing == freezed
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $TemplateCopyWith<$Res> get template {
    return $TemplateCopyWith<$Res>(_value.template, (value) {
      return _then(_value.copyWith(template: value));
    });
  }
}

/// @nodoc
abstract class _$SelectSoundsStateCopyWith<$Res>
    implements $SelectSoundsStateCopyWith<$Res> {
  factory _$SelectSoundsStateCopyWith(
          _SelectSoundsState value, $Res Function(_SelectSoundsState) then) =
      __$SelectSoundsStateCopyWithImpl<$Res>;
  @override
  $Res call({Template template, bool isProcessing});

  @override
  $TemplateCopyWith<$Res> get template;
}

/// @nodoc
class __$SelectSoundsStateCopyWithImpl<$Res>
    extends _$SelectSoundsStateCopyWithImpl<$Res>
    implements _$SelectSoundsStateCopyWith<$Res> {
  __$SelectSoundsStateCopyWithImpl(
      _SelectSoundsState _value, $Res Function(_SelectSoundsState) _then)
      : super(_value, (v) => _then(v as _SelectSoundsState));

  @override
  _SelectSoundsState get _value => super._value as _SelectSoundsState;

  @override
  $Res call({
    Object? template = freezed,
    Object? isProcessing = freezed,
  }) {
    return _then(_SelectSoundsState(
      template: template == freezed
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as Template,
      isProcessing: isProcessing == freezed
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_SelectSoundsState implements _SelectSoundsState {
  _$_SelectSoundsState({required this.template, this.isProcessing = false});

  @override
  final Template template;
  @JsonKey()
  @override
  final bool isProcessing;

  @override
  String toString() {
    return 'SelectSoundsState(template: $template, isProcessing: $isProcessing)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SelectSoundsState &&
            const DeepCollectionEquality().equals(other.template, template) &&
            const DeepCollectionEquality()
                .equals(other.isProcessing, isProcessing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(template),
      const DeepCollectionEquality().hash(isProcessing));

  @JsonKey(ignore: true)
  @override
  _$SelectSoundsStateCopyWith<_SelectSoundsState> get copyWith =>
      __$SelectSoundsStateCopyWithImpl<_SelectSoundsState>(this, _$identity);
}

abstract class _SelectSoundsState implements SelectSoundsState {
  factory _SelectSoundsState({required Template template, bool isProcessing}) =
      _$_SelectSoundsState;

  @override
  Template get template;
  @override
  bool get isProcessing;
  @override
  @JsonKey(ignore: true)
  _$SelectSoundsStateCopyWith<_SelectSoundsState> get copyWith =>
      throw _privateConstructorUsedError;
}
