// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'camera_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$CameraStateTearOff {
  const _$CameraStateTearOff();

  _CounterState call(
      {required int cameraId,
      required AsyncValue<CameraController> controller,
      required bool isCameraActive}) {
    return _CounterState(
      cameraId: cameraId,
      controller: controller,
      isCameraActive: isCameraActive,
    );
  }
}

/// @nodoc
const $CameraState = _$CameraStateTearOff();

/// @nodoc
mixin _$CameraState {
  int get cameraId => throw _privateConstructorUsedError;
  AsyncValue<CameraController> get controller =>
      throw _privateConstructorUsedError;
  bool get isCameraActive => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CameraStateCopyWith<CameraState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraStateCopyWith<$Res> {
  factory $CameraStateCopyWith(
          CameraState value, $Res Function(CameraState) then) =
      _$CameraStateCopyWithImpl<$Res>;
  $Res call(
      {int cameraId,
      AsyncValue<CameraController> controller,
      bool isCameraActive});
}

/// @nodoc
class _$CameraStateCopyWithImpl<$Res> implements $CameraStateCopyWith<$Res> {
  _$CameraStateCopyWithImpl(this._value, this._then);

  final CameraState _value;
  // ignore: unused_field
  final $Res Function(CameraState) _then;

  @override
  $Res call({
    Object? cameraId = freezed,
    Object? controller = freezed,
    Object? isCameraActive = freezed,
  }) {
    return _then(_value.copyWith(
      cameraId: cameraId == freezed
          ? _value.cameraId
          : cameraId // ignore: cast_nullable_to_non_nullable
              as int,
      controller: controller == freezed
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as AsyncValue<CameraController>,
      isCameraActive: isCameraActive == freezed
          ? _value.isCameraActive
          : isCameraActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$CounterStateCopyWith<$Res>
    implements $CameraStateCopyWith<$Res> {
  factory _$CounterStateCopyWith(
          _CounterState value, $Res Function(_CounterState) then) =
      __$CounterStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {int cameraId,
      AsyncValue<CameraController> controller,
      bool isCameraActive});
}

/// @nodoc
class __$CounterStateCopyWithImpl<$Res> extends _$CameraStateCopyWithImpl<$Res>
    implements _$CounterStateCopyWith<$Res> {
  __$CounterStateCopyWithImpl(
      _CounterState _value, $Res Function(_CounterState) _then)
      : super(_value, (v) => _then(v as _CounterState));

  @override
  _CounterState get _value => super._value as _CounterState;

  @override
  $Res call({
    Object? cameraId = freezed,
    Object? controller = freezed,
    Object? isCameraActive = freezed,
  }) {
    return _then(_CounterState(
      cameraId: cameraId == freezed
          ? _value.cameraId
          : cameraId // ignore: cast_nullable_to_non_nullable
              as int,
      controller: controller == freezed
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as AsyncValue<CameraController>,
      isCameraActive: isCameraActive == freezed
          ? _value.isCameraActive
          : isCameraActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_CounterState with DiagnosticableTreeMixin implements _CounterState {
  _$_CounterState(
      {required this.cameraId,
      required this.controller,
      required this.isCameraActive});

  @override
  final int cameraId;
  @override
  final AsyncValue<CameraController> controller;
  @override
  final bool isCameraActive;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CameraState(cameraId: $cameraId, controller: $controller, isCameraActive: $isCameraActive)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CameraState'))
      ..add(DiagnosticsProperty('cameraId', cameraId))
      ..add(DiagnosticsProperty('controller', controller))
      ..add(DiagnosticsProperty('isCameraActive', isCameraActive));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CounterState &&
            const DeepCollectionEquality().equals(other.cameraId, cameraId) &&
            const DeepCollectionEquality()
                .equals(other.controller, controller) &&
            const DeepCollectionEquality()
                .equals(other.isCameraActive, isCameraActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(cameraId),
      const DeepCollectionEquality().hash(controller),
      const DeepCollectionEquality().hash(isCameraActive));

  @JsonKey(ignore: true)
  @override
  _$CounterStateCopyWith<_CounterState> get copyWith =>
      __$CounterStateCopyWithImpl<_CounterState>(this, _$identity);
}

abstract class _CounterState implements CameraState {
  factory _CounterState(
      {required int cameraId,
      required AsyncValue<CameraController> controller,
      required bool isCameraActive}) = _$_CounterState;

  @override
  int get cameraId;
  @override
  AsyncValue<CameraController> get controller;
  @override
  bool get isCameraActive;
  @override
  @JsonKey(ignore: true)
  _$CounterStateCopyWith<_CounterState> get copyWith =>
      throw _privateConstructorUsedError;
}
