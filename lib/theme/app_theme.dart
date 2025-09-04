import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: Color(0xFF667eea),
      primarySwatch: MaterialColor(0xFF667eea, {
        50: Color(0xFFeef0fd),
        100: Color(0xFFd4dbfb),
        200: Color(0xFFb9c5f9),
        300: Color(0xFF9eb0f7),
        400: Color(0xFF839bf5),
        500: Color(0xFF667eea),
        600: Color(0xFF5c71d1),
        700: Color(0xFF4858a3),
        800: Color(0xFF344075),
        900: Color(0xFF202747),
      }),
      scaffoldBackgroundColor: Color(0xFFF8F9FA),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF667eea),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Color(0xFF667eea)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xFF667eea),
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  static LinearGradient get primaryGradient {
    return LinearGradient(
      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient get secondaryGradient {
    return LinearGradient(
      colors: [Color(0xFFff6b35), Color(0xFFf7931e)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static BoxShadow get defaultShadow {
    return BoxShadow(
      color: Colors.black.withAlpha(26),
      blurRadius: 8,
      offset: Offset(0, 2),
    );
  }
}
