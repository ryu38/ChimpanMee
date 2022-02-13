import 'package:camera/camera.dart';
import 'package:chimpanmee/l10n/l10n.dart';
import 'package:chimpanmee/theme/color.dart';
import 'package:chimpanmee/ui/home/camera/camera.dart';
import 'package:chimpanmee/ui/home/camera/camera_appbar.dart';
import 'package:chimpanmee/ui/home/camera/camera_state.dart';
import 'package:chimpanmee/ui/home/gallery/gallery.dart';
import 'package:chimpanmee/ui/home/gallery/gallery_appbar.dart';
import 'package:chimpanmee/ui/home/gallery/gallery_state.dart';
import 'package:chimpanmee/ui/home/home_states/page_state.dart';
import 'package:chimpanmee/ui/home/web/web.dart';
import 'package:chimpanmee/ui/home/web/web_appbar.dart';
import 'package:chimpanmee/utlis/debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chimpanmee/theme/theme.dart';

class HomeScaff extends ConsumerStatefulWidget {
  const HomeScaff({Key? key, required this.title}) : super(key: key);

  final String title;

  static const route = '/';

  @override
  ConsumerState<HomeScaff> createState() => _HomeScaffState();
}

class _HomeScaffState extends ConsumerState<HomeScaff> {
  HomeStateNotifier get homeNotifier => ref.read(homeStateProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final currentPage =
        ref.watch(homeStateProvider.select((v) => v.currentPage));

    return Scaffold(
      appBar: currentPage.widgets.appBarGenerator(context, ref),
      body: currentPage.widgets.body,
      floatingActionButton: const _FAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true, // transparent fab notch
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

class _FAB extends ConsumerStatefulWidget {
  const _FAB({Key? key}) : super(key: key);

  @override
  __FABState createState() => __FABState();
}

class __FABState extends ConsumerState<_FAB> with TickerProviderStateMixin {
  late final _sizeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final _sizeAnimation = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 72, end: 48), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 48, end: 40), weight: 1.5),
    TweenSequenceItem(tween: Tween(begin: 40, end: 48), weight: 1.5),
    TweenSequenceItem(tween: Tween(begin: 48, end: 60), weight: 1),
  ]).animate(_sizeController);

  late final _rotationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );
  late final _rotationAnimation =
      Tween<double>(begin: 0, end: -0.5).animate(_rotationController);

  bool _isSwitching = false;

  Future<void> _fabAction(Reader read) async {
    if (_isSwitching) return;
    final currentPage = read(homeStateProvider).currentPage;
    if (currentPage == AppPage.camera) {
      read(cameraStateProvider).controller.whenData((value) async {
        _isSwitching = true;
        await read(cameraStateProvider.notifier).switchCamera();
        _rotationController.forward().then((_) => _rotationController.reset());
        _isSwitching = false;
      });
    } else {
      read(homeStateProvider.notifier).moveToPage(AppPage.camera);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCameraOpened =
        ref.watch(homeStateProvider.select((v) => v.currentPage)) ==
            AppPage.camera;

    ref.listen<AppPage>(homeStateProvider.select((v) => v.currentPage),
        (_, next) {
      if (next == AppPage.camera) {
        debugLog('detect camera open in fab');
        _sizeController.forward();
      } else {
        debugLog('close camera animation');
        _sizeController.reset();
      }
    });

    final isKeyboardClosed = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Visibility(
      visible: isKeyboardClosed,
      child: AnimatedBuilder(
        animation: _sizeAnimation,
        builder: (context, child) {
          return SizedBox(
            width: _sizeAnimation.value,
            child: child,
          );
        },
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              await _fabAction(ref.read);
            },
            child: !isCameraOpened
                ? const Icon(Icons.photo_camera)
                : RotationTransition(
                    turns: _rotationAnimation, child: const Icon(Icons.cached)),
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final homeNotifier = ref.read(homeStateProvider.notifier);
    return BottomAppBar(
      notchMargin: 12,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _NavButton(
                defaultIcon: Icons.photo_library_outlined,
                activeIcon: Icons.photo_library,
                labelText: l10n.navBarGallery,
                targetPage: AppPage.gallery,
                onPressed: () {
                  homeNotifier.moveToPage(AppPage.gallery);
                },
                reverse: true,
              ),
            ),
            const SizedBox(width: 72),
            Expanded(
              child: _NavButton(
                defaultIcon: Icons.public_outlined,
                activeIcon: Icons.public,
                labelText: l10n.navBarWeb,
                targetPage: AppPage.web,
                onPressed: () {
                  homeNotifier.moveToPage(AppPage.web);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends ConsumerWidget {
  const _NavButton({
    Key? key,
    required this.defaultIcon,
    required this.activeIcon,
    required this.labelText,
    required this.targetPage,
    required this.onPressed,
    this.reverse = false,
  }) : super(key: key);

  final IconData defaultIcon;
  final IconData activeIcon;
  final String labelText;
  final AppPage targetPage;
  final void Function()? onPressed;
  final bool reverse;

  double get _padding => 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage =
        ref.watch(homeStateProvider.select((v) => v.currentPage));
    final isPageMatch = currentPage == targetPage;
    final activeColor = Theme.of(context).colorScheme.navButtonColor;
    final widgetList = [
      Icon(
        isPageMatch ? activeIcon : defaultIcon,
        color: isPageMatch ? activeColor : null,
      ),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          labelText,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isPageMatch ? activeColor : null,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    ];

    return GestureDetector(
      onTap: isPageMatch ? null : onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(_padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: reverse ? List.from(widgetList.reversed) : widgetList,
        ),
      ),
    );
  }
}

extension PageExt on AppPage {
  static final _widgets = <AppPage, PageWidgetData>{
    AppPage.camera: PageWidgetData(
      body: CameraScreen(),
      appBarGenerator: cameraAppBarGenerator,
    ),
    AppPage.gallery: PageWidgetData(
      body: GalleryScreen(),
      appBarGenerator: galleryAppBarGenerator,
    ),
    AppPage.web: PageWidgetData(
      body: WebScreen(),
      appBarGenerator: webAppBarGenerator,
    ),
  };

  PageWidgetData get widgets =>
      _widgets[this] ??
      PageWidgetData(
        body: const Center(child: Text('not implemented')),
      );
}

class PageWidgetData {
  PageWidgetData({
    required this.body,
    AppBarGenerator? appBarGenerator,
  }) {
    this.appBarGenerator = appBarGenerator ??
        (context, ref) => AppBar(title: const Text('ChimpanMee'));
  }

  final Widget body;
  late final AppBarGenerator appBarGenerator;
}

typedef AppBarGenerator = AppBar Function(BuildContext context, WidgetRef ref);
