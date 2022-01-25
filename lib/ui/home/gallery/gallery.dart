import 'dart:typed_data';

import 'package:chimpanmee/ui/home/gallery/gallery_state.dart';
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
                  if (status.isPermanentlyDenied) {
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

class _Content extends ConsumerWidget {
  const _Content({ 
    Key? key,
    required this.albumList,
  }) : super(key: key);

  final List<AssetPathEntity> albumList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageList = 
        ref.watch(galleryStateProvider.select((v) => v.imageList)) ?? [];

    return GridView.builder(
      itemCount: imageList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4,
      ), 
      itemBuilder: (context, index) {
        return FutureBuilder<Uint8List?>(
          future: imageList[index].thumbDataWithSize(120, 120),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  )
                : Container();
          }
        );
      },
    );
  }
}
