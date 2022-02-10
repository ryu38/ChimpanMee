import 'package:flutter/material.dart';

class AppBarElevatedButton extends StatelessWidget {
  const AppBarElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(160),
        ),
      ),
      child: child,
    );
  }
}
