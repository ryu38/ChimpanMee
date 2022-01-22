import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // do not define scaffold as const: theme reflection will not work.
    return Scaffold(
      body: const Center(
        child: Text('App could not be launched due to an initialization error'),
      ),
    );
  }
}
