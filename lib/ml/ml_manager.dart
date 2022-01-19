import 'package:chimpanmee/ml/ml_const.dart';
import 'package:chimpanmee/utlis/file_utils.dart';
import 'package:flutter_ml_image_transformation/flutter_ml_image_transformation.dart';

class MLManager {

  MLManager._({
    required this.modelPath,
  });

  static Future<MLManager> get init async {
    final modelPath = await copyAssetToAppDir(
        MLConst().assetModelPath, MLConst().appDirModelName);
    final result = await MLImageTransformer.setModel(modelPath: modelPath);
    if (result != null) throw Exception(result);
    return MLManager._(modelPath: modelPath);
  }

  Future<String> transformImage(String imagePath) async {
    final outputPath = await joinPathToCache(MLConst().cacheOutputName);
    final result = await MLImageTransformer.transformImage(
      imagePath: imagePath, outputPath: outputPath
    );
    if (result != null) throw Exception(result);
    return outputPath;
  }

  final String modelPath;

  
}
