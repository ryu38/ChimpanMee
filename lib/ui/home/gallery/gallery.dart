import 'dart:typed_data';

import 'package:chimpanmee/components/errors/app_exception.dart';
import 'package:chimpanmee/components/errors/permission_denied.dart';
import 'package:chimpanmee/components/toast.dart';
import 'package:chimpanmee/components/widgets/error_display.dart';
import 'package:chimpanmee/platform_permission.dart';
import 'package:chimpanmee/ui/home/edit/edit.dart';
import 'package:chimpanmee/ui/home/edit/edit_hero_tag.dart';
import 'package:chimpanmee/ui/home/edit/edit_props.dart';
import 'package:chimpanmee/ui/home/gallery/gallery_error.dart';
import 'package:chimpanmee/ui/home/gallery/gallery_state.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:chimpanmee/l10n/l10n.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen>
    with WidgetsBindingObserver {
  GalleryStateNotifier get notifier => ref.read(galleryStateProvider.notifier);

  bool _openingSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _openingSettings) {
      debugLog('resumed');
      ref.read(galleryStateProvider).albumList.whenOrNull(
        error: (error, _) {
          if (error is PermissionDeniedException) {
            notifier.init();
            _openingSettings = false;
          }
        },
      );
    }
  }

  Future<void> retry() async {
    final status = await AppPermission().gallery.status;
    debugLog(status.toString());
    if (status.isPermanentlyDenied || status.isDenied) {
      await Future<void>.delayed(const Duration(microseconds: 1));
      _openingSettings = true;
      await openAppSettings();
    } else {
      await notifier.init();
    }
  }

  ErrorDisplay handleException(BuildContext context, Object err) {
    String? msg;
    if (err is Error) throw err;

    final l10n = L10n.of(context)!;

    if (err is PermissionDeniedException) {
      return ErrorDisplay(
        headline: l10n.permissionErrorHead,
        description: l10n.permissionGalleryErrorDescription,
        solveButtonText: l10n.permissionErrorSolve,
        solveFunc: retry,
      );
    } else if (err is GalleryEmptyException) {
      return ErrorDisplay(
        headline: l10n.noAlbumErrorHead,
        description: l10n.noAlbumErrorDescription,
        solveButtonText: l10n.noAlbumErrorSolve,
        solveFunc: notifier.init,
      );
    }
    return ErrorDisplay(
      solveButtonText: 'Reload',
      solveFunc: notifier.init,
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncAlbumList =
        ref.watch(galleryStateProvider.select((v) => v.albumList));

    return asyncAlbumList.when(
      data: (albumList) => _Content(albumList: albumList),
      error: (err, stack) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          handleException(context,err),
          const SizedBox(height: kBottomNavigationBarHeight),
        ],
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _Content extends ConsumerStatefulWidget {
  const _Content({
    Key? key,
    required this.albumList,
  }) : super(key: key);

  final List<AssetPathEntity> albumList;

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends ConsumerState<_Content> {
  bool _isLoadingMore = false;
  Map<String, Uint8List> thumbCache = {};

  Future<void> _loadByScroll(Reader read) async {
    debugLog('load start !');
    _isLoadingMore = true;
    await read(galleryStateProvider.notifier).loadMore();
    debugLog('load ended !');
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _isLoadingMore = false;
  }

  Future<Uint8List?> _getThumb(List<AssetEntity> imageList, int index) async {
    if (thumbCache.length > 90) {
      thumbCache.remove(thumbCache.keys.first);
    }
    final imageId = imageList[index].id;
    if (thumbCache[imageId] == null) {
      final thumb = await imageList[index].thumbDataWithSize(120, 120);
      if (thumb != null) {
        thumbCache[imageId] = thumb;
      }
      return thumb;
    }
    return thumbCache[imageId];
  }

  Future<void> _openSelected(AssetEntity assetEntity, String uniqueTag) async {
    final imageFile = await assetEntity.loadFile();
    if (imageFile != null) {
      await precacheImage(FileImage(imageFile), context);
      await Navigator.of(context).pushNamed(
        EditScreen.route,
        arguments: EditProps(
          imageFile: imageFile,
          uniqueTag: uniqueTag,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageList =
        ref.watch(galleryStateProvider.select((v) => v.imageList)) ?? [];

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final scrollDegree =
            notification.metrics.pixels / notification.metrics.maxScrollExtent;
        if (scrollDegree >= 0.97 && !_isLoadingMore) {
          _loadByScroll(ref.read);
        }
        return false;
      },
      child: GridView.builder(
        itemCount: imageList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          return FutureBuilder<Uint8List?>(
              future: _getThumb(imageList, index),
              builder: (context, snapshot) {
                final uniqueTag = generateEditHeroTag('gallery-$index');
                return snapshot.hasData
                    ? GestureDetector(
                        onTap: () {
                          _openSelected(imageList[index], uniqueTag);
                        },
                        child: Hero(
                          tag: uniqueTag,
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container();
              });
        },
      ),
    );
  }
}
