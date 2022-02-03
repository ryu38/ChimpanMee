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
    String? errorMsg,
    required bool isLoading,
  }) = _WebState;
}

final webStateProvider = 
    StateNotifierProvider<WebStateNotifier, WebState>(
      (ref) => WebStateNotifier()
    );

class WebStateNotifier extends StateNotifier<WebState> {
  WebStateNotifier(): super(WebState(
    isLoading: false,
  ));

  Future<void> loadImage(String url) async {
    print('start loading image');
    state = state.copyWith(
      isLoading: true,
    );
    try {
      final parsedUrl = Uri.parse(url);
      if (!parsedUrl.isAbsolute) throw FormatException('Invalid URL');
      final imageData = await getNetworkImage(parsedUrl);
      final savePath = await joinPathToCache('network.jpg');
      final imageFile = File(savePath)
          ..writeAsBytesSync(imageData);
      state = state.copyWith(
        imageFile: imageFile,
        errorMsg: null,
        isLoading: false,
      );
    } on FormatException catch (e) {
      setErrorMsg(e.message);
    } on NetworkImageException catch (e) {
      setErrorMsg(e.message);
    } on Exception catch (e) {
      debugLog(e.toString());
      setErrorMsg('Error occurred');
    }
  }

  void setErrorMsg(String msg) {
    state = state.copyWith(
      errorMsg: msg,
      isLoading: false,
    );
  }
}
