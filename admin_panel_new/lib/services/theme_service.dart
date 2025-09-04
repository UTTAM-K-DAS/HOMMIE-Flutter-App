import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'app_theme_mode';
  static const String _primaryColorKey = 'app_primary_color';

  // App Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryTeal = Color(0xFF009688);
  static const Color primaryIndigo = Color(0xFF3F51B5);
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color primaryRed = Color(0xFFf44336);

  // Initialize service
  Future<void> initialize() async {
    // Theme service initialization if needed
  }

  // Theme configurations
  static ThemeData lightTheme(Color primaryColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Poppins',

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: colorScheme.primary),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'Poppins',
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: 'Poppins',
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'Poppins',
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: colorScheme.onInverseSurface,
          fontFamily: 'Poppins',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          fontFamily: 'Poppins',
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'Poppins',
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData darkTheme(Color primaryColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Poppins',

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: colorScheme.surfaceContainer,
      ),

      // Button Themes (similar to light theme with dark colors)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  // Save theme mode to preferences
  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode.toString());
  }

  // Load theme mode from preferences
  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeKey);

    switch (themeModeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  // Save primary color to preferences
  static Future<void> savePrimaryColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_primaryColorKey, color.toARGB32());
  }

  // Load primary color from preferences
  static Future<Color> loadPrimaryColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_primaryColorKey);
    return colorValue != null ? Color(colorValue) : primaryBlue;
  }

  // Get available theme colors
  static List<Color> getAvailableColors() {
    return [
      primaryBlue,
      primaryTeal,
      primaryIndigo,
      primaryPurple,
      primaryGreen,
      primaryOrange,
      primaryRed,
    ];
  }

  // Get color name
  static String getColorName(Color color) {
    switch (color.toARGB32()) {
      case 0xFF2196F3:
        return 'Blue';
      case 0xFF009688:
        return 'Teal';
      case 0xFF3F51B5:
        return 'Indigo';
      case 0xFF9C27B0:
        return 'Purple';
      case 0xFF4CAF50:
        return 'Green';
      case 0xFFFF9800:
        return 'Orange';
      case 0xFFf44336:
        return 'Red';
      default:
        return 'Custom';
    }
  }
}

// Theme Provider for state management
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = ThemeService.primaryBlue;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  ThemeData get lightTheme => ThemeService.lightTheme(_primaryColor);
  ThemeData get darkTheme => ThemeService.darkTheme(_primaryColor);

  // Initialize theme settings
  Future<void> initialize() async {
    _themeMode = await ThemeService.loadThemeMode();
    _primaryColor = await ThemeService.loadPrimaryColor();
    notifyListeners();
  }

  // Update theme mode
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await ThemeService.saveThemeMode(themeMode);
    notifyListeners();
  }

  // Update primary color
  Future<void> updatePrimaryColor(Color color) async {
    _primaryColor = color;
    await ThemeService.savePrimaryColor(color);
    notifyListeners();
  }
}
