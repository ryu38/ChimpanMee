import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_state.freezed.dart';

@freezed
abstract class PreviewState with _$PreviewState {
  factory PreviewState({
    String? inputPath,
    String? outputPath,
  }) = _PreviewState;
}

final previewStateProvider = 
    StateNotifierProvider<PreviewStateNotifier, PreviewState>(
      (_) => PreviewStateNotifier()
    );

class PreviewStateNotifier extends StateNotifier<PreviewState> {
  PreviewStateNotifier({
    String? inputPath,
    String? outputPath,
  }) : super(PreviewState(
    inputPath: inputPath,
    outputPath: outputPath,
  ));

  void setInputPath(String inputPath) {
    state = state.copyWith(
      inputPath: inputPath,
    );
  }
}
