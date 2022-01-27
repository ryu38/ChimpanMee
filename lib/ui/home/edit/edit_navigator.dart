import 'dart:io';

import 'package:chimpanmee/ui/home/edit/crop/crop.dart';
import 'package:flutter/material.dart';

Future<void> navigateCrop(
  BuildContext context, {
  required File imageFile,
}) async {
  await Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (context) => CropScreen(imageFile: imageFile),
  ));
}
