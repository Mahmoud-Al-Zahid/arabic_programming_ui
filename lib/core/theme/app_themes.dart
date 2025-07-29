import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeType {
  ocean,
  sunset,
  forest,
  galaxy,
  fire,
  ice,
  light,
  dark,
  blue,
  green,
  purple,
}

class AppThemes {
  static const Map<AppThemeType, Map<String, dynamic>> themeConfigs = {
    AppThemeType.ocean: {
      'name': 'المحيط',
      'icon': '🌊',
      'primary': Color(0xFF2196F3),
      'secondary': Color(0xFF03DAC6),
      'gradient': [Color(0xFF2196F3), Color(0xFF21CBF3)],
    },
    AppThemeType.sunset: {
      'name': 'الغروب',
      'icon': '🌅',
      'primary': Color(0xFFFF6B35),
      'secondary': Color(0xFFF7931E),
      'gradient': [Color(0xFFFF6B35), Color(0xFFF7931E)],
    },
    AppThemeType.forest: {
      'name': 'الغابة',
      'icon': '🌲',
      'primary': Color(0xFF4CAF50),
      'secondary': Color(0xFF8BC34A),
      'gradient': [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    },
    AppThemeType.galaxy: {
      'name': 'المجرة',
      'icon': '🌌',
      'primary': Color(0xFF9C27B0),
      'secondary': Color(0xFF673AB7),
      'gradient': [Color(0xFF9C27B0), Color(0xFF673AB7)],
    },
    AppThemeType.fire: {
      'name': 'النار',
      'icon': '🔥',
      'primary': Color(0xFFE91E63),
      'secondary': Color(0xFFFF5722),
      'gradient': [Color(0xFFE91E63), Color(0xFFFF5722)],
    },
    AppThemeType.ice: {
      'name': 'الجليد',
      'icon': '❄️',
      'primary': Color(0xFF00BCD4),
      'secondary': Color(0xFF2196F3),
      'gradient': [Color(0xFF00BCD4), Color(0xFF2196F3)],
    },
    AppThemeType.light: {
      'name': 'فاتح',
      'icon': '☀️',
      'primary': const Color(0xFF6200EE),
      'secondary': const Color(0xFF03DAC6),
      'background': const Color(0xFFF5F5F5),
      'surface': const Color(0xFFFFFFFF),
      'onPrimary': const Color(0xFFFFFFFF),
      'onSecondary': const Color(0xFF000000),
      'onBackground': const Color(0xFF000000),
      'onSurface': const Color(0xFF000000),
      'error': const Color(0xFFB00020),
      'gradient': [const Color(0xFF6200EE), const Color(0xFF03DAC6)],
    },
    AppThemeType.dark: {
      'name': 'داكن',
      'icon': '🌙',
      'primary': const Color(0xFFBB86FC),
      'secondary': const Color(0xFF03DAC6),
      'background': const Color(0xFF121212),
      'surface': const Color(0xFF1E1E1E),
      'onPrimary': const Color(0xFF000000),
      'onSecondary': const Color(0xFF000000),
      'onBackground': const Color(0xFFFFFFFF),
      'onSurface': const Color(0xFFFFFFFF),
      'error': const Color(0xFFCF6679),
      'gradient': [const Color(0xFFBB86FC), const Color(0xFF03DAC6)],
    },
    AppThemeType.blue: {
      'name': 'أزرق',
      'icon': '🔵',
      'primary': const Color(0xFF2196F3),
      'secondary': const Color(0xFF00BCD4),
      'background': const Color(0xFFE3F2FD),
      'surface': const Color(0xFFFFFFFF),
      'onPrimary': const Color(0xFFFFFFFF),
      'onSecondary': const Color(0xFF000000),
      'onBackground': const Color(0xFF000000),
      'onSurface': const Color(0xFF000000),
      'error': const Color(0xFFB00020),
      'gradient': [const Color(0xFF2196F3), const Color(0xFF00BCD4)],
    },
    AppThemeType.green: {
      'name': 'أخضر',
      'icon': '🟢',
      'primary': const Color(0xFF4CAF50),
      'secondary': const Color(0xFF8BC34A),
      'background': const Color(0xFFE8F5E9),
      'surface': const Color(0xFFFFFFFF),
      'onPrimary': const Color(0xFFFFFFFF),
      'onSecondary': const Color(0xFF000000),
      'onBackground': const Color(0xFF000000),
      'onSurface': const Color(0xFF000000),
      'error': const Color(0xFFB00020),
      'gradient': [const Color(0xFF4CAF50), const Color(0xFF8BC34A)],
    },
    AppThemeType.purple: {
      'name': 'بنفسجي',
      'icon': '🟣',
      'primary': const Color(0xFF9C27B0),
      'secondary': const Color(0xFFBA68C8),
      'background': const Color(0xFFF3E5F5),
      'surface': const Color(0xFFFFFFFF),
      'onPrimary': const Color(0xFFFFFFFF),
      'onSecondary': const Color(0xFF000000),
      'onBackground': const Color(0xFF000000),
      'onSurface': const Color(0xFF000000),
      'error': const Color(0xFFB00020),
      'gradient': [const Color(0xFF9C27B0), const Color(0xFFBA68C8)],
    },
  };

  static ThemeData getTheme(AppThemeType type) {
    final config = themeConfigs[type]!;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        primary: config['primary'],
        secondary: config['secondary'],
        surface: config['surface'] ?? Colors.white,
        background: config['background'] ?? Colors.white,
        error: config['error'] ?? Colors.red,
        onPrimary: config['onPrimary'] ?? Colors.white,
        onSecondary: config['onSecondary'] ?? Colors.black,
        onSurface: config['onSurface'] ?? Colors.black,
        onBackground: config['onBackground'] ?? Colors.black,
        onError: config['onPrimary'] ?? Colors.white,
        brightness: type == AppThemeType.dark ? Brightness.dark : Brightness.light,
      ),
      fontFamily: 'Cairo', // Assuming Cairo is the Arabic font
      textTheme: GoogleFonts.cairoTextTheme(
        type == AppThemeType.dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.cairo(
          fontSize: 57.0,
          fontWeight: FontWeight.bold,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        displayMedium: GoogleFonts.cairo(
          fontSize: 45.0,
          fontWeight: FontWeight.bold,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        displaySmall: GoogleFonts.cairo(
          fontSize: 36.0,
          fontWeight: FontWeight.bold,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        headlineLarge: GoogleFonts.cairo(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        headlineSmall: GoogleFonts.cairo(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        titleLarge: GoogleFonts.cairo(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        titleMedium: GoogleFonts.cairo(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        titleSmall: GoogleFonts.cairo(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        bodyLarge: GoogleFonts.cairo(
          fontSize: 16.0,
          color: type == AppThemeType.dark ? Colors.white70 : Colors.black87,
        ),
        bodyMedium: GoogleFonts.cairo(
          fontSize: 14.0,
          color: type == AppThemeType.dark ? Colors.white70 : Colors.black87,
        ),
        bodySmall: GoogleFonts.cairo(
          fontSize: 12.0,
          color: type == AppThemeType.dark ? Colors.white70 : Colors.black87,
        ),
        labelLarge: GoogleFonts.cairo(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        labelMedium: GoogleFonts.cairo(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
        labelSmall: GoogleFonts.cairo(
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
          color: type == AppThemeType.dark ? Colors.white : Colors.black87,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: config['primary'],
        foregroundColor: config['onPrimary'],
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: config['onPrimary'],
        ),
      ),
      cardTheme: CardThemeData( // Use CardThemeData
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: config['primary'],
          foregroundColor: config['onPrimary'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: config['onPrimary'],
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: config['primary'],
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: config['primary'],
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: config['surface'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: config['primary'], width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: config['primary'].withOpacity(0.3), width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      tabBarTheme: TabBarThemeData( // Corrected to TabBarThemeData
        labelColor: config['onPrimary'],
        unselectedLabelColor: config['onPrimary'].withOpacity(0.7),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: config['onPrimary'], width: 3),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: config['primary'],
        linearTrackColor: config['primary'].withOpacity(0.2),
      ),
    );
  }

  static LinearGradient getGradient(AppThemeType type) {
    final config = themeConfigs[type]!;
    return LinearGradient(
      colors: config['gradient'] as List<Color>,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
