import 'package:flutter/material.dart';

class SquareBox extends StatelessWidget {
  const SquareBox({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}
