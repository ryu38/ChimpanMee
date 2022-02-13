import 'package:chimpanmee/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.brown,
  primaryColor: AppColors.coffee,
  primaryColorDark: Colors.brown,
  scaffoldBackgroundColor: AppColors.milkBanana,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColors.milkBanana,
      statusBarBrightness: Brightness.light, //IOS
      statusBarIconBrightness: Brightness.dark, //Android
    ),
    titleTextStyle: TextStyle(
      color: AppColors.brightBlack,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    centerTitle: false,
    backgroundColor: AppColors.milkBanana,
    foregroundColor: AppColors.brightBlack,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.coffee,
    elevation: 0,
    highlightElevation: 0,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: AppColors.banana,
    elevation: 0,
    shape: CircularNotchedRectangle(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: AppColors.coffee,
    ).merge(ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0),
    )),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: AppColors.coffee,
    ),
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  primaryColor: AppColors.ripeBanana,
  scaffoldBackgroundColor: AppColors.blackCoffee,
  appBarTheme: lightTheme.appBarTheme.copyWith(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: AppColors.blackCoffee,
      statusBarBrightness: Brightness.dark, //IOS
      statusBarIconBrightness: Brightness.light, //Android
    ),
    titleTextStyle: lightTheme.appBarTheme.titleTextStyle?.copyWith(
      color: AppColors.white,
    ),
    backgroundColor: AppColors.blackCoffee,
    foregroundColor: AppColors.white,
  ),
  floatingActionButtonTheme: lightTheme.floatingActionButtonTheme.copyWith(
    backgroundColor: AppColors.ripeBanana,
  ),
  bottomAppBarTheme: lightTheme.bottomAppBarTheme.copyWith(
    color: AppColors.darkCoffee,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: AppColors.ripeBanana,
      onPrimary: Colors.black,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: AppColors.ripeBanana,
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.ripeBanana,
  ),
);

extension ColorSchemeExt on ColorScheme {
  Color get secondaryButtonPrimary => _setColor(
    light: AppColors.banana,
    dark: AppColors.darkCoffee,
  );
  Color get secondaryButtonText => _setColor(
    light: Colors.brown,
    dark: Colors.yellow,
  );

  Color get navButtonColor => _setColor(
    light: Colors.brown,
    dark: Colors.yellow,
  );

  Color _setColor({
    required Color light,
    Color? dark,
  }) =>
      dark == null
          ? light
          : brightness == Brightness.light
              ? light
              : dark;
}
