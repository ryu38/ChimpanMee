import 'package:chimpanmee/ui/preview/preview.dart';
import 'package:chimpanmee/ui/preview/preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void navigatePreview(
  BuildContext context, WidgetRef ref, {
    required String inputPath,
  }) {
    ref.read(previewStateProvider.notifier)
        .setInputPath(inputPath);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PreviewScreen(),
      )
    );
  }
