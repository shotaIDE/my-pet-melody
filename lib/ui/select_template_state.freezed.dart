// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'select_template_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SelectTemplateStateTearOff {
  const _$SelectTemplateStateTearOff();

  _SelectTemplateState call({List<Template>? templates = null}) {
    return _SelectTemplateState(
      templates: templates,
    );
  }
}

/// @nodoc
const $SelectTemplateState = _$SelectTemplateStateTearOff();

/// @nodoc
mixin _$SelectTemplateState {
  List<Template>? get templates => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SelectTemplateStateCopyWith<SelectTemplateState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectTemplateStateCopyWith<$Res> {
  factory $SelectTemplateStateCopyWith(
          SelectTemplateState value, $Res Function(SelectTemplateState) then) =
      _$SelectTemplateStateCopyWithImpl<$Res>;
  $Res call({List<Template>? templates});
}

/// @nodoc
class _$SelectTemplateStateCopyWithImpl<$Res>
    implements $SelectTemplateStateCopyWith<$Res> {
  _$SelectTemplateStateCopyWithImpl(this._value, this._then);

  final SelectTemplateState _value;
  // ignore: unused_field
  final $Res Function(SelectTemplateState) _then;

  @override
  $Res call({
    Object? templates = freezed,
  }) {
    return _then(_value.copyWith(
      templates: templates == freezed
          ? _value.templates
          : templates // ignore: cast_nullable_to_non_nullable
              as List<Template>?,
    ));
  }
}

/// @nodoc
abstract class _$SelectTemplateStateCopyWith<$Res>
    implements $SelectTemplateStateCopyWith<$Res> {
  factory _$SelectTemplateStateCopyWith(_SelectTemplateState value,
          $Res Function(_SelectTemplateState) then) =
      __$SelectTemplateStateCopyWithImpl<$Res>;
  @override
  $Res call({List<Template>? templates});
}

/// @nodoc
class __$SelectTemplateStateCopyWithImpl<$Res>
    extends _$SelectTemplateStateCopyWithImpl<$Res>
    implements _$SelectTemplateStateCopyWith<$Res> {
  __$SelectTemplateStateCopyWithImpl(
      _SelectTemplateState _value, $Res Function(_SelectTemplateState) _then)
      : super(_value, (v) => _then(v as _SelectTemplateState));

  @override
  _SelectTemplateState get _value => super._value as _SelectTemplateState;

  @override
  $Res call({
    Object? templates = freezed,
  }) {
    return _then(_SelectTemplateState(
      templates: templates == freezed
          ? _value.templates
          : templates // ignore: cast_nullable_to_non_nullable
              as List<Template>?,
    ));
  }
}

/// @nodoc

class _$_SelectTemplateState implements _SelectTemplateState {
  _$_SelectTemplateState({this.templates = null});

  @JsonKey()
  @override
  final List<Template>? templates;

  @override
  String toString() {
    return 'SelectTemplateState(templates: $templates)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SelectTemplateState &&
            const DeepCollectionEquality().equals(other.templates, templates));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(templates));

  @JsonKey(ignore: true)
  @override
  _$SelectTemplateStateCopyWith<_SelectTemplateState> get copyWith =>
      __$SelectTemplateStateCopyWithImpl<_SelectTemplateState>(
          this, _$identity);
}

abstract class _SelectTemplateState implements SelectTemplateState {
  factory _SelectTemplateState({List<Template>? templates}) =
      _$_SelectTemplateState;

  @override
  List<Template>? get templates;
  @override
  @JsonKey(ignore: true)
  _$SelectTemplateStateCopyWith<_SelectTemplateState> get copyWith =>
      throw _privateConstructorUsedError;
}
