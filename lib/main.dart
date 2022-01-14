import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  late String _buildMode;
  String? _packageName;
  String? _appName;

  @override
  void initState() {
    super.initState();
    loadPackageName();
    setState(() {
      _buildMode = kDebugMode ? 'debug' : 'release';
    });
  }

  Future<void> loadPackageName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageName = packageInfo.packageName;
      _appName = packageInfo.appName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Text(_buildMode),
            Text(_packageName ?? 'loading...'),
            Text(_appName ?? ''),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
