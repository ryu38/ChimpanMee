import 'dart:io';

import 'package:chimpanmee/color.dart';
import 'package:chimpanmee/components/toast.dart';
import 'package:chimpanmee/ui/home/preview/preview_state.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:chimpanmee/components/square_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('show the result'),
      ),
      body: _Content(),
    );
  }
}

class _Content extends ConsumerStatefulWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends ConsumerState<_Content> {
  Widget getSquareImage(String? path) {
    try {
      if (path == null) throw Exception('null input');
      return AspectRatio(
        aspectRatio: 1,
        child: Image.memory(
          File(path).readAsBytesSync(),
          fit: BoxFit.cover,
        ),
      );
    } on Exception {}
    return const SquareBox();
  }

  Future<void> transformImage() async {
    try {
      await ref.read(previewStateProvider.notifier).getTransformed();
    } on Exception {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    transformImage();
  }

  @override
  Widget build(BuildContext context) {
    late final isOutputShown =
        ref.watch(previewStateProvider.select((v) => v.isOutputShown));
    late final inputPath =
        ref.watch(previewStateProvider.select((v) => v.inputPath));
    late final outputPath =
        ref.watch(previewStateProvider.select((v) => v.outputPath));

    final isComplete = 
        outputPath != null && isOutputShown;

    return Column(
      children: [
        isComplete
            ? getSquareImage(outputPath)
            : getSquareImage(inputPath),
        // !isComplete ? const LinearProgressIndicator() : const SizedBox(height: 1),
        const Spacer(),
        isComplete
            ? _PreviewMenu()
            : Text(
              'transforming now ...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
        const Spacer(),
      ],
    );
  }
}

class _PreviewMenu extends ConsumerWidget {
  const _PreviewMenu({ Key? key }) : super(key: key);

  Future<void> _saveImage(Reader read) async {
    final outputPath = read(previewStateProvider).outputPath!;
    final success = await GallerySaver.saveImage(outputPath);
    if (success == true) {
      await showToast('The new chimp is saved successfully');
    }
  }

  Future<void> _shareImage(Reader read) async {
    final outputPath = read(previewStateProvider).outputPath!;
    await Share.shareFiles([outputPath]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(child: _MenuButton(
            onPressed: () async {
              await _saveImage(ref.read);
            },
            icon: const Icon(Icons.download),
            child: const Text('Download'),
            primary: Color(0xffFFc800),
          )),
          const SizedBox(width: 16),
          Expanded(child: _MenuButton(
            onPressed: () async {
              await _shareImage(ref.read);
            },
            icon: const Icon(Icons.share),
            child: const Text('Share'),
          )),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({ 
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.child,
    this.primary,

  }) : super(key: key);

  final void Function()? onPressed;
  final Icon icon;
  final Widget child;

  final Color? primary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon, const SizedBox(width: 8), child,
        ],
      ),
    );
  }
}
