import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_probe/common/themes/app_colors.dart';

class AppTheme {
  static void systemUiOverlay = SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  static ThemeData themeData = ThemeData(
    useMaterial3: false,
    primarySwatch: Colors.indigo,
    brightness: Brightness.light,
  ).copyWith(
    primaryColor: AppColors.primaryColor,
    datePickerTheme: DatePickerThemeData(
      headerBackgroundColor: AppColors.primaryColor,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,

    /// Icon
    iconTheme: IconThemeData(color: AppColors.primaryColor),

    /// AppBar
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.black),
    ),

    /// Text
    textTheme: buildTextTheme(ThemeData.light().textTheme),

    /// Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll<Color>(Colors.indigo),
    ),
  );
}

String fontName = "Nunito";

TextTheme buildTextTheme(TextTheme base) {
  return TextTheme(
    /// Body Text
    bodySmall: TextStyle(
      fontFamily: fontName,
      height: 1.33,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontName,
      height: 1.43,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontName,
      height: 1.5,
      color: Colors.black,
    ),

    /// Label Text
    labelSmall: TextStyle(
      fontFamily: fontName,
      height: 1.45,
      color: Colors.black,
    ),
    labelMedium: TextStyle(
      fontFamily: fontName,
      height: 1.33,
      color: Colors.black,
    ),
    labelLarge: TextStyle(
      fontFamily: fontName,
      height: 1.43,
      color: Colors.black,
    ),

    /// Title Text
    titleSmall: TextStyle(
      fontFamily: fontName,
      height: 1.43,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontFamily: fontName,
      height: 1.5,
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      fontFamily: fontName,
      height: 1.27,
      color: Colors.black,
    ),

    /// Headline Text
    headlineSmall: TextStyle(
      fontFamily: fontName,
      height: 1.33,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontName,
      height: 1.29,
      color: Colors.black,
    ),
    headlineLarge: TextStyle(
      fontFamily: fontName,
      height: 1.25,
      color: Colors.black,
    ),

    /// Display Text
    displaySmall: TextStyle(
      fontFamily: fontName,
      height: 1.22,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontFamily: fontName,
      height: 1.16,
      color: Colors.black,
    ),
    displayLarge: TextStyle(
      fontFamily: fontName,
      height: 1.12,
      color: Colors.black,
    ),
  );
}
