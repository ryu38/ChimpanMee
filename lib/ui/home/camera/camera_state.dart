import 'package:camera/camera.dart';
import 'package:chimpanmee/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'camera_state.freezed.dart';

@freezed
abstract class CameraState with _$CameraState {
  factory CameraState({
    required int cameraId,
    CameraController? controller,
    required bool initialized,
  }) = _CounterState;
}

final cameraStateProvider = StateNotifierProvider<CameraStateNotifier, CameraState>(
  (ref) => CameraStateNotifier(read: ref.read),
);

class CameraStateNotifier extends StateNotifier<CameraState> {

  CameraStateNotifier({
    required this.read,
    int cameraId = 0,
    CameraController? controller,
  }) : super(CameraState(
    cameraId: cameraId, 
    controller: controller,
    initialized: false,
  ));

  static int get initCameraId => 0;

  final Reader read;
  List<CameraDescription> get cameras => read(camerasProvider);

  /// throw errors if failed
  Future<void> initialize() async {
    if (cameras.isEmpty) {
      throw Exception('No cameras are available');
    }
    final controller = _getCameraController(cameras[initCameraId]);
    await controller.initialize();
    state = state.copyWith(
      cameraId: initCameraId,
      controller: controller,
      initialized: true,
    );
  }

  /// throw errors if failed
  Future<void> switchCamera() async {
    final nextCameraId = state.cameraId + 1 < cameras.length 
        ? state.cameraId + 1 : 0;
    final controller = _getCameraController(cameras[nextCameraId]);
    await controller.initialize();
    state = state.copyWith(
      cameraId: nextCameraId,
      controller: controller,
      initialized: true,
    );
  }

  Future<void> disposeCamera() async {
    if (state.controller != null) {
      state = state.copyWith(
        initialized: false,
      );
      await state.controller!.dispose();
    }
  }

  static CameraController _getCameraController(CameraDescription camera) 
      => CameraController(
        camera,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
}
