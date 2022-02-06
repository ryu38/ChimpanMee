import 'dart:io';

import 'package:chimpanmee/components/app_error.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  factory AppPermission() => _instance;

  const AppPermission._({
    required this.gallery,
    required this.camera,
  });

  factory AppPermission._init() {
    final AppPermission instance;
    if (Platform.isAndroid) {
      instance = const AppPermission._android();
    } else if (Platform.isIOS) {
      instance = const AppPermission._ios();
    } else {
      throw AppException(
          'the platform not supported; supporting ios or android');
    }
    return instance;
  }

  const AppPermission._android() : this._(
    gallery: Permission.storage, 
    camera: Permission.camera,
  );

  const AppPermission._ios() : this._(
    gallery: Permission.photos, 
    camera: Permission.camera,
  );

  static final _instance = AppPermission._init();

  final Permission gallery;
  final Permission camera;
}
