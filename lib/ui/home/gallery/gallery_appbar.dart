import 'package:chimpanmee/ui/home/gallery/gallery_state.dart';
import 'package:chimpanmee/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chimpanmee/l10n/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';

AppBar _galleryAppBarGenerator(BuildContext context, WidgetRef ref) {
  final l10n = L10n.of(context)!;
  final defaultActions = <Widget>[
    IconButton(
      onPressed: () async {
        final info = await PackageInfo.fromPlatform();
        showLicensePage(
          context: context,
          applicationName: info.appName,
          applicationVersion: info.version,
        );
      },
      icon: const Icon(Icons.info_outline),
    ),
  ];
  final albumId =
      ref.watch(galleryStateProvider.select((v) => v.currentAlbumId));
  final galleryActions =
      ref.watch(galleryStateProvider.select((v) => v.albumList)).whenOrNull(
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
                },
              ),
            ],
          );
  final actions = defaultActions..insertAll(0, galleryActions ?? []);
  return AppBar(
    title: Text(l10n.appBarGallery),
    actions: actions,
  );
}

AppBarGenerator galleryAppBarGenerator = _galleryAppBarGenerator;
