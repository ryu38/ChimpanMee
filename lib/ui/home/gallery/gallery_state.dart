import 'package:chimpanmee/utlis/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

part 'gallery_state.freezed.dart';

@freezed
abstract class GalleryState with _$GalleryState {
  factory GalleryState({
    required AsyncValue<List<AssetPathEntity>> albumList,
    required int currentAlbumId,
    List<AssetEntity>? imageList,
  }) = _GalleryState;
}

final galleryStateProvider = 
    StateNotifierProvider.autoDispose<GalleryStateNotifier, GalleryState>(
      (ref) => GalleryStateNotifier()
    );

class GalleryStateNotifier extends StateNotifier<GalleryState> {
  GalleryStateNotifier() : super(GalleryState(
    albumList: const AsyncValue.loading(),
    currentAlbumId: 0,
  )) { init(); }

  Future<void> init() async {
    debugLog('Gallery init');
    state.albumList.whenOrNull(loading: () {
      state = state.copyWith(
        albumList: const AsyncValue.loading(),
      );
    });
    final albumList = await AsyncValue.guard(PhotoManager.getAssetPathList);
    await albumList.maybeWhen(
      data: (v) async {
        final imageList = await v.first.getAssetListPaged(0, 30);
        state = state.copyWith(
          albumList: albumList,
          imageList: imageList,
        );
      },
      orElse: () {
        state = state.copyWith(
          albumList: albumList,
        );
      },
    );
  }

  @override
  void dispose() {
    debugLog('Gallery dispose');
    super.dispose();
  }

  Future<void> changeAlbum(int id) async {
    state.albumList.whenData((albumList) async {
      if (id >= albumList.length) return;
      final imageList = await albumList[id].getAssetListPaged(0, 30);
      state = state.copyWith(
        currentAlbumId: id,
        imageList: imageList,
      );
    });
  }
}
