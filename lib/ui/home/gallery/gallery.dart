import 'dart:typed_data';

import 'package:chimpanmee/ui/home/edit/edit_hero_tag.dart';
import 'package:chimpanmee/ui/home/gallery/gallery_state.dart';
import 'package:chimpanmee/ui/home/navigator.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({ Key? key }) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {

  @override
  Widget build(BuildContext context) {
    final asyncAlbumList = 
        ref.watch(galleryStateProvider.select((v) => v.albumList));

    return asyncAlbumList.when(
      error: (err, stack) {
        String? errMsg;
        if (err is PlatformException) {
          errMsg = err.code;
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(errMsg ?? 'failed to get photo library'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final status = await Permission.storage.request();
                  print(status);
                  if (status.isPermanentlyDenied) {
                    print(status);
                    await openAppSettings();
                  } else if (status.isGranted) {
                    await ref.read(galleryStateProvider.notifier).init();
                  }
                }, 
                child: const Text('Reload'),
              ),
            ],
          )
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (albumList) => _Content(albumList: albumList),
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
          crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4,
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
                          await navigateEdit(
                            context, imageFile: imageFile, uniqueTag: uniqueTag,
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
            }
          );
        },
      ),
    );
  }
}
