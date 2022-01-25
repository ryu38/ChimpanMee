import 'package:chimpanmee/ui/home/gallery/gallery_state.dart';
import 'package:chimpanmee/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

AppBar _galleryAppBarGenerator(WidgetRef ref) {
  final albumId = 
      ref.watch(galleryStateProvider.select((v) => v.currentAlbumId));
  final actions = ref.watch(galleryStateProvider.select((v) => v.albumList)).whenOrNull(
    data: (albumList) => [
      PopupMenuButton<int>(
        onSelected: (id) {
          ref.read(galleryStateProvider.notifier).changeAlbum(id);
        },
        child: Row(
          children: [
            Text(albumList[albumId].name),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
        itemBuilder: (context) {
          final menu = <PopupMenuEntry<int>>[];
          albumList.asMap().forEach((id, v) {
            final name = v.name;
            menu.add(PopupMenuItem(
              value: id,
              child: Text(name),
            ));
          });
          return menu;
        }
      ),
    ]
  );
  return AppBar(
    title: const Text('Select Photos'),
    actions: actions,
  );
}

AppBarGenerator galleryAppBarGenerator = _galleryAppBarGenerator;
