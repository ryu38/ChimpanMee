import 'dart:io';

import 'package:chimpanmee/components/app_error.dart';
import 'package:chimpanmee/components/square_image.dart';
import 'package:chimpanmee/components/toast.dart';
import 'package:chimpanmee/theme/color.dart';
import 'package:chimpanmee/theme/theme.dart';
import 'package:chimpanmee/ui/home/home.dart';
import 'package:chimpanmee/ui/home/preview/preview_state.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:chimpanmee/utlis/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  static const route = '/preview';

  @override
  Widget build(BuildContext context) {
    final inputPath = ModalRoute.of(context)!.settings.arguments! as String;

    return ProviderScope(
      overrides: [
        previewStateProvider
            .overrideWithProvider(previewStateProviderFamily(inputPath)),
      ],
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).popUntil(ModalRoute.withName(HomeScaff.route));
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('show the result'),
          ),
          body: _Content(),
        ),
      ),
    );
  }
}

class _Content extends ConsumerStatefulWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends ConsumerState<_Content> {
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
            ? SquareImage(outputPath)
            : SquareImage(inputPath),
        const Spacer(),
        outputPath != null
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
  const _PreviewMenu({Key? key}) : super(key: key);

  Future<void> _saveImage(Reader read) async {
    try {
      final outputPath = read(previewStateProvider).outputPath!;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newPath = await joinPathToCache('chimpanmee_$timestamp.jpg');
      File(newPath).writeAsBytesSync(File(outputPath).readAsBytesSync());
      final success =
          await GallerySaver.saveImage(newPath, albumName: 'ChimpanMee');
      if (success == true) {
        await showToast('The new chimp is saved successfully');
        return;
      }
      throw AppException('Gallery Saver failed');
    } on Exception catch (e) {
      debugLog(e.toString());
      await showToast('Failed to save in gallery');
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
      child: Column(
        children: [
          const _ImageSwitcher(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _MenuButton(
                  onPressed: () async {
                    await _saveImage(ref.read);
                  },
                  icon: Icons.download,
                  text: 'Download',
                  primary: Theme.of(context).colorScheme.secondaryButtonPrimary,
                  textColor: Theme.of(context).colorScheme.secondaryButtonText,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MenuButton(
                  onPressed: () async {
                    await _shareImage(ref.read);
                  },
                  icon: Icons.share,
                  text: 'Share',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImageSwitcher extends ConsumerWidget {
  const _ImageSwitcher({Key? key}) : super(key: key);

  double get _cornerRadius => 8.0;
  double get _imageSize => 64.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOutputShown =
        ref.watch(previewStateProvider.select((v) => v.isOutputShown));
    late final inputPath = ref.read(previewStateProvider).inputPath;
    late final outputPath = ref.read(previewStateProvider).outputPath!;

    return GestureDetector(
      onTap: () {
        ref.read(previewStateProvider.notifier).switchImage();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_cornerRadius),
          color: Theme.of(context).bottomAppBarTheme.color,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                height: _imageSize,
                width: _imageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_cornerRadius),
                  image: DecorationImage(
                    image: MemoryImage(File(
                      isOutputShown ? inputPath : outputPath,
                    ).readAsBytesSync()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Icon(Icons.rotate_left),
            const SizedBox(width: 8),
            const Text(
              'show original',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.text,
    this.primary,
    this.textColor,
  }) : super(key: key);

  final void Function()? onPressed;
  final IconData icon;
  final String text;

  final Color? primary;
  final Color? textColor;

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
          Icon(icon, color: textColor),
          const SizedBox(width: 8),
          Text(
            text, 
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
