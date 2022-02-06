import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chimpanmee/components/toast.dart';
import 'package:chimpanmee/ui/home/edit/edit.dart';
import 'package:chimpanmee/ui/home/preview/preview.dart';
import 'package:chimpanmee/utlis/file_utils.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CropScreen extends StatefulWidget {
  CropScreen({Key? key}) : super(key: key);

  static const route = '${EditScreen.route}/crop';

  final _cropController = CropController();

  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  bool _isReadyToCrop = false;
  void _notifyReady() {
    if (!_isReadyToCrop) {
      _isReadyToCrop = true;
    }
  }

  void _crop() {
    if (_isReadyToCrop) {
      widget._cropController.crop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageFile = ModalRoute.of(context)!.settings.arguments! as File;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adjust Crop'),
        actions: [
          TextButton(
            onPressed: _crop,
            child: const Text('Done'),
          ),
        ],
      ),
      body: _Content(
        imageFile: imageFile,
        cropController: widget._cropController,
        readyNotifier: _notifyReady,
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({
    Key? key,
    required this.imageFile,
    required this.cropController,
    required this.readyNotifier,
  }) : super(key: key);

  final File imageFile;
  final CropController cropController;
  final void Function() readyNotifier;

  Future<void> _done(
    BuildContext context,
    WidgetRef ref,
    Uint8List image,
  ) async {
    final inputPath = await joinPathToCache('input.jpg');
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
              readyNotifier();
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
            }),
      ),
    );
  }
}
