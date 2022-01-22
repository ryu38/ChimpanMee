import 'dart:io';

import 'package:chimpanmee/ui/home/preview/preview_state.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  const _Content({ Key? key }) : super(key: key);

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends ConsumerState<_Content> {

  Widget getSquareImage(String? path) {
    try {
      if (path == null) throw Exception('null input');
      return AspectRatio(
        aspectRatio: 1,
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
        ),
      );
    } on Exception {}
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.grey,
        ),
      ),
    );
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

    return Column(
      children: [
        outputPath != null && isOutputShown 
            ? getSquareImage(outputPath) 
            : getSquareImage(inputPath),
        const Spacer(),
        const Center(
          child: Text('test preview'),
        ),
        const Spacer(),
      ],
    );
  }
}
