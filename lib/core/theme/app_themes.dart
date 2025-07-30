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
  /// fallback colors to prevent null errors
  static const Map<String, dynamic> _defaultColors = {
    'primary': Colors.blue,
    'secondary': Colors.teal,
    'background': Colors.white,
    'surface': Colors.white,
    'onPrimary': Colors.white,
    'onSecondary': Colors.black,
    'onBackground': Colors.black,
    'onSurface': Colors.black,
    'error': Colors.red,
    'gradient': [Colors.blue, Colors.teal],
  };

  /// Theme configurations for all theme types
  static const Map<AppThemeType, Map<String, dynamic>> _rawThemes = {
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
    // بقية الثيمات الكاملة
    AppThemeType.light: {
      'name': 'فاتح',
      'icon': '☀️',
      'primary': Color(0xFF6200EE),
      'secondary': Color(0xFF03DAC6),
      'background': Color(0xFFF5F5F5),
      'surface': Color(0xFFFFFFFF),
      'onPrimary': Color(0xFFFFFFFF),
      'onSecondary': Color(0xFF000000),
      'onBackground': Color(0xFF000000),
      'onSurface': Color(0xFF000000),
      'error': Color(0xFFB00020),
      'gradient': [Color(0xFF6200EE), Color(0xFF03DAC6)],
    },
    AppThemeType.dark: {
      'name': 'داكن',
      'icon': '🌙',
      'primary': Color(0xFFBB86FC),
      'secondary': Color(0xFF03DAC6),
      'background': Color(0xFF121212),
      'surface': Color(0xFF1E1E1E),
      'onPrimary': Color(0xFF000000),
      'onSecondary': Color(0xFF000000),
      'onBackground': Color(0xFFFFFFFF),
      'onSurface': Color(0xFFFFFFFF),
      'error': Color(0xFFCF6679),
      'gradient': [Color(0xFFBB86FC), Color(0xFF03DAC6)],
    },
    AppThemeType.blue: {
      'name': 'أزرق',
      'icon': '🔵',
      'primary': Color(0xFF2196F3),
      'secondary': Color(0xFF00BCD4),
      'background': Color(0xFFE3F2FD),
      'surface': Color(0xFFFFFFFF),
      'onPrimary': Color(0xFFFFFFFF),
      'onSecondary': Color(0xFF000000),
      'onBackground': Color(0xFF000000),
      'onSurface': Color(0xFF000000),
      'error': Color(0xFFB00020),
      'gradient': [Color(0xFF2196F3), Color(0xFF00BCD4)],
    },
    AppThemeType.green: {
      'name': 'أخضر',
      'icon': '🟢',
      'primary': Color(0xFF4CAF50),
      'secondary': Color(0xFF8BC34A),
      'background': Color(0xFFE8F5E9),
      'surface': Color(0xFFFFFFFF),
      'onPrimary': Color(0xFFFFFFFF),
      'onSecondary': Color(0xFF000000),
      'onBackground': Color(0xFF000000),
      'onSurface': Color(0xFF000000),
      'error': Color(0xFFB00020),
      'gradient': [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    },
    AppThemeType.purple: {
      'name': 'بنفسجي',
      'icon': '🟣',
      'primary': Color(0xFF9C27B0),
      'secondary': Color(0xFFBA68C8),
      'background': Color(0xFFF3E5F5),
      'surface': Color(0xFFFFFFFF),
      'onPrimary': Color(0xFFFFFFFF),
      'onSecondary': Color(0xFF000000),
      'onBackground': Color(0xFF000000),
      'onSurface': Color(0xFF000000),
      'error': Color(0xFFB00020),
      'gradient': [Color(0xFF9C27B0), Color(0xFFBA68C8)],
    },
  };

  /// safely get the merged config with fallback
  static Map<String, dynamic> _getConfig(AppThemeType type) {
    return {..._defaultColors, ..._rawThemes[type]!};
  }

  static ThemeData getTheme(AppThemeType type) {
    final config = _getConfig(type);

    final isDark = type == AppThemeType.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        primary: config['primary'],
        secondary: config['secondary'],
        surface: config['surface'],
        background: config['background'],
        error: config['error'],
        onPrimary: config['onPrimary'],
        onSecondary: config['onSecondary'],
        onSurface: config['onSurface'],
        onBackground: config['onBackground'],
        onError: config['onPrimary'],
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      fontFamily: 'Cairo',
      textTheme: GoogleFonts.cairoTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: config['primary'],
          foregroundColor: config['onPrimary'],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: config['primary'],
          textStyle: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
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
      tabBarTheme: TabBarTheme(
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
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static LinearGradient getGradient(AppThemeType type) {
    final config = _getConfig(type);
    return LinearGradient(
      colors: List<Color>.from(config['gradient']),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
