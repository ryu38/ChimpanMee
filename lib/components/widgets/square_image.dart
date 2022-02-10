import 'dart:io';

import 'package:chimpanmee/components/widgets/square_box.dart';
import 'package:flutter/material.dart';

class SquareImage extends StatelessWidget {
  const SquareImage(
    this.imagePath, { 
    Key? key,
  }) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    try {
      return AspectRatio(
        aspectRatio: 1,
        child: Image.memory(
          File(imagePath).readAsBytesSync(),
          fit: BoxFit.cover,
        ),
      );
    } on Exception {}
    return const SquareBox();
  }
}
