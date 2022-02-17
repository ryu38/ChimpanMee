import 'dart:io';

import 'package:chimpanmee/components/toast.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:chimpanmee/utlis/file_utils.dart';
import 'package:chimpanmee/utlis/http_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_state.freezed.dart';

@freezed
class WebState with _$WebState {
  factory WebState({
    File? imageFile,
    Exception? exception,
    required bool isLoading,
  }) = _WebState;
}

final webStateProvider = StateNotifierProvider<WebStateNotifier, WebState>(
    (ref) => WebStateNotifier());

class WebStateNotifier extends StateNotifier<WebState> {
  WebStateNotifier()
      : super(WebState(
          isLoading: false,
        ));

  final _cache = <String, String>{};

  Future<void> loadImage(String url) async {
    state = state.copyWith(
      isLoading: true,
    );
    try {
      final cachedFileName = _cache[url];
      final File imageFile;
      if (cachedFileName == null) {
        final parsedUrl = Uri.parse(url);
        if (!parsedUrl.isAbsolute) throw FormatException('Invalid URL');
        final imageData = await getNetworkImage(parsedUrl);
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final imageFilename = 'network_$timestamp.jpg';
        final savePath = await joinPathToCache(imageFilename);
        imageFile = File(savePath)..writeAsBytesSync(imageData);
        _cache[url] = imageFilename;
      } else {
        debugLog('cached');
        final savePath = await joinPathToCache(cachedFileName);
        imageFile = File(savePath);
      }
      state = state.copyWith(
        imageFile: imageFile,
        exception: null,
        isLoading: false,
      );
    } on Exception catch (e) {
      setException(e);
    }
  }

  void setException(Exception e) {
    state = state.copyWith(
      exception: e,
      isLoading: false,
    );
  }
}
