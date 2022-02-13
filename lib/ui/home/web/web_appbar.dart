import 'package:chimpanmee/components/widgets/appbar_elevated_button.dart';
import 'package:chimpanmee/ui/home/edit/edit.dart';
import 'package:chimpanmee/ui/home/edit/edit_props.dart';
import 'package:chimpanmee/ui/home/home.dart';
import 'package:chimpanmee/ui/home/web/web.dart';
import 'package:chimpanmee/ui/home/web/web_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chimpanmee/l10n/l10n.dart';

AppBar _webAppBarGenerator(BuildContext context, WidgetRef ref) {
  final l10n = L10n.of(context)!;
  final imageFile = ref.watch(webStateProvider.select((v) => v.imageFile));
  final actions = <Widget>[
    if (imageFile != null)
      Align(
        child: AppBarElevatedButton(
          onPressed: () async {
            await precacheImage(FileImage(imageFile), context);
            await Navigator.of(context).pushNamed(
              EditScreen.route,
              arguments: EditProps(
                imageFile: imageFile,
                uniqueTag: WebScreen.uniqueTag,
              ),
            );
          },
          child: Text(l10n.webNextButton),
        ),
      ),
    const SizedBox(width: 12),
  ];
  return AppBar(
    title: Text(l10n.appBarWeb),
    actions: actions,
  );
}

AppBarGenerator webAppBarGenerator = _webAppBarGenerator;
