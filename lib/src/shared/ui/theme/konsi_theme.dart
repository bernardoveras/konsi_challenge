import 'package:flutter/material.dart';

import 'colors/colors.dart';

abstract class KonsiTheme {
  static final ThemeData main = ThemeData(
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: BrandColor.base,
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
      backgroundColor: BrandColor.base,
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData light = main;
  static final ThemeData dark = main.copyWith();
}
