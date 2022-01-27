import 'package:chimpanmee/l10n/l10n.dart';
import 'package:chimpanmee/ui/home/camera/camera.dart';
import 'package:chimpanmee/ui/home/camera/camera_state.dart';
import 'package:chimpanmee/ui/home/gallery/gallery.dart';
import 'package:chimpanmee/ui/home/gallery/gallery_appbar.dart';
import 'package:chimpanmee/ui/home/gallery/gallery_state.dart';
import 'package:chimpanmee/ui/home/home_states/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScaff extends ConsumerStatefulWidget {
  const HomeScaff({Key? key, required this.title}) : super(key: key);

  final String title;

  static const route = '/';

  @override
  ConsumerState<HomeScaff> createState() => _HomeScaffState();
}

class _HomeScaffState extends ConsumerState<HomeScaff> {

  HomeStateNotifier get homeNotifier => 
      ref.read(homeStateProvider.notifier);

  GestureDetector _navButton({
    required IconData defaultIcon,
    required IconData activeIcon,
    required String labelText,
    required AppPage targetPage,
    required void Function()? onPressed,
    bool reverse = false,
  }) {
    final currentPage = ref.read(homeStateProvider).currentPage;
    final isPageMatch = currentPage == targetPage;
    final activeColor = Theme.of(this.context).primaryColor;
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

  Future<void> _fabAction(Reader read) async {
    final currentPage = read(homeStateProvider).currentPage;
    if (currentPage == AppPage.camera) {
      if (read(cameraStateProvider).initialized) {
        await read(cameraStateProvider.notifier).switchCamera();
      }
    } else {
      homeNotifier.moveToPage(AppPage.camera);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final currentPage = 
        ref.watch(homeStateProvider.select((v) => v.currentPage));

    return Scaffold(
      appBar: currentPage.widgets.appBarGenerator(ref),
      body: currentPage.widgets.body,
      floatingActionButton: SizedBox(
        width: 72,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              await _fabAction(ref.read);
            },
            child: currentPage != AppPage.camera 
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
                targetPage: AppPage.gallery,
                onPressed: () {
                  homeNotifier.moveToPage(AppPage.gallery);
                },
                reverse: true,
              ),
              const SizedBox(width: 72),
              _navButton(
                defaultIcon: Icons.web,
                activeIcon: Icons.web_sharp,
                labelText: l10n.navBarWeb,
                targetPage: AppPage.web,
                onPressed: () {
                  setState(() {
                    homeNotifier.moveToPage(AppPage.web);
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

extension PageExt on AppPage {
  static final _widgets = <AppPage, PageWidgetData>{
    AppPage.camera: PageWidgetData(
      body: CameraScreen(),
    ),
    AppPage.gallery: PageWidgetData(
      body: GalleryScreen(),
      appBarGenerator: galleryAppBarGenerator,
    ),
    AppPage.web: PageWidgetData(
      body: const Center(child: Text('web here')),
    ),
  };

  PageWidgetData get widgets => _widgets[this] ?? 
      PageWidgetData(
        body: const Center(child: Text('web here')),
      );
}

class PageWidgetData {
  PageWidgetData({
    required this.body,
    AppBarGenerator? appBarGenerator,
  }) {
    this.appBarGenerator = appBarGenerator 
        ?? (ref) => AppBar(title: const Text('ChimpanMee'));
  }

  final Widget body;
  late final AppBarGenerator appBarGenerator;
}

typedef AppBarGenerator = AppBar Function(WidgetRef ref);
