import 'package:flutter/material.dart';
import 'package:chimpanmee/l10n/l10n.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    Key? key,
    this.headline,
    this.description,
    this.solveButtonText,
    this.solveFunc,
  })  : super(key: key);

  final String? headline;
  final String? description;
  final String? solveButtonText;
  final void Function()? solveFunc;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

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
              headline ?? l10n.defaultErrorHead,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 24),
            Text(
              description ?? l10n.defaultErrorDescription,
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
