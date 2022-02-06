import 'package:camera/camera.dart';
import 'package:chimpanmee/color.dart';
import 'package:chimpanmee/init_values.dart';
import 'package:chimpanmee/l10n/l10n.dart';
import 'package:chimpanmee/ml/ml_manager.dart';
import 'package:chimpanmee/ui/error_screen.dart';
import 'package:chimpanmee/ui/home/edit/crop/crop.dart';
import 'package:chimpanmee/ui/home/edit/edit.dart';
import 'package:chimpanmee/ui/home/home.dart';
import 'package:chimpanmee/ui/home/preview/preview.dart';
import 'package:chimpanmee/ui/loading_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  String get title => 'ChimpanMee';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
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
        primarySwatch: Colors.brown,
        primaryColor: Colors.brown,
        
        scaffoldBackgroundColor: AppColors.backWhite,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.backWhite,
            statusBarBrightness: Brightness.light, //IOS
            statusBarIconBrightness: Brightness.dark, //Android
          ),
          backgroundColor: AppColors.backWhite,
          foregroundColor: AppColors.brightBlack,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.coffee,
          elevation: 0,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: AppColors.milkBanana,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
        ),
      ),
      initialRoute: '/',
      routes: {
        HomeScaff.route: (_) => ref.watch(initStatusProvider).when(
          data: (_) => HomeScaff(title: title),
          error: (_, __) => const ErrorScreen(),
          loading: () => const LoadingScreen(),
        ),
        PreviewScreen.route: (_) => PreviewScreen(),
        EditScreen.route: (_) => EditScreen(),
        CropScreen.route: (_) => CropScreen(),
      },
    );
  }
}
