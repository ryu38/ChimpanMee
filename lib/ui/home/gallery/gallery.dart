import 'dart:typed_data';

import 'package:chimpanmee/components/app_error.dart';
import 'package:chimpanmee/components/toast.dart';
import 'package:chimpanmee/ui/home/edit/edit.dart';
import 'package:chimpanmee/ui/home/edit/edit_hero_tag.dart';
import 'package:chimpanmee/ui/home/edit/edit_props.dart';
import 'package:chimpanmee/ui/home/gallery/gallery_state.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  String handleException(Object err) {
    String? msg;
    if (err is Error) throw err;

    if (err is AppException) {
      msg = err.message;
    } else if (err is PlatformException) {
      msg = err.code;
    }
    return msg ?? 'failed to get photo library';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAlbumList =
        ref.watch(galleryStateProvider.select((v) => v.albumList));

    return asyncAlbumList.when(
      data: (albumList) => _Content(albumList: albumList),
      error: (err, stack) {
        return Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(handleException(err)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await ref.read(galleryStateProvider.notifier).retry();
              },
              child: const Text('Reload'),
            ),
          ],
        ));
      },
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
                        onTap: () async {
                          final imageFile = await imageList[index].loadFile();
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
