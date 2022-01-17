import 'package:chimpanmee/color.dart';
import 'package:chimpanmee/l10n/l10n.dart';
import 'package:chimpanmee/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  String get title => 'ChimpanMee';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
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
        primarySwatch: Colors.green,
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
      home: HomePage(title: title),
    );
  }
}
