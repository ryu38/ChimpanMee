import 'dart:io';
import 'dart:typed_data';

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
    String? url,
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
      final Uint8List imageData;
      if (cachedFileName == null) {
        final parsedUrl = Uri.parse(url);
        if (!parsedUrl.isAbsolute) throw FormatException('Invalid URL');
        imageData = await getNetworkImage(parsedUrl);
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final imageFilename = 'network_$timestamp.jpg';
        final cachePath = await joinPathToCache(imageFilename);
        File(cachePath).writeAsBytesSync(imageData);
        _cache[url] = imageFilename;
      } else {
        debugLog('cached');
        final cachePath = await joinPathToCache(cachedFileName);
        try {
          imageData = File(cachePath).readAsBytesSync();
        } on FileSystemException {
          debugLog('failed to get cached image');
          debugLog('try to load image again');
          _cache.remove(url);
          await loadImage(url);
          return;
        }
      }
      final savePath = await joinPathToAppDir('network.jpg');
      final imageFile = File(savePath)..writeAsBytesSync(imageData);
      state = state.copyWith(
        imageFile: imageFile,
        url: url,
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
