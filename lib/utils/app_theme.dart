import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF667eea);
  static const Color secondaryColor = Color(0xFF764ba2);
  static const Color accentColor = Color(0xFFff6b35);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE74C3C);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, secondaryColor],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentColor, Color(0xFFf7931e)],
  );

  // Shadows
  static BoxShadow get defaultShadow => BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 10,
        spreadRadius: 2,
        offset: const Offset(0, 2),
      );

  static BoxShadow get cardShadow => BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 15,
        spreadRadius: 3,
        offset: const Offset(0, 5),
      );

  // Border Radius
  static const BorderRadius defaultRadius =
      BorderRadius.all(Radius.circular(15));
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(20));
  static const BorderRadius buttonRadius =
      BorderRadius.all(Radius.circular(25));

  // Spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Font Sizes
  static const double fontSizeXS = 12.0;
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 16.0;
  static const double fontSizeL = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 24.0;

  // Theme Data
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),

        // App Bar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: fontSizeXL,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Card Theme
        cardTheme: CardThemeData(
          elevation: 0,
          color: surfaceColor,
          shape: const RoundedRectangleBorder(borderRadius: defaultRadius),
          shadowColor: Colors.black.withValues(alpha: 0.1),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
                horizontal: paddingL, vertical: paddingM),
            shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: fontSizeM,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(
                horizontal: paddingM, vertical: paddingS),
            textStyle: const TextStyle(
              fontSize: fontSizeM,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceColor,
          border: OutlineInputBorder(
            borderRadius: defaultRadius,
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: defaultRadius,
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: defaultRadius,
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: defaultRadius,
            borderSide: BorderSide(color: errorColor, width: 1),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: defaultRadius,
            borderSide: BorderSide(color: errorColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: paddingM, vertical: paddingM),
          hintStyle: const TextStyle(color: textHint),
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: textSecondary,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontSize: fontSizeXS,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: fontSizeXS,
            fontWeight: FontWeight.w500,
          ),
        ),

        // Text Theme
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: fontSizeXXL,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          displayMedium: TextStyle(
            fontSize: fontSizeXL,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          displaySmall: TextStyle(
            fontSize: fontSizeL,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: fontSizeM,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          headlineSmall: TextStyle(
            fontSize: fontSizeS,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: fontSizeM,
            fontWeight: FontWeight.normal,
            color: textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: fontSizeS,
            fontWeight: FontWeight.normal,
            color: textSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: fontSizeXS,
            fontWeight: FontWeight.normal,
            color: textHint,
          ),
        ),
      );

  // Dark Theme (optional)
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
      );
}
