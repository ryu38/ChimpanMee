import 'package:flutter/foundation.dart';

void debugLog(Object message, [String tag = 'APP DEBUG']) {
  if (kDebugMode) {
    print('$tag: $message');
  }
}
