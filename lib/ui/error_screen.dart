import 'package:chimpanmee/components/widgets/error_display.dart';
import 'package:flutter/material.dart';
import 'package:chimpanmee/l10n/l10n.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final l10n = L10n.of(context)!;

    // do not define scaffold as const: theme reflection will not work.
    // ignore: prefer_const_constructors
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: ErrorDisplay(
                    headline: l10n.initErrorHead,
                    description: l10n.initErrorDescription,
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
