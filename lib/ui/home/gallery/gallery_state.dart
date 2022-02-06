import 'package:chimpanmee/components/app_error.dart';
import 'package:chimpanmee/platform_permission.dart';
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
        (ref) => GalleryStateNotifier());

class GalleryStateNotifier extends StateNotifier<GalleryState> {
  GalleryStateNotifier()
      : super(GalleryState(
          albumList: const AsyncValue.loading(),
          currentAlbumId: 0,
        )) {
    init();
  }

  Future<void> init() async {
    debugLog('Gallery init');
    state.albumList.whenOrNull(loading: () {
      state = state.copyWith(
        albumList: const AsyncValue.loading(),
      );
    });
    final albumList = await AsyncValue.guard(
        () => PhotoManager.getAssetPathList(type: RequestType.image));
    await albumList.maybeWhen(
      data: (v) async {
        if (v.isNotEmpty) {
          final imageList = await v.first.getAssetListPaged(0, 30);
          state = state.copyWith(
            albumList: albumList,
            imageList: imageList,
          );
        } else {
          state = state.copyWith(
            albumList: AsyncValue.error(AppException('No Albums')),
          );
        }
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

  Future<void> loadMore() async {
    await state.albumList.whenOrNull(data: (albumList) async {
      final imageList = state.imageList ?? [];
      final loadedCount = (imageList.length / 30).ceil();
      final newImageList = await albumList[state.currentAlbumId]
          .getAssetListPaged(loadedCount, 30);
      if (newImageList.isNotEmpty) {
        state = state.copyWith(
          // adding list does not works
          imageList: [...imageList, ...newImageList],
        );
      }
    });
  }

  Future<void> retry() async {
    // final status = await Permission.storage.request();
    final status = await AppPermission().gallery.request();
    debugLog(status.toString());
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else if (status.isGranted) {
      await init();
    }
  }
}
