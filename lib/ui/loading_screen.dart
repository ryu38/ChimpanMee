import 'package:chimpanmee/theme/color.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // do not define scaffold as const: theme reflection will not work.
    return Scaffold(
      body: Center(
        child: Text(
          'ChimpanMee',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
