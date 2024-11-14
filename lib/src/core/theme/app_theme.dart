import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/core/assets/fonts.dart';
import 'package:roqqu_assessment/src/core/theme/palette.dart';

abstract class DesignThemes {
  static const Color _lightFocusColor = DesignColorPalette.grey1;
  static const Color _darkFocusColor = DesignColorPalette.darkBlue1;

  static ThemeData lightThemeData =
      _themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = _themeData(darkColorScheme, _darkFocusColor);

  static ThemeData _themeData(ColorScheme colorScheme, Color focusColor) {
    const border = InputBorder.none;

    return ThemeData(
      colorScheme: colorScheme,
      canvasColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.surface,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      fontFamily: FontFamily.satoshi,
      appBarTheme: AppBarTheme(backgroundColor: colorScheme.onSecondary),
      inputDecorationTheme: const InputDecorationTheme(
        border: border,
        errorBorder: border,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        focusedErrorBorder: border,
      ),
    );
  }

  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: DesignColorPalette.primaryColor,
    // primary: DesignColorPalette.primaryColor,
    // onPrimary: Colors.black,
    // secondary: DesignColorPalette.secondaryColor,
    // onSecondary: Colors.black,
    // error: Colors.redAccent,
    // onError: Colors.white,
    // surface: DesignColorPalette.grey1,
    // onSurface: Colors.black,
    brightness: Brightness.light,
  );

  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: DesignColorPalette.secondaryColorDark,
    // onPrimary: Colors.white,
    // secondary: DesignColorPalette.primaryColorDark,
    // onSecondary: DesignColorPalette.darkBlue2,
    // error: Colors.redAccent,
    // onError: Colors.white,
    // surface: DesignColorPalette.surfaceColorDark,
    // onSurface: Colors.white,
    brightness: Brightness.dark,
  );
}
