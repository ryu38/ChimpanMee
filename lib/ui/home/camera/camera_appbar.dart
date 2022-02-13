import 'package:chimpanmee/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chimpanmee/l10n/l10n.dart';

AppBar _cameraAppBarGenerator(BuildContext context, WidgetRef ref) {
  final l10n = L10n.of(context)!;
  return AppBar(
    title: Text(l10n.appBarCamera),
  );
}

AppBarGenerator cameraAppBarGenerator = _cameraAppBarGenerator;
