import 'package:chimpanmee/theme/color.dart';
import 'package:chimpanmee/components/widgets/square_box.dart';
import 'package:chimpanmee/ui/home/edit/edit.dart';
import 'package:chimpanmee/ui/home/edit/edit_hero_tag.dart';
import 'package:chimpanmee/ui/home/edit/edit_props.dart';
import 'package:chimpanmee/ui/home/web/web_state.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:chimpanmee/utlis/http_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chimpanmee/theme/theme.dart';
import 'package:chimpanmee/l10n/l10n.dart';

class WebScreen extends ConsumerWidget {
  WebScreen({Key? key}) : super(key: key);

  static const sampleUrl =
      'https://images.unsplash.com/photo-1494354145959-25cb82edf23d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80';

  static String uniqueTag = generateEditHeroTag('network');

  final urlController = TextEditingController();

  String? _handleException(BuildContext context, Exception? e) {
    final l10n = L10n.of(context)!;
    if (e is FormatException) {
      return l10n.webFormatError;
    } else if (e is NetworkImageException) {
      if (e.errorType == NetworkImageExceptionType.notImage) {
        return l10n.webNetworkImageErrorNotImage;
      } else {
        debugLog('${e.errorType}: ${e.message}');
        return l10n.webNetworkImageErrorOther;
      }
    } else if (e is Exception) {
      return l10n.webOtherError;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;

    final imageFile = ref.watch(webStateProvider.select((v) => v.imageFile));
    final exception = ref.watch(webStateProvider.select((v) => v.exception));

    final notifier = ref.read(webStateProvider.notifier);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: urlController,
              style: const TextStyle(
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: l10n.webTextFieldHint,
                errorText: _handleException(context, exception),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(160),
                ),
                contentPadding: const EdgeInsets.only(left: 20, right: 4),
                filled: true,
                fillColor: Theme.of(context).bottomAppBarTheme.color,
                suffixIcon: IconButton(
                  onPressed: urlController.clear,
                  icon: const Icon(Icons.clear),
                ),
              ),
              onSubmitted: (inputUrl) async {
                await notifier.loadImage(inputUrl);
              },
            ),
            TextButton(
              onPressed: () {
                urlController.text = sampleUrl;
                notifier.loadImage(sampleUrl);
              },
              child: Text(l10n.webSampleImage),
            ),
            const SizedBox(height: 24),
            if (imageFile != null)
              Hero(
                tag: uniqueTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: kBottomNavigationBarHeight + 24),
          ],
        ),
      ),
    );
  }
}
