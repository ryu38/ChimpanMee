import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chimpanmee/components/errors/app_exception.dart';
import 'package:chimpanmee/components/errors/permission_denied.dart';
import 'package:chimpanmee/components/widgets/error_display.dart';
import 'package:chimpanmee/components/widgets/square_box.dart';
import 'package:chimpanmee/platform_permission.dart';
import 'package:chimpanmee/ui/home/camera/camera_error.dart';
import 'package:chimpanmee/ui/home/camera/camera_state.dart';
import 'package:chimpanmee/ui/home/preview/preview.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:chimpanmee/utlis/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chimpanmee/l10n/l10n.dart';
import 'package:chimpanmee/theme/theme.dart';

// LayoutBuilderの反映がcamera controllerに追いつかない?
// controllerの処理はstateNotifierでやらないことにした

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) =>
            _CameraLoader(screenConstraints: constraints));
  }
}

class _CameraLoader extends ConsumerStatefulWidget {
  const _CameraLoader({
    Key? key,
    required this.screenConstraints,
  }) : super(key: key);

  final BoxConstraints screenConstraints;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<_CameraLoader>
    with WidgetsBindingObserver {
  CameraStateNotifier get notifier => ref.read(cameraStateProvider.notifier);

  bool _openingSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _openingSettings) {
      debugLog('resumed');
      ref.read(cameraStateProvider).controller.whenOrNull(
        error: (error, _) {
          if (error is PermissionDeniedException) {
            notifier.initialize();
            _openingSettings = false;
          }
        },
      );
    }
  }

  Future<void> retry() async {
    final status = await AppPermission().camera.status;
    debugLog(status.toString());
    if (status.isPermanentlyDenied || status.isDenied) {
      await Future<void>.delayed(const Duration(microseconds: 1));
      _openingSettings = true;
      await openAppSettings();
    } else {
      await notifier.initialize();
    }
  }

  ErrorDisplay handleException(BuildContext context, Object err) {
    String? msg;
    if (err is Error) throw err;

    final l10n = L10n.of(context)!;

    if (err is PermissionDeniedException) {
      return ErrorDisplay(
        headline: l10n.permissionErrorHead,
        description: l10n.permissionCameraErrorDescription,
        solveButtonText: l10n.permissionErrorSolve,
        solveFunc: retry,
      );
    } else if (err is NoCamerasException) {
      return ErrorDisplay(
        headline: l10n.noCamerasErrorHead,
        description: l10n.noCamerasErrorDescription,
      );
    }
    return ErrorDisplay(
      solveButtonText: l10n.errorReloadSolve,
      solveFunc: notifier.initialize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final constraints = widget.screenConstraints;
    debugLog(constraints);
    final asyncController =
        ref.watch(cameraStateProvider.select((v) => v.controller));
    return asyncController.when(
      data: (controller) => _CameraMain(
        controller: controller,
        screenConstraints: constraints,
      ),
      error: (error, _) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              handleException(context, error),
              const SizedBox(height: kBottomNavigationBarHeight + 60),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _CameraMain extends ConsumerStatefulWidget {
  const _CameraMain({
    Key? key,
    required this.controller,
    required this.screenConstraints,
  }) : super(key: key);

  final CameraController controller;
  final BoxConstraints screenConstraints;

  @override
  __CameraMainState createState() => __CameraMainState();
}

class __CameraMainState extends ConsumerState<_CameraMain> {
  bool _takingPhoto = false;

  Future<File> _takePhoto(CameraController controller) async {
    if (Platform.isIOS) {
      try {
        await controller.setFlashMode(FlashMode.off);
      } on Exception {}
    }
    final imageXFile = await controller.takePicture();
    final rotatedFile =
        await FlutterExifRotation.rotateImage(path: imageXFile.path);
    return rotatedFile;
  }

  Future<void> _shutterButtonAction() async {
    if (_takingPhoto) return;
    setState(() {
      _takingPhoto = true;
    });
    final rotatedFile = await _takePhoto(widget.controller);
    debugLog('photo is taken');
    await ref.read(cameraStateProvider.notifier).closeCameraView();
    if (!ref.read(cameraStateProvider).isCameraActive) {
      debugLog('camera deactive');
      await widget.controller.dispose();
    }
    await Navigator.of(context).pushNamed(
      PreviewScreen.route,
      arguments: rotatedFile.path,
    );
    rotatedFile.deleteSync();
    await ref.read(cameraStateProvider.notifier).initialize();
    setState(() {
      _takingPhoto = false;
    });
  }

  double get _minSpaceUnderCameraView => 184 + kBottomNavigationBarHeight;

  @override
  Widget build(BuildContext context) {
    final constraints = widget.screenConstraints;
    final spaceUnderCameraView = constraints.maxHeight - constraints.maxWidth;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Container(
            color: Theme.of(context).colorScheme.cameraMarginColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_CameraWrapper(controller: widget.controller)],
            ),
          ),
        ),
        SizedBox(
          height: spaceUnderCameraView > _minSpaceUnderCameraView
              ? spaceUnderCameraView
              : _minSpaceUnderCameraView,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: ElevatedButton(
                    onPressed: !_takingPhoto ? _shutterButtonAction : null,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      elevation: 0,
                      primary: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: kBottomNavigationBarHeight + 24,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CameraWrapper extends ConsumerWidget {
  const _CameraWrapper({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final CameraController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCameraActive =
        ref.watch(cameraStateProvider.select((v) => v.isCameraActive));
    if (isCameraActive) {
      return _CameraDisplayer(controller: controller);
    }
    return const SquareBox();
  }
}

class _CameraDisplayer extends StatelessWidget {
  const _CameraDisplayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: SizedBox(
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
              width: controller.value.previewSize!.height,
              height: controller.value.previewSize!.width,
              child: CameraPreview(controller)),
        ),
      ),
    );
  }
}
