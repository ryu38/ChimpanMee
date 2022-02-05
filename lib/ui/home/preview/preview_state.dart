import 'package:chimpanmee/init_values.dart';
import 'package:chimpanmee/main.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_state.freezed.dart';

@freezed
abstract class PreviewState with _$PreviewState {
  factory PreviewState({
    required String inputPath,
    String? outputPath,
    required bool isOutputShown,
    String? error,
  }) = _PreviewState;
}

final previewStateProvider = 
    StateNotifierProvider.autoDispose<PreviewStateNotifier, PreviewState>(
      (_) => throw UnimplementedError(),
    );

final previewStateProviderFamily = 
    StateNotifierProvider.autoDispose.family<PreviewStateNotifier, PreviewState, String>(
      (ref, inputPath) => PreviewStateNotifier(
        read: ref.read,
        inputPath: inputPath,
      ),
    );

class PreviewStateNotifier extends StateNotifier<PreviewState> {
  PreviewStateNotifier({
    required this.read,
    required String inputPath,
    String? outputPath,
    bool isOutputShown = false,
  }) : super(PreviewState(
    inputPath: inputPath,
    outputPath: outputPath,
    isOutputShown: isOutputShown,
  ));

  final Reader read;

  Future<void> getTransformed() async {
    debugLog('start ML process');
    final stopwatch = Stopwatch()..start();
    final outputPath = 
        await read(initProvider).mlManager.transformImage(state.inputPath);
    debugLog(outputPath);
    debugLog('exec time: ${stopwatch.elapsedMilliseconds}');
    state = state.copyWith(
      outputPath: outputPath,
      isOutputShown: true,
    );
  }

  Future<void> switchImage() async {
    if (state.outputPath != null) {
      state = state.copyWith(
        isOutputShown: !state.isOutputShown
      );
    }
  }
}
