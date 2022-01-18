import 'package:camera/camera.dart';
import 'package:chimpanmee/main.dart';
import 'package:chimpanmee/ui/camera/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      future: ref.read(cameraStateProvider.notifier).initializer(),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: CameraPreview(ref.watch(cameraStateProvider).controller!),
        ),
        const Spacer(),
        Center(
          child: ElevatedButton(
              onPressed: () {},
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
