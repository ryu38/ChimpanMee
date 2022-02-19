import 'dart:io';
import 'dart:math' as math;

import 'package:chimpanmee/components/errors/app_exception.dart';
import 'package:chimpanmee/components/widgets/square_image.dart';
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
import 'package:chimpanmee/l10n/l10n.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  static const route = '/preview';

  @override
  Widget build(BuildContext context) {
    final inputPath = ModalRoute.of(context)!.settings.arguments! as String;

    final l10n = L10n.of(context)!;

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
            title: Text(l10n.appBarPreview),
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

  String waitingMessage(BuildContext context) {
    final message = L10n.of(context)!.previewTransforming;
    final icons = math.Random().nextBool() ? '👨 -> 🐵' : '👩 -> 🐵';
    return '$message ...\n\n$icons';
  }

  @override
  Widget build(BuildContext context) {
    late final isOutputShown =
        ref.watch(previewStateProvider.select((v) => v.isOutputShown));
    late final inputPath =
        ref.watch(previewStateProvider.select((v) => v.inputPath));
    late final outputPath =
        ref.watch(previewStateProvider.select((v) => v.outputPath));

    return LayoutBuilder(builder: (context, constraints) {
      final lowerSpace = constraints.maxHeight - constraints.maxWidth;
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                color: Theme.of(context).colorScheme.cameraMarginColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    outputPath != null && isOutputShown
                        ? SquareImage(outputPath)
                        : SquareImage(inputPath),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: lowerSpace > 240 ? lowerSpace : 240,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  outputPath != null
                      ? _PreviewMenu()
                      : Text(
                          waitingMessage(context),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            // color: Theme.of(context).primaryColor,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _PreviewMenu extends ConsumerStatefulWidget {
  const _PreviewMenu({Key? key}) : super(key: key);

  @override
  __PreviewMenuState createState() => __PreviewMenuState();
}

class __PreviewMenuState extends ConsumerState<_PreviewMenu> {
  bool _isDownloading = false;
  bool _openingShare = false;

  Future<void> _saveImage(Reader read) async {
    setState(() {
      _isDownloading = true;
    });
    var coolTimeEnded = false;
    var downloadEnded = false;
    // ignore: unawaited_futures
    Future<void>.delayed(const Duration(seconds: 1)).then((_) {
      coolTimeEnded = true;
      if (downloadEnded) {
        setState(() {
          _isDownloading = false;
        });
      }
    });
    try {
      final outputPath = read(previewStateProvider).outputPath!;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newPath = await joinPathToCache('chimpanmee_$timestamp.jpg');
      File(newPath).writeAsBytesSync(File(outputPath).readAsBytesSync());
      final success =
          await GallerySaver.saveImage(newPath, albumName: 'ChimpanMee');
      if (success == true) {
        await showToast('The new chimp is saved successfully');
      } else {
        throw AppException('Gallery Saver failed');
      }
    } on Exception catch (e) {
      debugLog(e.toString());
      await showToast('Failed to save in gallery');
    } finally {
      downloadEnded = true;
      if (coolTimeEnded) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Future<void> _shareImage(Reader read) async {
    setState(() {
      _openingShare = true;
    });
    final outputPath = read(previewStateProvider).outputPath!;
    await Share.shareFiles([outputPath]);
    await Future<void>.delayed(const Duration(seconds: 2));
    setState(() {
      _openingShare = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const _ImageSwitcher(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _MenuButton(
                  onPressed: !_isDownloading
                      ? () async {
                          await _saveImage(ref.read);
                        }
                      : null,
                  icon: Icons.download,
                  text: l10n.previewSave,
                  primary: Theme.of(context).colorScheme.secondaryButtonPrimary,
                  textColor: Theme.of(context).colorScheme.secondaryButtonText,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MenuButton(
                  onPressed: !_openingShare
                      ? () async {
                          await _shareImage(ref.read);
                        }
                      : null,
                  icon: Icons.share,
                  text: l10n.previewShare,
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
    final l10n = L10n.of(context)!;

    final isOutputShown =
        ref.watch(previewStateProvider.select((v) => v.isOutputShown));
    late final inputPath = ref.read(previewStateProvider).inputPath;
    late final outputPath = ref.read(previewStateProvider).outputPath!;

    return InkWell(
      onTap: () {
        ref.read(previewStateProvider.notifier).switchImage();
      },
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarTheme.color,
          borderRadius: BorderRadius.circular(_cornerRadius),
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.compare_arrows),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      l10n.previewSwitchImage,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        primary: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
