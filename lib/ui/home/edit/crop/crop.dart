import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chimpanmee/components/toast.dart';
import 'package:chimpanmee/ui/home/navigator.dart';
import 'package:chimpanmee/utlis/file_utils.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CropScreen extends StatelessWidget {
  CropScreen({ 
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  final File imageFile;
  final _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adjust Crop'),
        actions: [
          TextButton(
            onPressed: _cropController.crop, 
            child: const Text('Done')
          ),
        ],
      ),
      body: _Content(
        imageFile: imageFile,
        cropController: _cropController,
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({ 
    Key? key,
    required this.imageFile,
    required this.cropController,
  }) : super(key: key);

  final File imageFile;
  final CropController cropController;

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
    final image = imageFile.readAsBytesSync();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<ui.Image>(
          future: decodeImageFromList(image),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return AspectRatio(
              aspectRatio: snapshot.data!.width / snapshot.data!.height,
              child: Crop(
                controller: cropController,
                image: imageFile.readAsBytesSync(),
                onCropped: (croppedImg) async {
                  await _done(context, ref, croppedImg);
                },
                aspectRatio: 1,
                initialSize: 0.8,
              ),
            );
          }
        ),
      ),
    );
  }
}
