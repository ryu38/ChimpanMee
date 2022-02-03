// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'web_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$WebStateTearOff {
  const _$WebStateTearOff();

  _WebState call({File? imageFile, String? errorMsg, required bool isLoading}) {
    return _WebState(
      imageFile: imageFile,
      errorMsg: errorMsg,
      isLoading: isLoading,
    );
  }
}

/// @nodoc
const $WebState = _$WebStateTearOff();

/// @nodoc
mixin _$WebState {
  File? get imageFile => throw _privateConstructorUsedError;
  String? get errorMsg => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WebStateCopyWith<WebState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebStateCopyWith<$Res> {
  factory $WebStateCopyWith(WebState value, $Res Function(WebState) then) =
      _$WebStateCopyWithImpl<$Res>;
  $Res call({File? imageFile, String? errorMsg, bool isLoading});
}

/// @nodoc
class _$WebStateCopyWithImpl<$Res> implements $WebStateCopyWith<$Res> {
  _$WebStateCopyWithImpl(this._value, this._then);

  final WebState _value;
  // ignore: unused_field
  final $Res Function(WebState) _then;

  @override
  $Res call({
    Object? imageFile = freezed,
    Object? errorMsg = freezed,
    Object? isLoading = freezed,
  }) {
    return _then(_value.copyWith(
      imageFile: imageFile == freezed
          ? _value.imageFile
          : imageFile // ignore: cast_nullable_to_non_nullable
              as File?,
      errorMsg: errorMsg == freezed
          ? _value.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$WebStateCopyWith<$Res> implements $WebStateCopyWith<$Res> {
  factory _$WebStateCopyWith(_WebState value, $Res Function(_WebState) then) =
      __$WebStateCopyWithImpl<$Res>;
  @override
  $Res call({File? imageFile, String? errorMsg, bool isLoading});
}

/// @nodoc
class __$WebStateCopyWithImpl<$Res> extends _$WebStateCopyWithImpl<$Res>
    implements _$WebStateCopyWith<$Res> {
  __$WebStateCopyWithImpl(_WebState _value, $Res Function(_WebState) _then)
      : super(_value, (v) => _then(v as _WebState));

  @override
  _WebState get _value => super._value as _WebState;

  @override
  $Res call({
    Object? imageFile = freezed,
    Object? errorMsg = freezed,
    Object? isLoading = freezed,
  }) {
    return _then(_WebState(
      imageFile: imageFile == freezed
          ? _value.imageFile
          : imageFile // ignore: cast_nullable_to_non_nullable
              as File?,
      errorMsg: errorMsg == freezed
          ? _value.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_WebState with DiagnosticableTreeMixin implements _WebState {
  _$_WebState({this.imageFile, this.errorMsg, required this.isLoading});

  @override
  final File? imageFile;
  @override
  final String? errorMsg;
  @override
  final bool isLoading;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WebState(imageFile: $imageFile, errorMsg: $errorMsg, isLoading: $isLoading)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WebState'))
      ..add(DiagnosticsProperty('imageFile', imageFile))
      ..add(DiagnosticsProperty('errorMsg', errorMsg))
      ..add(DiagnosticsProperty('isLoading', isLoading));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WebState &&
            const DeepCollectionEquality().equals(other.imageFile, imageFile) &&
            const DeepCollectionEquality().equals(other.errorMsg, errorMsg) &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(imageFile),
      const DeepCollectionEquality().hash(errorMsg),
      const DeepCollectionEquality().hash(isLoading));

  @JsonKey(ignore: true)
  @override
  _$WebStateCopyWith<_WebState> get copyWith =>
      __$WebStateCopyWithImpl<_WebState>(this, _$identity);
}

abstract class _WebState implements WebState {
  factory _WebState(
      {File? imageFile,
      String? errorMsg,
      required bool isLoading}) = _$_WebState;

  @override
  File? get imageFile;
  @override
  String? get errorMsg;
  @override
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$WebStateCopyWith<_WebState> get copyWith =>
      throw _privateConstructorUsedError;
}
