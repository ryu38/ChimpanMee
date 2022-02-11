import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    Key? key,
    String? headline,
    String? description,
    this.solveButtonText,
    this.solveFunc,
  })  : headline = headline ?? 'Error Occurred',
        description = description ??
            '''
Something is wrong with the app.
Please reopen this screen or restart the app.
        ''',
        super(key: key);

  final String headline;
  final String description;
  final String? solveButtonText;
  final void Function()? solveFunc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🙈',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 104,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              headline,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 24),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            if (solveButtonText != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: solveFunc,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    solveButtonText!,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
