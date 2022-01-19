import 'package:camera/camera.dart';
import 'package:chimpanmee/main.dart';
import 'package:chimpanmee/ui/camera/camera_state.dart';
import 'package:chimpanmee/ui/navigator.dart';
import 'package:chimpanmee/utlis/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _cachedImageName = 'output.jpg';

class CameraScreen extends ConsumerWidget {
  const CameraScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameras = ref.read(camerasProvider);
    return cameras.isNotEmpty
        ? _CameraInitializer()
        : const Center(
            child: Text('No Cameras are available'),
          );
  }
}

class _CameraInitializer extends ConsumerWidget {
  _CameraInitializer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(cameraStateProvider.notifier).initialize(),
      builder: (context, snapshot) {
        return snapshot.hasError
            ? const Center(child: Text('Error Occurred'))
            : snapshot.connectionState != ConnectionState.done
                ? const Center(child: CircularProgressIndicator())
                : _CameraMain();
      },
    );
  }
}

class _CameraMain extends ConsumerStatefulWidget {
  const _CameraMain({Key? key}) : super(key: key);

  @override
  __CameraMainState createState() => __CameraMainState();
}

class __CameraMainState extends ConsumerState<_CameraMain> {

  Future<String> takePhoto(WidgetRef ref) async {
    final controller = ref.read(cameraStateProvider).controller!;
    final imageXFile = await controller.takePicture();
    await FlutterExifRotation.rotateAndSaveImage(path: imageXFile.path);
    return imageXFile.path;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(cameraStateProvider).controller!;
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: controller.value.previewSize!.height,
                height: controller.value.previewSize!.width,
                child: CameraPreview(controller)
              ),
            ),
          ),
        ),
        const Spacer(),
        Center(
          child: ElevatedButton(
              onPressed: () async {
                final path = await takePhoto(ref);
                navigatePreview(context, ref, inputPath: path);
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
              )),
        ),
        const Spacer(),
      ],
    );
  }
}
