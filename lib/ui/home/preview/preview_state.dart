import 'package:chimpanmee/main.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_state.freezed.dart';

@freezed
abstract class PreviewState with _$PreviewState {
  factory PreviewState({
    String? inputPath,
    String? outputPath,
    required bool isOutputShown,
    String? error,
  }) = _PreviewState;
}

final previewStateProvider = 
    StateNotifierProvider<PreviewStateNotifier, PreviewState>(
      (ref) => PreviewStateNotifier(
        read: ref.read,
      ),
    );

class PreviewStateNotifier extends StateNotifier<PreviewState> {
  PreviewStateNotifier({
    required this.read,
    String? inputPath,
    String? outputPath,
    bool isOutputShown = false,
  }) : super(PreviewState(
    inputPath: inputPath,
    outputPath: outputPath,
    isOutputShown: isOutputShown,
  ));

  final Reader read;

  void setInputPath(String inputPath) {
    debugLog(inputPath);
    state = state.copyWith(
      inputPath: inputPath,
    );
  }

  Future<void> getTransformed() async {
    debugLog('start ML process');
    final stopwatch = Stopwatch()..start();
    final outputPath = 
        await read(mlManagerProvider)!.transformImage(state.inputPath!);
    debugLog(outputPath);
    debugLog('exec time: ${stopwatch.elapsedMilliseconds}');
    state = state.copyWith(
      outputPath: outputPath,
      isOutputShown: true,
    );
  }

  void reset() {
    state = state.copyWith(
      inputPath: null,
      outputPath: null,
      isOutputShown: false,
      error: null,
    );
  }
}
