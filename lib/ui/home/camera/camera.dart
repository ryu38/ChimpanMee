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
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chimpanmee/l10n/l10n.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
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
      solveButtonText: 'Reload',
      solveFunc: notifier.initialize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncController =
        ref.watch(cameraStateProvider.select((v) => v.controller));
    return asyncController.when(
      data: (controller) => _CameraMain(controller: controller),
      error: (error, _) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          handleException(context, error),
          const SizedBox(height: kBottomNavigationBarHeight),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _CameraMain extends ConsumerWidget {
  const _CameraMain({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final CameraController controller;

  Future<String> takePhoto(CameraController controller) async {
    final imageXFile = await controller.takePicture();
    await FlutterExifRotation.rotateAndSaveImage(path: imageXFile.path);
    return imageXFile.path;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCameraActive =
        ref.watch(cameraStateProvider.select((v) => v.isCameraActive));
    return Column(
      children: [
        isCameraActive
            ? _CameraDisplayer(controller: controller)
            : const SquareBox(),
        const Spacer(),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              final path = await takePhoto(controller);
              await ref.read(cameraStateProvider.notifier).disposeCamera();
              await Navigator.of(context).pushNamed(
                PreviewScreen.route,
                arguments: path,
              );
              await ref.read(cameraStateProvider.notifier).initialize();
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              elevation: 0,
              primary:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
            ),
            child: const Icon(
              Icons.photo_camera,
              size: 40,
            ),
          ),
        ),
        const Spacer(),
        const SizedBox(
          height: kBottomNavigationBarHeight,
        ),
      ],
    );
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
