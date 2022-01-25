// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'gallery_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$GalleryStateTearOff {
  const _$GalleryStateTearOff();

  _GalleryState call(
      {required AsyncValue<List<AssetPathEntity>> albumList,
      required int currentAlbumId,
      List<AssetEntity>? imageList}) {
    return _GalleryState(
      albumList: albumList,
      currentAlbumId: currentAlbumId,
      imageList: imageList,
    );
  }
}

/// @nodoc
const $GalleryState = _$GalleryStateTearOff();

/// @nodoc
mixin _$GalleryState {
  AsyncValue<List<AssetPathEntity>> get albumList =>
      throw _privateConstructorUsedError;
  int get currentAlbumId => throw _privateConstructorUsedError;
  List<AssetEntity>? get imageList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GalleryStateCopyWith<GalleryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GalleryStateCopyWith<$Res> {
  factory $GalleryStateCopyWith(
          GalleryState value, $Res Function(GalleryState) then) =
      _$GalleryStateCopyWithImpl<$Res>;
  $Res call(
      {AsyncValue<List<AssetPathEntity>> albumList,
      int currentAlbumId,
      List<AssetEntity>? imageList});
}

/// @nodoc
class _$GalleryStateCopyWithImpl<$Res> implements $GalleryStateCopyWith<$Res> {
  _$GalleryStateCopyWithImpl(this._value, this._then);

  final GalleryState _value;
  // ignore: unused_field
  final $Res Function(GalleryState) _then;

  @override
  $Res call({
    Object? albumList = freezed,
    Object? currentAlbumId = freezed,
    Object? imageList = freezed,
  }) {
    return _then(_value.copyWith(
      albumList: albumList == freezed
          ? _value.albumList
          : albumList // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<AssetPathEntity>>,
      currentAlbumId: currentAlbumId == freezed
          ? _value.currentAlbumId
          : currentAlbumId // ignore: cast_nullable_to_non_nullable
              as int,
      imageList: imageList == freezed
          ? _value.imageList
          : imageList // ignore: cast_nullable_to_non_nullable
              as List<AssetEntity>?,
    ));
  }
}

/// @nodoc
abstract class _$GalleryStateCopyWith<$Res>
    implements $GalleryStateCopyWith<$Res> {
  factory _$GalleryStateCopyWith(
          _GalleryState value, $Res Function(_GalleryState) then) =
      __$GalleryStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {AsyncValue<List<AssetPathEntity>> albumList,
      int currentAlbumId,
      List<AssetEntity>? imageList});
}

/// @nodoc
class __$GalleryStateCopyWithImpl<$Res> extends _$GalleryStateCopyWithImpl<$Res>
    implements _$GalleryStateCopyWith<$Res> {
  __$GalleryStateCopyWithImpl(
      _GalleryState _value, $Res Function(_GalleryState) _then)
      : super(_value, (v) => _then(v as _GalleryState));

  @override
  _GalleryState get _value => super._value as _GalleryState;

  @override
  $Res call({
    Object? albumList = freezed,
    Object? currentAlbumId = freezed,
    Object? imageList = freezed,
  }) {
    return _then(_GalleryState(
      albumList: albumList == freezed
          ? _value.albumList
          : albumList // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<AssetPathEntity>>,
      currentAlbumId: currentAlbumId == freezed
          ? _value.currentAlbumId
          : currentAlbumId // ignore: cast_nullable_to_non_nullable
              as int,
      imageList: imageList == freezed
          ? _value.imageList
          : imageList // ignore: cast_nullable_to_non_nullable
              as List<AssetEntity>?,
    ));
  }
}

/// @nodoc

class _$_GalleryState with DiagnosticableTreeMixin implements _GalleryState {
  _$_GalleryState(
      {required this.albumList, required this.currentAlbumId, this.imageList});

  @override
  final AsyncValue<List<AssetPathEntity>> albumList;
  @override
  final int currentAlbumId;
  @override
  final List<AssetEntity>? imageList;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GalleryState(albumList: $albumList, currentAlbumId: $currentAlbumId, imageList: $imageList)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GalleryState'))
      ..add(DiagnosticsProperty('albumList', albumList))
      ..add(DiagnosticsProperty('currentAlbumId', currentAlbumId))
      ..add(DiagnosticsProperty('imageList', imageList));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GalleryState &&
            const DeepCollectionEquality().equals(other.albumList, albumList) &&
            const DeepCollectionEquality()
                .equals(other.currentAlbumId, currentAlbumId) &&
            const DeepCollectionEquality().equals(other.imageList, imageList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(albumList),
      const DeepCollectionEquality().hash(currentAlbumId),
      const DeepCollectionEquality().hash(imageList));

  @JsonKey(ignore: true)
  @override
  _$GalleryStateCopyWith<_GalleryState> get copyWith =>
      __$GalleryStateCopyWithImpl<_GalleryState>(this, _$identity);
}

abstract class _GalleryState implements GalleryState {
  factory _GalleryState(
      {required AsyncValue<List<AssetPathEntity>> albumList,
      required int currentAlbumId,
      List<AssetEntity>? imageList}) = _$_GalleryState;

  @override
  AsyncValue<List<AssetPathEntity>> get albumList;
  @override
  int get currentAlbumId;
  @override
  List<AssetEntity>? get imageList;
  @override
  @JsonKey(ignore: true)
  _$GalleryStateCopyWith<_GalleryState> get copyWith =>
      throw _privateConstructorUsedError;
}
