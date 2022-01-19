import 'package:chimpanmee/Color.dart';
import 'package:chimpanmee/l10n/l10n.dart';
import 'package:chimpanmee/ui/camera/camera.dart';
import 'package:chimpanmee/ui/camera/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  _Page _currentPage = _Page.gallery;

  GestureDetector _navButton({
    required IconData defaultIcon,
    required IconData activeIcon,
    required String labelText,
    required _Page targetPage,
    required void Function()? onPressed,
    bool reverse = false,
  }) {
    final isPageMatch = _currentPage == targetPage;
    final activeColor = Theme.of(context).primaryColor;
    final widgetList = [
      Icon(
        isPageMatch ? activeIcon : defaultIcon,
        color: isPageMatch ? activeColor : null,
      ),
      const SizedBox(width: 4),
      Text(
        labelText,
        style: TextStyle(
          color: isPageMatch ? activeColor : null,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      )
    ];
    return GestureDetector(
      onTap: isPageMatch ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: reverse ? List.from(widgetList.reversed) : widgetList,
        ),
      ),
    );
  }

  Future<void> _fabAction(WidgetRef ref) async {
    if (_currentPage == _Page.camera) {
      if (ref.read(cameraStateProvider).initialized) {
        await ref.read(cameraStateProvider.notifier).switchCamera();
      }
    } else {
      setState(() {
        _currentPage = _Page.camera;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _currentPage.widget,
      floatingActionButton: SizedBox(
        width: 72,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              _fabAction(ref);
            },
            child: _currentPage != _Page.camera 
                ? const Icon(Icons.photo_camera)
                : const Icon(Icons.rotate_90_degrees_ccw),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 12,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navButton(
                defaultIcon: Icons.insert_photo,
                activeIcon: Icons.insert_photo_sharp,
                labelText: l10n.navBarGallery,
                targetPage: _Page.gallery,
                onPressed: () {
                  setState(() {
                    _currentPage = _Page.gallery;
                  });
                },
                reverse: true,
              ),
              const SizedBox(width: 72),
              _navButton(
                defaultIcon: Icons.web,
                activeIcon: Icons.web_sharp,
                labelText: l10n.navBarWeb,
                targetPage: _Page.web,
                onPressed: () {
                  setState(() {
                    _currentPage = _Page.web;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Page { camera, gallery, web }

extension _PageExt on _Page {
  static final widgets = <_Page, Widget>{
    _Page.camera: CameraScreen(),
    _Page.gallery: const Center(child: Text('gallery here')),
    _Page.web: const Center(child: Text('web here')),
  };

  Widget get widget => widgets[this] ?? const Text('not implemented');
}
