import 'package:chimpanmee/components/widgets/error_display.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // do not define scaffold as const: theme reflection will not work.
    // ignore: prefer_const_constructors
    return Scaffold(
      body: const Center(
        child: ErrorDisplay(
          headline: 'Error',
          description: '''
The app could not be launched due to an initialization error.

Please try to restart the app.
''',
        ),
      ),
    );
  }
}
