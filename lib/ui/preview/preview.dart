import 'dart:io';

import 'package:chimpanmee/ui/preview/preview_state.dart';
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

class _Content extends ConsumerWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputPath = ref.read(previewStateProvider).inputPath!;
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            File(inputPath), 
            fit: BoxFit.cover,
          ),
        ),
        const Spacer(),
        const Center(
          child: Text('test preview'),
        ),
        const Spacer(),
      ],
    );
  }
}
