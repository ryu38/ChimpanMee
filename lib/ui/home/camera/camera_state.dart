import 'package:camera/camera.dart';
import 'package:chimpanmee/components/app_error.dart';
import 'package:chimpanmee/init_values.dart';
import 'package:chimpanmee/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'camera_state.freezed.dart';

@freezed
abstract class CameraState with _$CameraState {
  factory CameraState({
    required int cameraId,
    required AsyncValue<CameraController> controller,
    required bool isCameraActive,
  }) = _CounterState;
}

final cameraStateProvider =
    StateNotifierProvider.autoDispose<CameraStateNotifier, CameraState>(
  (ref) => CameraStateNotifier(read: ref.read),
);

class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier({
    required this.read,
    int cameraId = 0,
  }) : super(CameraState(
          cameraId: cameraId,
          controller: const AsyncValue.loading(),
          isCameraActive: false,
        )) {
    initialize();
  }

  final Reader read;
  List<CameraDescription> get cameras => read(initProvider).cameras;

  /// throw errors if failed
  Future<void> initialize() async {
    final controller = await AsyncValue.guard(() async {
      if (cameras.isEmpty) {
        throw AppException('No cameras are available');
      }
      final controller = _getCameraController(cameras[state.cameraId]);
      await controller.initialize();
      return controller;
    });
    final isCameraActive = controller.whenOrNull(data: (_) => true) ?? false;
    state = state.copyWith(
      controller: controller,
      isCameraActive: isCameraActive,
    );
  }

  /// throw errors if failed
  Future<void> switchCamera() async {
    final nextCameraId =
        state.cameraId + 1 < cameras.length ? state.cameraId + 1 : 0;
    state = state.copyWith(
      cameraId: nextCameraId,
    );
    await initialize();
  }

  Future<void> disposeCamera() async {
    state.controller.whenData((controller) {
      if (state.isCameraActive) {
        controller.dispose();
        state = state.copyWith(
          isCameraActive: false,
        );
      }
    });
  }

  @override
  void dispose() {
    state.controller.whenData((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  static CameraController _getCameraController(CameraDescription camera) =>
      CameraController(
        camera,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg,
        enableAudio: false,
      );
}
