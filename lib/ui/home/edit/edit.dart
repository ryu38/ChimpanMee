import 'dart:io';
import 'dart:typed_data';

import 'package:chimpanmee/components/toast.dart';
import 'package:chimpanmee/ui/home/edit/edit_navigator.dart';
import 'package:chimpanmee/ui/home/edit/edit_props.dart';
import 'package:chimpanmee/ui/home/navigator.dart';
import 'package:chimpanmee/utlis/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditScreen extends ConsumerWidget {
  const EditScreen({ 
    Key? key,
    required this.props,
  }) : super(key: key);

  final EditProps props;

  Future<void> _done(
    BuildContext context, WidgetRef ref, Uint8List image,
  ) async {
    final inputPath = await joinPathToCache('input.jpg');
    try {
      File(inputPath).writeAsBytesSync(image);
      await navigatePreview(context, ref, inputPath: inputPath);
    } on Exception {
      await showToast('Failed to save the image');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.help_outline),
          ),
          IconButton(
            onPressed: () async {
              await navigateCrop(context, imageFile: props.imageFile);
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
          child: const Icon(Icons.photo_filter),
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
  const _SrcPreview({ 
    Key? key,
    required this.props
  }) : super(key: key);

  final EditProps props;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Image.file(
          props.imageFile,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
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
                  }
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
