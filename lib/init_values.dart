import 'package:camera/camera.dart';
import 'package:chimpanmee/ml/ml_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late final InitValues _initValues;

final initProvider = Provider<InitValues>(
  (_) => _initValues,
);

final initStatusProvider = FutureProvider<void>((_) async {
  _initValues = await InitValues.init();
});

class InitValues {
  InitValues._({
    this.cameras = const [],
    required this.mlManager,
  });

  static Future<InitValues> init() async {
    final cameras = await _getAvailableCameras();
    final mlManager = await MLManager.getManager;
    return InitValues._(
      cameras: cameras,
      mlManager: mlManager,
    );
  }

  final List<CameraDescription> cameras;
  final MLManager mlManager;
}

Future<List<CameraDescription>> _getAvailableCameras() async {
  try {
    return await availableCameras();
  } on CameraException {
    return [];
  }
}
