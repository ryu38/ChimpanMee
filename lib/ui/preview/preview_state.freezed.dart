// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'preview_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PreviewStateTearOff {
  const _$PreviewStateTearOff();

  _PreviewState call({String? inputPath, String? outputPath}) {
    return _PreviewState(
      inputPath: inputPath,
      outputPath: outputPath,
    );
  }
}

/// @nodoc
const $PreviewState = _$PreviewStateTearOff();

/// @nodoc
mixin _$PreviewState {
  String? get inputPath => throw _privateConstructorUsedError;
  String? get outputPath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PreviewStateCopyWith<PreviewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreviewStateCopyWith<$Res> {
  factory $PreviewStateCopyWith(
          PreviewState value, $Res Function(PreviewState) then) =
      _$PreviewStateCopyWithImpl<$Res>;
  $Res call({String? inputPath, String? outputPath});
}

/// @nodoc
class _$PreviewStateCopyWithImpl<$Res> implements $PreviewStateCopyWith<$Res> {
  _$PreviewStateCopyWithImpl(this._value, this._then);

  final PreviewState _value;
  // ignore: unused_field
  final $Res Function(PreviewState) _then;

  @override
  $Res call({
    Object? inputPath = freezed,
    Object? outputPath = freezed,
  }) {
    return _then(_value.copyWith(
      inputPath: inputPath == freezed
          ? _value.inputPath
          : inputPath // ignore: cast_nullable_to_non_nullable
              as String?,
      outputPath: outputPath == freezed
          ? _value.outputPath
          : outputPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$PreviewStateCopyWith<$Res>
    implements $PreviewStateCopyWith<$Res> {
  factory _$PreviewStateCopyWith(
          _PreviewState value, $Res Function(_PreviewState) then) =
      __$PreviewStateCopyWithImpl<$Res>;
  @override
  $Res call({String? inputPath, String? outputPath});
}

/// @nodoc
class __$PreviewStateCopyWithImpl<$Res> extends _$PreviewStateCopyWithImpl<$Res>
    implements _$PreviewStateCopyWith<$Res> {
  __$PreviewStateCopyWithImpl(
      _PreviewState _value, $Res Function(_PreviewState) _then)
      : super(_value, (v) => _then(v as _PreviewState));

  @override
  _PreviewState get _value => super._value as _PreviewState;

  @override
  $Res call({
    Object? inputPath = freezed,
    Object? outputPath = freezed,
  }) {
    return _then(_PreviewState(
      inputPath: inputPath == freezed
          ? _value.inputPath
          : inputPath // ignore: cast_nullable_to_non_nullable
              as String?,
      outputPath: outputPath == freezed
          ? _value.outputPath
          : outputPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_PreviewState with DiagnosticableTreeMixin implements _PreviewState {
  _$_PreviewState({this.inputPath, this.outputPath});

  @override
  final String? inputPath;
  @override
  final String? outputPath;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PreviewState(inputPath: $inputPath, outputPath: $outputPath)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PreviewState'))
      ..add(DiagnosticsProperty('inputPath', inputPath))
      ..add(DiagnosticsProperty('outputPath', outputPath));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PreviewState &&
            const DeepCollectionEquality().equals(other.inputPath, inputPath) &&
            const DeepCollectionEquality()
                .equals(other.outputPath, outputPath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(inputPath),
      const DeepCollectionEquality().hash(outputPath));

  @JsonKey(ignore: true)
  @override
  _$PreviewStateCopyWith<_PreviewState> get copyWith =>
      __$PreviewStateCopyWithImpl<_PreviewState>(this, _$identity);
}

abstract class _PreviewState implements PreviewState {
  factory _PreviewState({String? inputPath, String? outputPath}) =
      _$_PreviewState;

  @override
  String? get inputPath;
  @override
  String? get outputPath;
  @override
  @JsonKey(ignore: true)
  _$PreviewStateCopyWith<_PreviewState> get copyWith =>
      throw _privateConstructorUsedError;
}
