import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: AppColors.background,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      surfaceTint: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyles.headingLarge,
      titleMedium: TextStyles.headingMedium,
      bodyLarge: TextStyles.bodyLarge,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color(0xFF121212),
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Color(0xFF121212),
      surfaceTint: Color(0xFF1E1E1E),
      surfaceContainer: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyles.headingLarge.copyWith(color: Colors.white),
      titleMedium: TextStyles.headingMedium.copyWith(color: Colors.white),
      bodyLarge: TextStyles.bodyLarge.copyWith(color: Colors.white70),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  );
}
