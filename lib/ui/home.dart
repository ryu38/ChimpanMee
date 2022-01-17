import 'package:chimpanmee/Color.dart';
import 'package:chimpanmee/l10n/l10n.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _Pages _currentPage = _Pages.gallery;

  GestureDetector _navButton({
    required IconData defaultIcon,
    required IconData activeIcon,
    required String labelText,
    required _Pages targetPage,
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

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Text(l10n.helloWorld),
      ),
      floatingActionButton: SizedBox(
        width: 72,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _currentPage = _Pages.camera;
              });
            },
            child: const Icon(Icons.photo_camera),
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
                targetPage: _Pages.gallery,
                onPressed: () {
                  setState(() {
                    _currentPage = _Pages.gallery;
                  });
                },
                reverse: true,
              ),
              const SizedBox(width: 72),
              _navButton(
                defaultIcon: Icons.web,
                activeIcon: Icons.web_sharp,
                labelText: l10n.navBarWeb,
                targetPage: _Pages.web,
                onPressed: () {
                  setState(() {
                    _currentPage = _Pages.web;
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

enum _Pages { camera, gallery, web }
