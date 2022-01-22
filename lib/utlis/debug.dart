import 'package:flutter/foundation.dart';

void debugLog(String message, [String tag = 'APP DEBUG']) {
  if (kDebugMode) {
    print('$tag: $message');
  }
}
