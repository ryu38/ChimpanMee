import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> copyAssetToAppDir(String assetPath, String saveRelPath) async {
  final savePath = await joinPathToAppDir(saveRelPath);
  await copyAssetToPath(assetPath, savePath);
  return savePath;
}

Future<String> joinPathToAppDir(String relPath) async {
  final appDir = await getApplicationDocumentsDirectory();
  return join(appDir.path, relPath);
}

Future<String> copyAssetToCache(String assetPath, String saveRelPath) async {
  final savePath = await joinPathToCache(saveRelPath);
  await copyAssetToPath(assetPath, savePath);
  return savePath;
}

Future<String> joinPathToCache(String relPath) async {
  final appDir = await getTemporaryDirectory();
  return join(appDir.path, relPath);
}

Future<void> copyAssetToPath(String assetPath, String savePath) async {
  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(savePath).writeAsBytes(bytes);
}
