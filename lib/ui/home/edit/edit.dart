import 'dart:io';
import 'dart:typed_data';

import 'package:chimpanmee/components/toast.dart';
import 'package:chimpanmee/ui/home/edit/crop/crop.dart';
import 'package:chimpanmee/ui/home/edit/edit_props.dart';
import 'package:chimpanmee/ui/home/preview/preview.dart';
import 'package:chimpanmee/utlis/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chimpanmee/l10n/l10n.dart';

class EditScreen extends ConsumerWidget {
  const EditScreen({
    Key? key,
  }) : super(key: key);

  static const route = 'edit';

  Future<void> _done(
    BuildContext context,
    WidgetRef ref,
    Uint8List image,
  ) async {
    final inputPath = await joinPathToAppDir('input.jpg');
    try {
      File(inputPath).writeAsBytesSync(image);
      await Navigator.of(context)
          .pushNamed(PreviewScreen.route, arguments: inputPath);
    } on Exception {
      await showToast('Failed to save the image');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final props = ModalRoute.of(context)!.settings.arguments! as EditProps;

    final l10n = L10n.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appBarEdit),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context)
                  .pushNamed(CropScreen.route, arguments: props.imageFile);
            },
            icon: const Icon(Icons.crop),
          ),
        ],
      ),
      body: _Content(props: props),
      floatingActionButton: SizedBox.square(
        dimension: 64,
        child: FloatingActionButton(
          onPressed: () async {
            await _done(context, ref, props.imageFile.readAsBytesSync());
          },
          child: const Icon(Icons.face_retouching_natural, size: 32),
        ),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({
    Key? key,
    required this.props,
  }) : super(key: key);

  final EditProps props;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Hero(
        tag: props.uniqueTag,
        child: _SrcPreview(props: props),
      ),
    );
  }
}

class _SrcPreview extends ConsumerWidget {
  const _SrcPreview({Key? key, required this.props}) : super(key: key);

  final EditProps props;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Image.file(
            props.imageFile,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                LayoutBuilder(builder: (context, constraints) {
                  final isVertical =
                      constraints.maxWidth < constraints.maxHeight;
                  return Align(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                          width: isVertical ? double.infinity : null,
                          height: isVertical ? null : double.infinity,
                          color: Colors.red // any colors without transparent,
                          ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
