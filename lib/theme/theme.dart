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
    backgroundColor: AppColors.milkBanana,
    foregroundColor: AppColors.brightBlack,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.coffee,
    elevation: 0,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: AppColors.banana,
    elevation: 0,
    shape: CircularNotchedRectangle(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    primary: AppColors.coffee,
  )),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    primary: AppColors.coffee,
  )),
);

final darkTheme = lightTheme.copyWith(
  brightness: Brightness.dark,
);

extension ColorSchemeExt on ColorScheme {
  Color get secondaryButtonPrimary => _setColor(
    light: AppColors.milkCoffee,
  );
  Color get secondaryButtonText => _setColor(
    light: Colors.brown,
  );

  Color get navButtonColor => _setColor(
    light: Colors.brown,
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
