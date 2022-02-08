import 'package:camera/camera.dart';
import 'package:chimpanmee/components/app_error.dart';
import 'package:chimpanmee/components/square_box.dart';
import 'package:chimpanmee/ui/home/camera/camera_state.dart';
import 'package:chimpanmee/ui/home/preview/preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraScreen extends ConsumerWidget {
  const CameraScreen({
    Key? key,
  }) : super(key: key);

  String handleException(Object err) {
    String? msg;
    if (err is Error) throw err;

    if (err is AppException) {
      msg = err.message;
    }
    return msg ?? 'Error occurred while launching camera';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncController =
        ref.watch(cameraStateProvider.select((v) => v.controller));
    return asyncController.when(
      data: (controller) => _CameraMain(controller: controller),
      error: (error, _) =>
          Center(child: Text(handleException(error))),
      loading: () => const CircularProgressIndicator(),
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
              size: 32,
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
