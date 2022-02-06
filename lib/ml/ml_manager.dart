import 'package:chimpanmee/components/app_error.dart';
import 'package:chimpanmee/ml/ml_const.dart';
import 'package:chimpanmee/utlis/file_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ml_image_transformation/flutter_ml_image_transformation.dart';

class MLManager {

  MLManager._({
    required this.modelPath,
  });

  static Future<MLManager> get getManager async {
    final modelPath = await copyAssetToAppDir(
        MLConst().assetModelPath, MLConst().appDirModelName);
    final result = await MLImageTransformer.setModel(modelPath: modelPath);
    if (result != null) throw AppException(result);
    return MLManager._(modelPath: modelPath);
  }

  final String modelPath;

  Future<String> transformImage(String imagePath) async {
    final outputPath = await joinPathToCache(MLConst().cacheOutputName);
    final result = await MLImageTransformer.transformImage(
      imagePath: imagePath, outputPath: outputPath
    );
    if (result != null) throw AppException(result);
    return outputPath;
  }
}
