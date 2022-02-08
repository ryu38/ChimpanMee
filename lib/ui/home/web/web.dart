import 'package:chimpanmee/theme/color.dart';
import 'package:chimpanmee/components/square_box.dart';
import 'package:chimpanmee/ui/home/edit/edit.dart';
import 'package:chimpanmee/ui/home/edit/edit_hero_tag.dart';
import 'package:chimpanmee/ui/home/edit/edit_props.dart';
import 'package:chimpanmee/ui/home/web/web_state.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chimpanmee/theme/theme.dart';

class WebScreen extends ConsumerWidget {
  WebScreen({Key? key}) : super(key: key);

  static const sampleUrl =
      'https://images.unsplash.com/photo-1494354145959-25cb82edf23d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80';

  static String uniqueTag = generateEditHeroTag('network');

  final urlController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageFile = ref.watch(webStateProvider.select((v) => v.imageFile));
    final errorMsg = ref.watch(webStateProvider.select((v) => v.errorMsg));

    final notifier = ref.read(webStateProvider.notifier);

    print(kBottomNavigationBarHeight);

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
                hintText: 'Type image link',
                errorText: errorMsg,
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
              child: const Text('Type sample link'),
            ),
            const SizedBox(height: 24),
            if (imageFile != null)
              Hero(
                tag: uniqueTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(imageFile.readAsBytesSync()),
                ),
              ),
            const SizedBox(height: kBottomNavigationBarHeight + 24),
          ],
        ),
      ),
    );
  }
}
