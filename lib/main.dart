import 'package:chimpanmee/l10n/l10n.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          final _locale = Locale(locale.languageCode);
          if (supportedLocales.contains(_locale)) {
            return _locale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(l10n.helloWorld),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.photo_camera),
            label: l10n.navBarCamera,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.insert_photo),
            label: l10n.navBarGallery,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.web),
            label: l10n.navBarWeb,
          ),
        ],
      ),
    );
  }
}
