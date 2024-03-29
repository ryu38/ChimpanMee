import 'dart:io';

import 'package:chimpanmee/components/errors/app_exception.dart';

/// Singleton class that is different by platform (android or ios)
class MLConst {

  factory MLConst() => _instance;

  const MLConst._({
    required this.assetModelPath,
    required this.appDirModelName,
    this.cacheOutputName = 'output.jpg'
  });

  factory MLConst._init() {
    final MLConst instance;
    if (Platform.isAndroid) {
      instance = const MLConst._android();
    } else if (Platform.isIOS) {
      instance = const MLConst._ios();
    } else {
      throw AppException(
        'the platform not supported; supporting ios or android'
      );
    }
    return instance;
  }

  const MLConst._android(): this._(
    assetModelPath: 'assets/pytorch_model/Human2Chimp_v1.ptl', 
    appDirModelName: 'GANModel.ptl',
  );

  const MLConst._ios(): this._(
    assetModelPath: 'assets/coreml_model/Human2Chimp_v1-8bit.mlmodel', 
    appDirModelName: 'GANModel.mlmodel',
  );

  static final _instance = MLConst._init();

  final String assetModelPath;
  final String appDirModelName;
  final String cacheOutputName;
}
