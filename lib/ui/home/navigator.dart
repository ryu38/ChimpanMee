import 'package:chimpanmee/ui/home/preview/preview.dart';
import 'package:chimpanmee/ui/home/preview/preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> navigatePreview(
  BuildContext context, WidgetRef ref, {
    required String inputPath,
  }) async {
    ref.read(previewStateProvider.notifier)
        .setInputPath(inputPath);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PreviewScreen(),
      )
    );
    ref.read(previewStateProvider.notifier).reset();
  }