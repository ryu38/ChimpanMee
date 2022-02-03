import 'package:chimpanmee/ui/home/edit/edit.dart';
import 'package:chimpanmee/ui/home/edit/edit_props.dart';
import 'package:chimpanmee/ui/home/home.dart';
import 'package:chimpanmee/ui/home/web/web.dart';
import 'package:chimpanmee/ui/home/web/web_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

AppBar _webAppBarGenerator(BuildContext context, WidgetRef ref) {
  final imageFile = 
      ref.watch(webStateProvider.select((v) => v.imageFile));
  final actions = <Widget>[
    if (imageFile != null) Align(
      child: ElevatedButton(
        onPressed: () async {
          await precacheImage(FileImage(imageFile), context);
          await Navigator.of(context).pushNamed(
            EditScreen.route, 
            arguments: EditProps(
              imageFile: imageFile, uniqueTag: WebScreen.uniqueTag,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(160),
          ),
        ),
        child: const Text('Next'),
      ),
    ),
    const SizedBox(width: 12),
  ];
  return AppBar(
    title: const Text('Load Image Link'),
    actions: actions,
  );
}

AppBarGenerator webAppBarGenerator = _webAppBarGenerator;
