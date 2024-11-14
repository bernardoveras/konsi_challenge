import 'package:flutter/material.dart';

import 'colors/colors.dart';

abstract class KonsiTheme {
  static final ThemeData main = ThemeData(
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      primary: BrandColor.base,
      seedColor: BrandColor.base,
    ),
    scaffoldBackgroundColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    primaryColor: BrandColor.base,
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        fixedSize: const WidgetStatePropertyAll(
          Size.fromHeight(56),
        ),
        backgroundColor: WidgetStatePropertyAll(BrandColor.base),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(BrandColor.base),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: BrandColor.base,
      foregroundColor: Colors.white,
      shape: const CircleBorder(),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: BrandColor.base,
    ),
    indicatorColor: BrandColor.base,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.0),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey.shade900,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade900,
      ),
    ),
    searchBarTheme: SearchBarThemeData(
  backgroundColor:  WidgetStatePropertyAll(Colors.grey.shade200),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  static final ThemeData light = main;
  static final ThemeData dark = main.copyWith();
}
